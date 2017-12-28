/*******************************************************************************
** ? Copyright 2010 - 2011 Xilinx, Inc. All rights reserved.
** This file contains confidential and proprietary information of Xilinx, Inc. and
** is protected under U.S. and international copyright and other intellectual property laww
w
s.
*******************************************************************************
**   ____  ____
**  /   /\/   /
** /___/  \  /   Vendor: Xilinx
** \   \   \/
**  \   \
**  /   /
** /___/   /\
** \   \  /  \   Virtex-7 XT Connectivity Domain Targeted Reference Design
**  \___\/\___\
**
**  Device: xc7k325t-ffg900-2
**  Version: 1.0
**
*******************************************************************************
**
*******************************************************************************/

/******************************************************************************
The module performs address filtering on the receive. The receive logic FSM detects
a good frame and makes it available to the packet FIFO interface. Two state machines
are implemented: one FSM covers the write data from XGEMAC interface and another FSM controls 
the read logic to packet FIFO
*******************************************************************************/

`timescale 1ps / 1ps

module niu_rx #(
    parameter      FIFO_CNT_WIDTH = 11
)
(
    input          reset,
    input          soft_reset, 
    input          user_clk,
    input          mac_id_filter_en,
    input          mac_id_valid,
    input  [47:0]  mac_id,
    input [63:0]   s_axis_tdata,
    input [7:0]    s_axis_tkeep,
    input          s_axis_tvalid,
    input          s_axis_tlast,
    input          s_axis_tuser,
    input          m_axis_tready,
    output [63:0]  m_axis_tdata,   
    output [7:0]   m_axis_tkeep,   
    output         m_axis_tvalid,
    output         m_axis_tlast,
    output [15:0]  rd_pkt_len,
    output reg     rx_fifo_overflow = 1'b0,
    input  [29:0]  rx_statistics_vector,
    input          rx_statistics_valid,
    output [FIFO_CNT_WIDTH-1:0]  rd_data_count 
);

  wire                       broadcast_detect;
  wire                       unicast_match;
  wire                       da_match ;
  
  wire                       axis_rd_tlast;
  wire                       axis_rd_tvalid;
  wire [63:0]                axis_rd_tdata;
  wire [7:0]                 axis_rd_tkeep;
  wire                       axis_wr_tlast;
  wire                       axis_wr_tvalid;
  wire [63:0]                axis_wr_tdata;
  wire [7:0]                 axis_wr_tkeep;
  
  wire                       cmd_fifo_full;
  wire                       cmd_fifo_empty;
  reg  [15:0]                cmd_in = 'd0;
  reg                        cmd_fifo_wr=1'b0;
  reg                        cmd_fifo_rd=1'b0;
  
  wire                       valid_cmd;
  wire                       crc_pass;
  wire [15:0]                cmd_out;
  wire                       axis_wr_tready;
  wire [FIFO_CNT_WIDTH-1:0]  wr_data_count ;
  wire [FIFO_CNT_WIDTH-1:0]  left_over_space_in_fifo; 
  wire                       wr_reached_threshold;
  wire                       wr_reached_threshold_extend;
  reg [47:0]                 mac_id_1d;
  reg                        mac_id_valid_1d;
  reg [47:0]                 mac_id_sync;
  reg                        mac_id_valid_sync;
  wire                       frame_len_ctr_valid;

  reg  [63:0]  s_axis_tdata_r ;
  reg  [7:0]   s_axis_tkeep_r ;
  reg          s_axis_tvalid_r;
  reg          s_axis_tlast_r ;
  reg          s_axis_tuser_r ;
  reg          force_tlast_to_fifo='d0 ;
  reg          assert_rd='d0;
  reg          axis_rd_tready='d0 ;
  reg          axis_rd_tvalid_from_fsm=1'b0;
  reg  [3:0]   tkeep_decoded_value;
  reg  [12:0]  rd_pkt_len_count='d0;
  reg  [13:0]  rx_stats_vec_reg='d0;

  reg  [3:0]   frame_len_ctr;
 
localparam
   //states for Write FSM
   IDLE_WR       = 4'b0001,
   DA_DECODE     = 4'b0010,
   BEGIN_WRITE   = 4'b0100,
   DROP_FRAME    = 4'b1000,
   
   //states for Read FSM
   IDLE_RD         = 4'b0001,
   PREP_READ       = 4'b0010, 
   BEGIN_READ      = 4'b0100;

localparam   THRESHOLD           = 200;
localparam   THRESHOLD_EXT       = 400;

  reg  [3:0]   state_wr = IDLE_WR;
  reg  [3:0]   state_rd = IDLE_RD;


  //Synchronize mac_id, and mac_id_valid with the destination clock
  always @(posedge reset,posedge user_clk)
  begin
  		if (reset) begin
         mac_id_1d         <= 48'b0;
         mac_id_sync       <= 48'b0;
         mac_id_valid_1d   <= 1'b0;
         mac_id_valid_sync <= 1'b0;
      end else begin  			
         mac_id_1d         <= mac_id;
         mac_id_sync       <= mac_id_1d;
         mac_id_valid_1d   <= mac_id_valid;
         mac_id_valid_sync <= mac_id_valid_1d;
      end
  end
    
  //Add a pipelining stage for received data from xgemac interface.
  //This is necessary for FSM control logic
  always @(posedge reset,posedge user_clk)
  begin
  		if (reset) begin
         s_axis_tdata_r   <= 64'b0;
         s_axis_tkeep_r   <= 8'b0;
         s_axis_tvalid_r  <= 1'b0;
         s_axis_tlast_r   <= 1'b0;
         s_axis_tuser_r   <= 1'b0;
      end else begin  			
         s_axis_tdata_r   <= s_axis_tdata;
         s_axis_tkeep_r   <= s_axis_tkeep;
         s_axis_tvalid_r  <= s_axis_tvalid;
         s_axis_tlast_r   <= s_axis_tlast;
         s_axis_tuser_r   <= s_axis_tuser;
      end
  end
 
  //Register Rx statistics vector to be used in the read FSM later
  //Rx statistics is valid only if rx_statistics_valid is asserted
  //from XGEMAC 
  //- bits 18:5 in stats vector provide frame length including FCS, hence
  //subtract 4 bytes to get the frame length only.
  always @(posedge reset,posedge user_clk)
  begin
       if(reset)
             rx_stats_vec_reg<=14'b0;
       else if(rx_statistics_valid)
             rx_stats_vec_reg <= rx_statistics_vector[18:5] - 3'd4;
  end

  assign broadcast_detect = ( s_axis_tdata_r[47:0]== {48{1'b1}})  ? 1'b1 : 1'b0;
  assign unicast_match    = ((s_axis_tdata_r[47:0]== mac_id_sync) && mac_id_valid_sync) ? 1'b1 : 1'b0;
  assign da_match         = ((mac_id_filter_en== 1'b0) || broadcast_detect || unicast_match) ? 1'b1 : 1'b0;
 
  assign axis_wr_tvalid = (state_wr==DROP_FRAME) ? 1'b0 : (s_axis_tvalid_r | (force_tlast_to_fifo & (state_wr == BEGIN_WRITE))); 
  assign axis_wr_tlast  = (s_axis_tlast_r | force_tlast_to_fifo); 
  assign axis_wr_tkeep  = s_axis_tkeep_r; 
  assign axis_wr_tdata  = s_axis_tdata_r;

  assign left_over_space_in_fifo = {1'b1,{(FIFO_CNT_WIDTH-1){1'b0}}} - wr_data_count[FIFO_CNT_WIDTH-1:0];
  assign wr_reached_threshold        = (left_over_space_in_fifo < THRESHOLD)?1'b1:1'b0;
  assign wr_reached_threshold_extend = (left_over_space_in_fifo < THRESHOLD_EXT)?1'b1:1'b0;

  always @(posedge reset,posedge user_clk)
  begin
  	    if(reset)
  	         force_tlast_to_fifo<=1'b0;
        else if(force_tlast_to_fifo)
             force_tlast_to_fifo <= 1'b0;
        else if(wr_reached_threshold & !(s_axis_tlast & s_axis_tvalid))
             force_tlast_to_fifo <= 1'b1;
  end

  // Counter to count frame length when length is less than 64B
  // For frame length less than 64B, XGEMAC core reports length including the
  // padded characters. To overcome this situation, a separate counter is implemented
  always @(posedge reset,posedge user_clk)
  begin
        if (reset)
            frame_len_ctr <= 'd0;
        else if (s_axis_tlast & s_axis_tvalid)
            frame_len_ctr <= 'd0;
        else if (frame_len_ctr > 4'h8)
            frame_len_ctr <= frame_len_ctr;
        else if(s_axis_tvalid)
            frame_len_ctr <= frame_len_ctr+1;
  end

  assign frame_len_ctr_valid = (frame_len_ctr != 0) & (frame_len_ctr < 8) & s_axis_tvalid & s_axis_tlast;

  // Decoder for TKEEP signal
  always @(s_axis_tkeep)
   case(s_axis_tkeep) 
      'h00 : tkeep_decoded_value <= 'd0;
      'h01 : tkeep_decoded_value <= 'd1;
      'h03 : tkeep_decoded_value <= 'd2;
      'h07 : tkeep_decoded_value <= 'd3;
      'h0F : tkeep_decoded_value <= 'd4;
      'h1F : tkeep_decoded_value <= 'd5;
      'h3F : tkeep_decoded_value <= 'd6;
      'h7F : tkeep_decoded_value <= 'd7;
      'hFF : tkeep_decoded_value <= 'd8;
      default : tkeep_decoded_value <= 'h00;
   endcase

  //Two FIFOs are implemented: one for XGEMAC data(data FIFO) and the other for controlling 
  //read side command(command FIFO). 
  //Write FSM: 6 states control the entire write operation
  //cmd_in is an input to the command FIFO and controls the read side command
  //Ethernet packet frame size is available from Rx statistics vector and is
  //made available to the read side through command FIFO
  //FSM states:
  //IDLE_WR  : Wait in this state until valid is received from XGEMAC. If the 
  //           data FIFO is full or tready is de-asserted from FIFO interface
  //           it drops the current frame from XGEMAC
  //DA_DECODE: Destination Address from XGEMAC is decoded in this state. If destination
  //           address matches with MAC address or promiscuous mode is enabled
  //           or broadcast is detected, next state is BEGIN_WRITE. Else the FSM transitions
  //           to IDLE_WR state                 
  //BEGIN_WRITE: The FSM continues to write data into data FIFO until tlast from XGEMAC is hit.
  //             FSM transitions to CHECK_ERROR state if tlast has arrived  
  //DROP_FRAME: The FSM enters into this state if the data FIFO is full or tready from data FIFO is de-asserted
  //            In this state, tvalid to FIFO is de-asserted
always @(posedge user_clk)
  begin
         if(reset)
                 state_wr   <= IDLE_WR;
                 cmd_in     <='b0;
                 cmd_fifo_wr<=1'b0;
         else begin
             case(state_wr)
                  IDLE_WR : begin
                                 cmd_in           <= 'b0;
                                 cmd_fifo_wr      <= 1'b0;
                                 
                                 if(s_axis_tvalid & (cmd_fifo_full | wr_reached_threshold)) begin
                                      state_wr  <=  DROP_FRAME;
                                 end else if(s_axis_tvalid) begin
                                      state_wr  <=  DA_DECODE;
                                 end else begin
                                      state_wr   <=  IDLE_WR;
                                 end
                             end
                  DA_DECODE :begin
                                 cmd_fifo_wr <= 1'b0; 
                                 cmd_in[1]   <= 1'b1;
                                 state_wr    <= BEGIN_WRITE;
                             end
                  BEGIN_WRITE:begin
                                 cmd_in[15:2] <= frame_len_ctr_valid ? ((frame_len_ctr << 3) + tkeep_decoded_value) : rx_stats_vec_reg;
                                 
                                 if(force_tlast_to_fifo) begin
                                        cmd_fifo_wr <= 1'b1; 
                                        cmd_in[0]   <= 1'b0;
                                        state_wr    <= DROP_FRAME;  
                                 end else if(s_axis_tlast & s_axis_tvalid)begin
                                        cmd_fifo_wr <= 1'b1; 
                                        cmd_in[0]   <= s_axis_tuser;
                                        state_wr    <= IDLE_WR;  
                                 end else begin
                                        cmd_fifo_wr <= 1'b0; 
                                        cmd_in[0]   <= 1'b0;
                                        state_wr    <= BEGIN_WRITE;
                                 end
                             end
                  DROP_FRAME:begin
                                 cmd_fifo_wr  <= 1'b0; 
                                 
                                 if(s_axis_tlast_r & s_axis_tvalid_r & !wr_reached_threshold_extend) begin
                                    //- signals a back 2 back packet
                                     if(s_axis_tvalid)  
                                        state_wr    <=  DA_DECODE;
                                     else
                                        state_wr    <= IDLE_WR;
                                 end else begin
                                        state_wr    <= DROP_FRAME;
                                 end
                             end
                   default :   state_wr  <= IDLE_WR;
             endcase
          end
  end
                              
  assign  valid_cmd  = cmd_out[1]; 
  assign  crc_pass   = cmd_out[0];
  assign  rd_pkt_len = {2'b0,cmd_out[15:2]};
 
  //Read FSM reads out the data from data FIFO and present it to the packet FIFO interface
  //The read FSM starts reading data from the data FIFO as soon as it decodes a valid command
  //from the command FIFO. Various state transitions are basically controlled by the command FIFO
  //empty flag and tready assertion from packet FIFO interface 
  //FSM states
  //IDLE_RD: The FSM stays in this state until command FIFO empty is de-asserted and tready from packet 
  //         FIFO interface is active low. 
  //PREP_READ: This is an idle cycle, used basically to de-assert rd_en so that command FIFO is read only 
  //             once
  //BEGIN_READ: In this state, the FSM reads data until tlast from XGEMAC is encountered.
  //            If the decoded command from command FIFO is valid and CRC detects no error for the frame,
  //             then the frame is read out and sent to outside.Otherwise,the entire frame is read out and dropped
  always @(posedge user_clk)
  begin
         if(reset) begin
                 state_rd    <= IDLE_RD;
                 cmd_fifo_rd <= 1'b0;
         end else begin
             case(state_rd)
                  IDLE_RD :  begin
                                 if(m_axis_tready & !cmd_fifo_empty) begin
                                      state_rd    <=  PREP_READ;
                                      cmd_fifo_rd <=  1'b1; 
                                 end else begin
                                      state_rd <=  IDLE_RD;
                                 end
                             end 
                  PREP_READ : begin 
                                 cmd_fifo_rd <= 1'b0;
                                 state_rd    <= BEGIN_READ;
                             end
                  BEGIN_READ : begin
                                 if(axis_rd_tlast & axis_rd_tvalid & axis_rd_tready)begin
                                      state_rd   <= IDLE_RD;
                                 end else begin
                                      state_rd   <= BEGIN_READ;
                                 end 
                             end
                  default    :   state_rd   <= IDLE_RD;
             endcase
         end
  end     
 
  always @(state_rd, valid_cmd, crc_pass,axis_rd_tvalid,m_axis_tready)
  begin
       if(state_rd==BEGIN_READ)begin
                if (valid_cmd & crc_pass)begin
                       axis_rd_tready          <= m_axis_tready;
                       axis_rd_tvalid_from_fsm <= axis_rd_tvalid;
                end else begin
                       axis_rd_tready          <= 1'b1;
                       axis_rd_tvalid_from_fsm <= 1'b0;
                end
       end else begin
                axis_rd_tready          <= 1'b0; 
                axis_rd_tvalid_from_fsm <= 1'b0;
       end
  end

  //-Data FIFO instance: AXI Stream Asynchronous FIFO
  //XGEMAC interface outputs an entire frame in a single shot
  //TREADY signal from slave interface of FIFO is left unconnected
  axis_sync_fifo axis_fifo_inst1 (
    .m_axis_tready        (axis_rd_tready           ),
    .s_aresetn            (~reset                   ),
    .s_axis_tready        (axis_wr_tready           ),
    .s_axis_tvalid        (axis_wr_tvalid           ),
    .m_axis_tvalid        (axis_rd_tvalid           ),
    .s_aclk               (user_clk                 ),
    .m_axis_tlast         (axis_rd_tlast            ),
    .s_axis_tlast         (axis_wr_tlast            ),
    .s_axis_tdata         (axis_wr_tdata            ),
    .m_axis_tdata         (axis_rd_tdata            ),
    .s_axis_tkeep         (axis_wr_tkeep            ),
    .m_axis_tkeep         (axis_rd_tkeep            ),
    .axis_data_count   (wr_data_count            ) //1024 items = [10:0]
  );

  //command FIFO interface for controlling the read side interface
  cmd_fifo_xgemac_rxif cmd_fifo_inst (
        .clk         (user_clk      ),
        .rst         (reset         ),
        .din         (cmd_in        ), // Bus [15 : 0]  
        .wr_en       (cmd_fifo_wr   ),
        .rd_en       (cmd_fifo_rd   ),
        .dout        (cmd_out       ), // Bus [15 : 0]  
        .full        (cmd_fifo_full ),
        .empty       (cmd_fifo_empty)
  );

  assign  m_axis_tdata  = axis_rd_tdata; 
  assign  m_axis_tkeep  = axis_rd_tkeep; 
  assign  m_axis_tlast  = axis_rd_tlast; 
  assign  m_axis_tvalid = axis_rd_tvalid_from_fsm; 

 always @(posedge user_clk)
    if (reset | soft_reset)
      rx_fifo_overflow  <= 1'b0;
    else if (state_wr==DROP_FRAME)
      rx_fifo_overflow  <= 1'b1;

endmodule 

