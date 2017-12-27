//////////////////////////////////////////////////////////////////////////////////
// Company: HPB
// Engineer: 
// 
// Create Date: 26.12.2017
// Design Name: 
// Module Name: NIU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module NIU(
    input             reset,
    input             aresetn,

    // 156.25 MHz clock in
    input             xge_refclk_p,
    input             xge_refclk_n,
    
    output            xge_txp,
    output            xge_txn,
    input             xge_rxp,
    input             xge_rxn,
                       
    output[63:0]      rx_axis_tdata,
    output            rx_axis_tvalid,
    output            rx_axis_tlast,
    output            rx_axis_tuser,
    output[7:0]       rx_axis_tkeep,
    input             rx_axis_tready,
    
    input[63:0]       tx_axis_tdata,
    input             tx_axis_tvalid,
    input             tx_axis_tlast,
    input             tx_axis_tuser,
    input[7:0]        tx_axis_tkeep,
    output            tx_axis_tready,
    
    output            clk156_out,
    output            network_reset_done,
 
    output  [7:0]     led 
);



wire[7:0] core_status;

// Shared clk signals
wire gt_txclk322;
wire gt_txusrclk;
wire gt_txusrclk2;
wire gt_qplllock;
wire gt_gpllrefclklost;
wire gt_gplloutrefclk;
wire gt_gplllock_txusrclk2;
wire gttxreset_txusrclk2;
wire gt_txuserrdy;
wire tx_fault;
wire core_reset;
wire gt_tx_resetdone;
wire areset_clk_156_25_bufh;
wire areset_clk_156_25;
wire mmcm_locked_clk156;
wire reset_counter_done;
wire gttxreset;
wire gtrxreset;
wire clk156_25;
wire dclk_i;
wire xge_refclk_i;

assign network_reset_done = ~core_reset;
assign clk156_out = clk156_25;
 

wire[7:0]   tx_ifg_delay;
wire        signal_detect;
assign tx_ifg_delay     = 8'h00; 
assign signal_detect    = 1'b1;


niu_single niu_single_inst
(
.clk156             (clk156_25),
.reset              (reset),
.aresetn            (aresetn),
.dclk               (dclk_i),
.txusrclk           (gt_txusrclk),
.txusrclk2          (gt_txusrclk2),
.txclk322           (gt_txclk322),

.areset_refclk_bufh (areset_clk_156_25_bufh),
.areset_clk156      (areset_clk_156_25),
.mmcm_locked_clk156 (mmcm_locked_clk156),
.gttxreset_txusrclk2(gttxreset_txusrclk2),
.gttxreset          (gttxreset),
.gtrxreset          (gtrxreset),
.txuserrdy          (gt_txuserrdy),
.qplllock           (gt_qplllock),
.qplloutclk         (gt_qplloutclk),
.qplloutrefclk      (gt_qplloutrefclk),
.reset_counter_done (reset_counter_done),
.tx_resetdone       (gt_tx_resetdone),

.txp(xge_txp),
.txn(xge_txn),
.rxp(xge_rxp),
.rxn(xge_rxn),

.tx_axis_tdata (tx_axis_tdata),
.tx_axis_tvalid(tx_axis_tvalid),
.tx_axis_tlast (tx_axis_tlast),
.tx_axis_tuser (1'b0),
.tx_axis_tkeep (tx_axis_tkeep),
.tx_axis_tready(tx_axis_tready),

.rx_axis_tdata (rx_axis_tdata),
.rx_axis_tvalid(rx_axis_tvalid),
.rx_axis_tuser (rx_axis_tuser),
.rx_axis_tlast (rx_axis_tlast),
.rx_axis_tkeep (rx_axis_tkeep),
.rx_axis_tready(rx_axis_tready),

.core_reset   (core_reset),
.tx_fault     (tx_fault),
.signal_detect(signal_detect),
.tx_ifg_delay (tx_ifg_delay),
.tx_disable   (),
.core_status  (core_status)
); 


IBUFDS_GTE2 xgphy_refclk_ibuf (

    .I      (xge_refclk_p),
    .IB     (xge_refclk_n),
    .O      (xge_refclk_i  ),
    .CEB    (1'b0          ),
    .ODIV2  (              )   
);


xgbaser_gt_same_quad_wrapper #(
.WRAPPER_SIM_GTRESET_SPEEDUP     ("TRUE"                        )
) xgbaser_gt_wrapper_inst (
.gt_txclk322                       (gt_txclk322),
.gt_txusrclk                       (gt_txusrclk),
.gt_txusrclk2                      (gt_txusrclk2),
.qplllock                          (gt_qplllock),
.qpllrefclklost                    (gt_qpllrefclklost),
.qplloutclk                        (gt_qplloutclk),
.qplloutrefclk                     (gt_qplloutrefclk),
.qplllock_txusrclk2                (gt_qplllock_txusrclk2), //not used
.gttxreset_txusrclk2               (gttxreset_txusrclk2),
.txuserrdy                         (gt_txuserrdy),
.tx_fault                          (tx_fault), 
.core_reset                        (core_reset),
.gt0_tx_resetdone                  (gt_tx_resetdone),
.gt1_tx_resetdone                  (1'b1),
.gt2_tx_resetdone                  (1'b1),
.gt3_tx_resetdone                  (1'b1),
.areset_clk_156_25_bufh            (areset_clk_156_25_bufh),
.areset_clk_156_25                 (areset_clk_156_25),
.mmcm_locked_clk156                (mmcm_locked_clk156),
.reset_counter_done                (reset_counter_done),
.gttxreset                         (gttxreset),
.gtrxreset                         (gtrxreset),
.clk156                            (clk156_25            ),
.areset                            (reset),  
.dclk                              (dclk_i                     ), 
.gt_refclk                         (xge_refclk_i               )
);
    


//---------------------------     Debug      ----------------------------
localparam  LED_CTR_WIDTH      = 26;
reg     [LED_CTR_WIDTH-1:0]    l1_ctr;

always @(posedge clk156_25)
begin
    l1_ctr <= l1_ctr + 1'b1;
end


assign led[0] = l1_ctr[LED_CTR_WIDTH-1];
assign led[1] = 1'b0;
assign led[2] = reset;
assign led[3] = core_reset;
assign led[4] = core_status[0];
assign led[5] = 1'b0;
assign led[6] = 1'b0;
assign led[7] = 1'b0;

endmodule
