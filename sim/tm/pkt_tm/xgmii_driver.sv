
`include "pkt_tm/pkt_package.sv"
`timescale 1ns / 1ps 


module xgmii_driver(
input             rst,
input             clk,
input      [63:0] txd ,
input      [7:0]  txc ,
output reg [63:0] rxd=0 ,
output reg [7:0]  rxc=0 

);


c_packet pkt;
mailbox mbx;
logic [7:0] pkt_data_array[$];
int unsigned byte_cnt=0;
logic send_pkt_req=0;
logic pkt_sending=0;
function set_mbx(mailbox mbx_set);
	mbx=mbx_set;
endfunction


initial
begin
	wait(mbx!=null);
	wait(rst==1'b0);
	forever begin
		mbx.get(pkt);
		pkt.print_packet();
		pkt.get_packet(pkt_data_array);
		pkt_data_array = {8'h55,8'h55,8'h55,8'h55,8'h55,8'h55,8'hd5,pkt_data_array};
		//$display("pkt field is %p",pkt);
		send_pkt_req=1;
		wait(pkt_sending==1'b1); 
		send_pkt_req=0;
		wait(pkt_sending==1'b0); 
	end
end

reg [63:0] rxd_tmp;
reg [7:0]  rxc_tmp;
always @(posedge rst,posedge clk)begin
	if(rst==1'b1)begin
		rxd<=0;
		rxc<=0;
	end else begin
		rxd_tmp=0;
		rxc_tmp=0;
		for(int i=0;i<=7;i++) begin
			if(pkt_sending==1'b0 ) begin
				if((i==0 || i==4)  && send_pkt_req==1'b1)  begin
					rxd_tmp[i*8+7 -: 8] = 8'hFB;
					rxc_tmp[i] = 1'b1;
					pkt_sending=1'b1;
				end else begin
					rxd_tmp[i*8+7 -: 8] = 8'h07;
					rxc_tmp[i] = 1'b1;
				end	
			end else begin
				if(byte_cnt<=pkt_data_array.size()-1)  begin
					rxd_tmp[i*8+7 -: 8] = pkt_data_array[byte_cnt];
					rxc_tmp[i] = 1'b0;
					byte_cnt=byte_cnt+1;
				end else if (byte_cnt==pkt_data_array.size())  begin
					rxd_tmp[i*8+7 -: 8] = 8'hFD;
					rxc_tmp[i] = 1'b1;
					byte_cnt=byte_cnt+1;
				end else if (byte_cnt<=pkt_data_array.size()+8)  begin
					rxd_tmp[i*8+7 -: 8] = 8'h07;
					rxc_tmp[i] = 1'b1;
					if (byte_cnt==pkt_data_array.size()+8) begin 
						pkt_sending=1'b0;
						byte_cnt=0;
					end else
					  byte_cnt=byte_cnt+1;
				end
			end
		end
		rxd<=rxd_tmp;
		rxc<=rxc_tmp;
	end
end


endmodule


