module clock_gen(
// 200MHz reference clock input
    input   clk_ref_p,
    input   clk_ref_n,
    input   reset,

    output  clk_ref_200_out,
    
    //-SI5324 I2C programming interface
    inout   i2c_clk,
    inout   i2c_data,
    output  i2c_mux_rst_n,
    output  si5324_rst_n
);



wire  clk_ref_200;
wire  clk_ref_200_i;


assign clk_ref_200_out = clk_ref_200;
/*
 * Clocks
 */


// 200mhz ref clk
IBUFGDS #(
  .DIFF_TERM    ("TRUE"),
  .IBUF_LOW_PWR ("FALSE")
) diff_clk_200 (
  .I    (clk_ref_p  ),
  .IB   (clk_ref_n  ),
  .O    (clk_ref_200_i )  
);

BUFG u_bufg_clk_ref
(
  .O (clk_ref_200),
  .I (clk_ref_200_i)
);

// 50mhz clk
wire          clk50;
reg [1:0]     clk_divide = 2'b00;

always @(posedge clk_ref_200)
clk_divide  <= clk_divide + 1'b1;

BUFG buffer_clk50 (
.I    (clk_divide[1]),
.O    (clk50        )
);
 
 
//-SI 5324 programming
clock_control cc_inst (
   .i2c_clk        (i2c_clk        ),
   .i2c_data       (i2c_data       ),
   .i2c_mux_rst_n  (i2c_mux_rst_n  ),
   .si5324_rst_n   (si5324_rst_n   ),
   .rst            (reset    ),  
   .clk50          (clk50          )
 );    



endmodule
