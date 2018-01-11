`timescale 1ns / 1ps 
`include "pkt_tm/pkt_package.sv"

module tb_niu ();


wire          reset              ;
wire          aresetn            ;
wire          xge_refclk_p       ;
wire          xge_refclk_n       ;
wire          xge_txp            ;
wire          xge_txn            ;
wire          xge_rxp            ;
wire          xge_rxn            ;
wire[63:0]    rx_axis_tdata      ;
wire          rx_axis_tvalid     ;
wire          rx_axis_tlast      ;
wire[7:0]     rx_axis_tkeep      ;
wire          rx_axis_tready     ;
wire[63:0]    tx_axis_tdata      ;
wire          tx_axis_tvalid     ;
wire          tx_axis_tlast      ;
wire          tx_axis_tuser      ;
wire[7:0]     tx_axis_tkeep      ;
wire          tx_axis_tready     ;
wire          clk156_out         ;
wire          network_reset_done ;
wire[7:0]     led                ;
reg           mac_id_filter_en   =  1'b1;               
reg           mac_id_valid       =  1'b1;               
reg [47:0]    mac_id             =  48'h112233445566;   

wire  [63:0]  xgmii_txd ;
wire  [7:0]   xgmii_txc ;
wire  [63:0]  xgmii_rxd ;
wire  [7:0]   xgmii_rxc ;
		
reg init_done=0;
reg              sys_rst =0;       
reg              sys_clk =0 ;       



NIU dut(
.reset             (reset               ),
.aresetn           (aresetn             ),   
.xge_refclk_p      (xge_refclk_p        ),
.xge_refclk_n      (xge_refclk_n        ),
.xge_txp           (xge_txp             ),
.xge_txn           (xge_txn             ),
.xge_rxp           (xge_rxp             ),
.xge_rxn           (xge_rxn             ),
.rx_axis_tdata     (rx_axis_tdata       ),
.rx_axis_tvalid    (rx_axis_tvalid      ),
.rx_axis_tlast     (rx_axis_tlast       ),
.rx_axis_tkeep     (rx_axis_tkeep       ),
.rx_axis_tready    (rx_axis_tready      ),
.tx_axis_tdata     (tx_axis_tdata       ),
.tx_axis_tvalid    (tx_axis_tvalid      ),
.tx_axis_tlast     (tx_axis_tlast       ),
.tx_axis_tuser     (tx_axis_tuser       ),
.tx_axis_tkeep     (tx_axis_tkeep       ),
.tx_axis_tready    (tx_axis_tready      ),
.clk156_out        (clk156_out          ),
.network_reset_done(network_reset_done  ),
.led               (led                 ),
.mac_id_filter_en  (mac_id_filter_en    ),
.mac_id_valid      (mac_id_valid        ),
.mac_id            (mac_id              )
    
);

mailbox mbx;

pkt_generator u_xgmii_pkt_generator();

xgmii_driver u_xgmii_pkt_driver(
.rst(sys_rst)   ,
.clk(sys_clk)   ,
.txd(xgmii_txd) ,            
.txc(xgmii_txc) ,        
.rxd(xgmii_rxd) ,        
.rxc(xgmii_rxc)            
);


pkt_generator u_axis_pkt_gen();

axis_master u_axis_master)
.rst(sys_rst)   ,
.clk(sys_clk)   ,
.m_tdata (tx_axis_tdata  ),
.m_tvalid(tx_axis_tvalid ),
.m_tlast (tx_axis_tlast  ),
.m_tkeep (tx_axis_tkeep  ),
.m_tready(tx_axis_tready )
);

axis_slave u_axis_slave(
.rst(sys_rst)   ,
.clk(sys_clk)   ,
.s_tdata  (rx_axis_tdata  ),
.s_tvalid (rx_axis_tvalid ),
.s_tlast  (rx_axis_tlast  ),
.s_tkeep  (rx_axis_tkeep  ),
.s_tready (rx_axis_tready )
);



//--------------------clock && rst---------------------
initial begin
	#1000;
	sys_rst=1;
	#2000;
	sys_rst=0;
	
end

always #3.2 sys_clk = ~sys_clk;
//---------------------------------------------------------

assign reset = sys_rst;
assign aresetn = ~ sys_rst;
assign xge_refclk_p = sys_clk;
assign xge_refclk_n = ~sys_clk;
assign xge_rxp = 1'b0;
assign xge_rxn = 1'b1;
assign rx_axis_tready = 1'b1;
assign tx_axis_tdata  = 0 ;
assign tx_axis_tvalid = 0 ;
assign tx_axis_tlast  = 0 ;
assign tx_axis_tuser  = 0 ;
assign tx_axis_tkeep  = 0 ;

assign dut.niu_single_inst.ten_gig_eth_mac_inst.xgmii_rxd = xgmii_rxd;
assign dut.niu_single_inst.ten_gig_eth_mac_inst.xgmii_rxc = xgmii_rxc;

//-----------------------init------------------------
initial begin
//---connect component---
    mbx=new();
    u_xgmii_pkt_generator.set_mbx(mbx);
    u_xgmii_pkt_driver.set_mbx(mbx);
    
    #10us       ;

    init_done=1'b1;
end


endmodule