
`include "pkt_tm/pkt_package.sv"
`timescale 1ns / 1ps 


module axis_slave(
input        rst,
input        clk,
input [63:0] s_axis_tdata,   
input [7:0]  s_axis_tkeep,   
input        s_axis_tvalid,
input        s_axis_tlast,
output       s_axis_tready
);


//BasePacket pkt;
//mailbox mbx;
logic [7:0] data[$];

integer file;
logic save_to_file = 1'b0;

function save_to_file(string file_name);
  file = $fopen(file_name,"a");// a×·¼ÓÐ´
  $display("file %s is opened",file_name);
  save_to_file=1'b1;
endfunction

assign s_axis_tready = 1'b1;

always (posedge clk)
begin
	  if(s_axis_tvalid==1'b1) begin
	  	for(int i=0 ;i<=7 ;i++)begin
	       if(s_axis_tkeep[i]==1'b1)
            data.push_back( s_axis_tdata[8*i+7 -: 8] );
	    end
	    
	    if (s_axis_tlast==1'b1) begin
	    	if (save_to_file==1'b1)
            $fwrite(file,"%s",data);
        data={};
      end
    end

endmodule


