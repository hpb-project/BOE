module ip_decode (
        rst,
        clk,
        myIpAddress_V,
        s_axis_raw_TDATA,
        s_axis_raw_TKEEP,
        s_axis_raw_TLAST,
        m_axis_ARP_TDATA,
        m_axis_ARP_TKEEP,
        m_axis_ARP_TLAST,
        m_axis_ICMP_TDATA,
        m_axis_ICMP_TKEEP,
        m_axis_ICMP_TLAST,
        m_axis_UDP_TDATA,
        m_axis_UDP_TKEEP,
        m_axis_UDP_TLAST,
        m_axis_TCP_TDATA,
        m_axis_TCP_TKEEP,
        m_axis_TCP_TLAST,
        s_axis_raw_TVALID,
        s_axis_raw_TREADY,
        m_axis_ARP_TVALID,
        m_axis_ARP_TREADY,
        m_axis_ICMP_TVALID,
        m_axis_ICMP_TREADY,
        m_axis_UDP_TVALID,
        m_axis_UDP_TREADY,
        m_axis_TCP_TVALID,
        m_axis_TCP_TREADY
);

input   rst;
input   clk;
input  [31:0] myIpAddress_V;
input  [63:0]  s_axis_raw_TDATA;
input  [7:0]   s_axis_raw_TKEEP;
input  [0:0]   s_axis_raw_TLAST;
output  [63:0] m_axis_ARP_TDATA;
output  [7:0]  m_axis_ARP_TKEEP;
output  [0:0]  m_axis_ARP_TLAST;
output  [63:0] m_axis_ICMP_TDATA;
output  [7:0]  m_axis_ICMP_TKEEP;
output  [0:0]  m_axis_ICMP_TLAST;
output  [63:0] m_axis_UDP_TDATA;
output  [7:0]  m_axis_UDP_TKEEP;
output  [0:0]  m_axis_UDP_TLAST;
output  [63:0] m_axis_TCP_TDATA;
output  [7:0]  m_axis_TCP_TKEEP;
output  [0:0]  m_axis_TCP_TLAST;
input          s_axis_raw_TVALID;
output         s_axis_raw_TREADY;
output         m_axis_ARP_TVALID;
input          m_axis_ARP_TREADY;
output         m_axis_ICMP_TVALID;
input          m_axis_ICMP_TREADY;
output         m_axis_UDP_TVALID;
input          m_axis_UDP_TREADY;
output         m_axis_TCP_TVALID;
input          m_axis_TCP_TREADY;

wire   [72:0] ipDataFifo_V_din;
wire          ipDataFifo_V_full_n;
wire          ipDataFifo_V_write;
wire   [72:0] ipDataFifo_V_dout;
wire          ipDataFifo_V_empty_n;
wire          ipDataFifo_V_read;
wire   [72:0] ipDataCheckFifo_V_din;
wire          ipDataCheckFifo_V_full_n;
wire          ipDataCheckFifo_V_write;
wire   [68:0] iph_subSumsFifoOut_V_din;
wire          iph_subSumsFifoOut_V_full_n;
wire          iph_subSumsFifoOut_V_write;
wire   [68:0] iph_subSumsFifoOut_V_dout;
wire          iph_subSumsFifoOut_V_empty_n;
wire          iph_subSumsFifoOut_V_read;
wire   [0:0]  ipValidFifo_V_din;
wire          ipValidFifo_V_full_n;
wire          ipValidFifo_V_write;
wire   [0:0]  ipValidFifo_V_dout;
wire          ipValidFifo_V_empty_n;
wire          ipValidFifo_V_read;
wire   [72:0] ipDataCheckFifo_V_dout;
wire          ipDataCheckFifo_V_empty_n;
wire          ipDataCheckFifo_V_read;
wire   [72:0] ipDataDropFifo_V_din;
wire          ipDataDropFifo_V_full_n;
wire          ipDataDropFifo_V_write;
wire   [72:0] ipDataDropFifo_V_dout;
wire          ipDataDropFifo_V_empty_n;
wire          ipDataDropFifo_V_read;
wire   [72:0] ipDataCutFifo_V_din;
wire          ipDataCutFifo_V_full_n;
wire          ipDataCutFifo_V_write;
wire   [72:0] ipDataCutFifo_V_dout;
wire          ipDataCutFifo_V_empty_n;
wire          ipDataCutFifo_V_read;


