
`timescale 1ns / 1ps 
`include "pkt_tm/pkt_package.sv"




module pkt_generator();   
	c_packet pkt;
	mailbox mbx;
	

	function set_mbx(mailbox mbx_set);
		mbx=mbx_set;
	endfunction

	task send_ether_pkt;
		input string pkt_string;
		
		pkt = new();
		pkt.set_ether_by_string(pkt_string);
//		pkt.print_packet();
		mbx.put(pkt);
	endtask
	
	task send_higig2_pkt;
		input string pkt_string;
		
		pkt = new();
		pkt.set_higig2_by_string(pkt_string);
//		pkt.print_packet();
		mbx.put(pkt);
	endtask
endmodule












