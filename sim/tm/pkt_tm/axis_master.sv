
`include "pkt_tm/pkt_package.sv"
`timescale 1ns / 1ps 


module axis_master(
input          rst,
input          clk,
input          m_axis_tready,
output reg [63:0]  m_axis_tdata,   
output reg [7:0]   m_axis_tkeep,   
output reg        m_axis_tvalid,
output reg        m_axis_tlast
);


c_Packet pkt;
mailbox mbx;
logic [7:0] data[$];

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
		pkt.print();
		pkt.pack(data);
		//$display("pkt field is %p",pkt);
		pkt_axis_size = (data.size()-1)/8 + 1;
		last_byte_num = data.size()-(pkt_axis_size-1)*8;//1-8
		
		@(posedge clk);
		for(int i=0;i<pkt_axis_size;i++)
		begin
			if(i=pkt_axis_size-1) begin
				for(int j=0;j<=7;j++) begin
					if(j<last_byte_num)begin
					   m_axis_tkeep[j]<=1'b1;
					   m_axis_tdata[j*8+7 -: 8]  <=data.pop();
					end else begin
					   m_axis_tkeep[j]<=1'b0;
					   m_axis_tdata[j*8+7 -: 8]  <=0;
					end
				end
				m_axis_tlast<=1'b1;
				m_axis_tvalid<=1'b1;
			end else begin
				for(int j=0;j<=7;j++) begin
					   m_axis_tkeep[j]<=1'b1;
					   m_axis_tdata[j*8+7 -: 8]  <=data.pop();
        end
				m_axis_tlast<=1'b0;        				
				m_axis_tvalid<=1'b1;
			end
	  end
		
		
		send_pkt_req=1;
		wait(pkt_sending==1'b1); 
		send_pkt_req=0;
		wait(pkt_sending==1'b0); 
	end
end



endmodule