ip_decode_detect_mac_protocol ip_decode_detect_mac_protocol_U0(
    .clk( clk ),
    .rst( rst ),
    .s_axis_raw_TDATA   ( s_axis_raw_TDATA    ),
    .s_axis_raw_TVALID  ( s_axis_raw_TVALID   ),
    .s_axis_raw_TREADY  ( s_axis_raw_TREADY   ),
    .s_axis_raw_TKEEP   ( s_axis_raw_TKEEP    ),
    .s_axis_raw_TLAST   ( s_axis_raw_TLAST    ),
    .m_axis_ARP_TDATA   ( m_axis_ARP_TDATA    ),
    .m_axis_ARP_TVALID  ( m_axis_ARP_TVALID   ),
    .m_axis_ARP_TREADY  ( m_axis_ARP_TREADY   ),
    .m_axis_ARP_TKEEP   ( m_axis_ARP_TKEEP    ),
    .m_axis_ARP_TLAST   ( m_axis_ARP_TLAST    ),
    .ipDataFifo_V_din   ( ipDataFifo_V_din    ),
    .ipDataFifo_V_full_n( ipDataFifo_V_full_n ),
    .ipDataFifo_V_write ( ipDataFifo_V_write  )
);

ip_decode_check_ip_checksum ip_decode_check_ip_checksum_U0(
    .clk( clk ),
    .rst( rst ),
    .myIpAddress_V              ( myIpAddress_V               ),
    .ipDataFifo_V_dout          ( ipDataFifo_V_dout           ),
    .ipDataFifo_V_empty_n       ( ipDataFifo_V_empty_n        ),
    .ipDataFifo_V_read          ( ipDataFifo_V_read           ),
    .ipDataCheckFifo_V_din      ( ipDataCheckFifo_V_din       ),
    .ipDataCheckFifo_V_full_n   ( ipDataCheckFifo_V_full_n    ),
    .ipDataCheckFifo_V_write    ( ipDataCheckFifo_V_write     ),
    .iph_subSumsFifoOut_V_din   ( iph_subSumsFifoOut_V_din    ),
    .iph_subSumsFifoOut_V_full_n( iph_subSumsFifoOut_V_full_n ),
    .iph_subSumsFifoOut_V_write ( iph_subSumsFifoOut_V_write  )
);

ip_decode_iph_check_ip_checksum ip_decode_iph_check_ip_checksum_U0(
    .clk( clk ),
    .rst( rst ),
    .iph_subSumsFifoOut_V_dout    ( iph_subSumsFifoOut_V_dout    ),
    .iph_subSumsFifoOut_V_empty_n ( iph_subSumsFifoOut_V_empty_n ),
    .iph_subSumsFifoOut_V_read    ( iph_subSumsFifoOut_V_read    ),
    .ipValidFifo_V_din            ( ipValidFifo_V_din            ),
    .ipValidFifo_V_full_n         ( ipValidFifo_V_full_n         ),
    .ipValidFifo_V_write          ( ipValidFifo_V_write          )
);

ip_decode_ip_invalid_dropper ip_decode_ip_invalid_dropper_U0(
    .clk( clk ),
    .rst( rst ),
    .ipValidFifo_V_dout       ( ipValidFifo_V_dout        ),
    .ipValidFifo_V_empty_n    ( ipValidFifo_V_empty_n     ),
    .ipValidFifo_V_read       ( ipValidFifo_V_read        ),
    .ipDataCheckFifo_V_dout   ( ipDataCheckFifo_V_dout    ),
    .ipDataCheckFifo_V_empty_n( ipDataCheckFifo_V_empty_n ),
    .ipDataCheckFifo_V_read   ( ipDataCheckFifo_V_read    ),
    .ipDataDropFifo_V_din     ( ipDataDropFifo_V_din      ),
    .ipDataDropFifo_V_full_n  ( ipDataDropFifo_V_full_n   ),
    .ipDataDropFifo_V_write   ( ipDataDropFifo_V_write    )
);

ip_decode_cut_length ip_decode_cut_length_U0(
    .clk( clk ),
    .rst( rst ),
    .ipDataDropFifo_V_dout   ( ipDataDropFifo_V_dout    ),
    .ipDataDropFifo_V_empty_n( ipDataDropFifo_V_empty_n ),
    .ipDataDropFifo_V_read   ( ipDataDropFifo_V_read    ),
    .ipDataCutFifo_V_din     ( ipDataCutFifo_V_din      ),
    .ipDataCutFifo_V_full_n  ( ipDataCutFifo_V_full_n   ),
    .ipDataCutFifo_V_write   ( ipDataCutFifo_V_write    )
);

ip_decode_detect_ip_protocol ip_decode_detect_ip_protocol_U0(
    .clk( clk ),
    .rst( rst ),
    .m_axis_ICMP_TDATA      ( m_axis_ICMP_TDATA       ),
    .m_axis_ICMP_TVALID     ( m_axis_ICMP_TVALID      ),
    .m_axis_ICMP_TREADY     ( m_axis_ICMP_TREADY      ),
    .m_axis_ICMP_TKEEP      ( m_axis_ICMP_TKEEP       ),
    .m_axis_ICMP_TLAST      ( m_axis_ICMP_TLAST       ),
    .m_axis_UDP_TDATA       ( m_axis_UDP_TDATA        ),
    .m_axis_UDP_TVALID      ( m_axis_UDP_TVALID       ),
    .m_axis_UDP_TREADY      ( m_axis_UDP_TREADY       ),
    .m_axis_UDP_TKEEP       ( m_axis_UDP_TKEEP        ),
    .m_axis_UDP_TLAST       ( m_axis_UDP_TLAST        ),
    .m_axis_TCP_TDATA       ( m_axis_TCP_TDATA        ),
    .m_axis_TCP_TVALID      ( m_axis_TCP_TVALID       ),
    .m_axis_TCP_TREADY      ( m_axis_TCP_TREADY       ),
    .m_axis_TCP_TKEEP       ( m_axis_TCP_TKEEP        ),
    .m_axis_TCP_TLAST       ( m_axis_TCP_TLAST        ),
    .ipDataCutFifo_V_dout   ( ipDataCutFifo_V_dout    ),
    .ipDataCutFifo_V_empty_n( ipDataCutFifo_V_empty_n ),
    .ipDataCutFifo_V_read   ( ipDataCutFifo_V_read    )
);

FIFO_ip_decode_ipDataFifo_V ipDataFifo_V_U(
    .clk( clk ),
    .reset( rst ),
    .if_read_ce ( 1'b1 ),
    .if_write_ce( 1'b1 ),
    .if_din    ( ipDataFifo_V_din     ),
    .if_full_n ( ipDataFifo_V_full_n  ),
    .if_write  ( ipDataFifo_V_write   ),
    .if_dout   ( ipDataFifo_V_dout    ),
    .if_empty_n( ipDataFifo_V_empty_n ),
    .if_read   ( ipDataFifo_V_read    )
);

FIFO_ip_decode_ipDataCheckFifo_V ipDataCheckFifo_V_U(
    .clk( clk ),
    .reset( rst ),
    .if_read_ce ( 1'b1 ),
    .if_write_ce( 1'b1 ),
    .if_din    ( ipDataCheckFifo_V_din     ),
    .if_full_n ( ipDataCheckFifo_V_full_n  ),
    .if_write  ( ipDataCheckFifo_V_write   ),
    .if_dout   ( ipDataCheckFifo_V_dout    ),
    .if_empty_n( ipDataCheckFifo_V_empty_n ),
    .if_read   ( ipDataCheckFifo_V_read    )
);

FIFO_ip_decode_iph_subSumsFifoOut_V iph_subSumsFifoOut_V_U(
    .clk( clk ),
    .reset( rst ),
    .if_read_ce ( 1'b1 ),
    .if_write_ce( 1'b1 ),
    .if_din    ( iph_subSumsFifoOut_V_din     ),
    .if_full_n ( iph_subSumsFifoOut_V_full_n  ),
    .if_write  ( iph_subSumsFifoOut_V_write   ),
    .if_dout   ( iph_subSumsFifoOut_V_dout    ),
    .if_empty_n( iph_subSumsFifoOut_V_empty_n ),
    .if_read   ( iph_subSumsFifoOut_V_read    )
);

FIFO_ip_decode_ipValidFifo_V ipValidFifo_V_U(
    .clk( clk ),
    .reset( rst ),
    .if_read_ce ( 1'b1 ),
    .if_write_ce( 1'b1 ),
    .if_din    ( ipValidFifo_V_din     ),
    .if_full_n ( ipValidFifo_V_full_n  ),
    .if_write  ( ipValidFifo_V_write   ),
    .if_dout   ( ipValidFifo_V_dout    ),
    .if_empty_n( ipValidFifo_V_empty_n ),
    .if_read   ( ipValidFifo_V_read    )
);

FIFO_ip_decode_ipDataDropFifo_V ipDataDropFifo_V_U(
    .clk( clk ),
    .reset( rst ),
    .if_read_ce ( 1'b1 ),
    .if_write_ce( 1'b1 ),
    .if_din    ( ipDataDropFifo_V_din     ),
    .if_full_n ( ipDataDropFifo_V_full_n  ),
    .if_write  ( ipDataDropFifo_V_write   ),
    .if_dout   ( ipDataDropFifo_V_dout    ),
    .if_empty_n( ipDataDropFifo_V_empty_n ),
    .if_read   ( ipDataDropFifo_V_read    )
);

FIFO_ip_decode_ipDataCutFifo_V ipDataCutFifo_V_U(
    .clk( clk ),
    .reset( rst ),
    .if_read_ce ( 1'b1 ),
    .if_write_ce( 1'b1 ),
    .if_din    ( ipDataCutFifo_V_din     ),
    .if_full_n ( ipDataCutFifo_V_full_n  ),
    .if_write  ( ipDataCutFifo_V_write   ),
    .if_dout   ( ipDataCutFifo_V_dout    ),
    .if_empty_n( ipDataCutFifo_V_empty_n ),
    .if_read   ( ipDataCutFifo_V_read    )
);



endmodule //ip_handler

