`timescale 1ns / 1ns

package pkt_def;

class c_packet;
	integer mode=0;
	integer delay=0;
	logic [7:0]  sport=0;
	logic [7:0]  dport=0;
	
	logic [7:0 ] l2_pkt[$];
	
//l2 field	
	logic [47:0] l2_dmac=0;
	logic [47:0] l2_smac=0;
	logic [9:0 ] l2_vlan_id=0;
	logic [2:0 ] l2_vlan_pri=0;
	logic        l2_vlan_cfi=0;
	logic [15:0] l2_ether_type=0;
	logic [7:0 ] l2_payload[$];
        logic        l2_vlan_valid=0;

//ip field
        logic [3:0 ] ip_version=0     ;  
        logic [3:0 ] ip_ihl=0         ;
        logic [7:0 ] ip_tos=0         ;
        logic [15:0] ip_len=0         ;
        logic [15:0] ip_id=0          ;
        logic [2:0 ] ip_flag=0        ;
        logic [12:0] ip_frg_offset=0  ;
        logic [7:0 ] ip_ttl=0         ;
        logic [7:0 ] ip_protocol=0    ;
        logic [15:0] ip_checksum=0    ;
	logic [31:0] ip_sip=0         ;
	logic [31:0] ip_dip=0         ;
        logic [7:0 ] ip_opt[$]        ;
        logic [7:0 ] ip_payload[$]    ; 


//tcp field                   
	logic [15:0] tcpudp_dport=0    ;
	logic [15:0] tcpudp_sport=0    ;
        logic [31:0] tcp_seq_num=0     ;
        logic [31:0] tcp_ack_num=0     ;
        logic [3:0 ] tcp_data_offset=0 ;
        logic [5:0 ] tcp_reserve=0     ;
        logic [5:0 ] tcp_flag=0        ;
        logic [15:0] tcp_window=0      ;
        logic [15:0] tcp_checksum=0    ;
        logic [15:0] tcp_urgent=0      ;
        logic [7:0 ] tcp_opt[$]        ;   
        logic [7:0 ] tcp_payload[$]    ;   
	
//udp fiels
//	logic [15:0] tcpudp_dport;
//	logic [15:0] tcpudp_sport;
        logic [15:0] udp_len=0        ;
        logic [15:0] udp_checksum=0   ;
        logic [7:0 ] udp_payload[$]   ;  
	
	
        logic unsupported_ether_type=0;
        logic unsupported_ip_protocol=0;
        
        
        
        	
	task set_mode;
	input integer user_mode;
	
		mode=user_mode;
	endtask
	
	
	task set_delay;
	input integer delay_set;
		delay=delay_set;
	endtask
	
	
	task set_pkt_by_string;
		input string pkt_by_string;
		
		logic [7:0] temp_array[$];
		
	        string2array(pkt_by_string,temp_array);
	        pkt_resolution(temp_array);
	endtask


	task pkt_resolution;
		input logic [7:0] pkt_in[$];
		
		l2_pkt=pkt_in;
	        l2_resolution;
	        
	        if (l2_ether_type=='h0800)begin
                	ip_resolution;
                	
                        if(ip_protocol==6) begin//tcp
				tcp_resolution;
                        end else if(ip_protocol==17) begin //udp
				udp_resolution;
                        end else begin
	        	 	unsupported_ip_protocol=1'b1;
		     end
	        end else begin
	        	unsupported_ether_type=1'b1;
	        end
	        		 	
	    
	endtask

        
			        
        task l2_resolution;
	        l2_dmac       = {l2_pkt[0], l2_pkt[1], l2_pkt[2], l2_pkt[3], l2_pkt[4] , l2_pkt[5]}; 
	        l2_smac       = {l2_pkt[6], l2_pkt[7], l2_pkt[8], l2_pkt[9], l2_pkt[10], l2_pkt[11]}; 
	        l2_ether_type = {l2_pkt[12],l2_pkt[13]};
	        
	        if (l2_ether_type=='h8100)begin
	                l2_vlan_valid = 1'b1;
	        	l2_vlan_id    = {l2_pkt[14][3:0],l2_pkt[15]};
	        	l2_vlan_pri   =  l2_pkt[14][7:5];
	        	l2_vlan_cfi   =  l2_pkt[14][4];
	        	l2_ether_type = {l2_pkt[16],l2_pkt[17]};
	        	l2_payload    =  l2_pkt[18:$];
	        end else begin
	                l2_vlan_valid = 1'b0;
	        	l2_payload    = l2_pkt[14:$];
	        end
        endtask


        task ip_resolution;
	        ip_version    =  l2_payload[0][7:4];
	        ip_ihl        =  l2_payload[0][3:0];
	        ip_tos        =  l2_payload[1];
	        ip_len        = {l2_payload[2] , l2_payload[3]};
	        ip_id         = {l2_payload[4] , l2_payload[5]};
	        ip_flag       =  l2_payload[6][7:5];
	        ip_frg_offset = {l2_payload[6][4:0],l2_payload[7]};
	        ip_ttl        =  l2_payload[8];
	        ip_protocol   =  l2_payload[9];
	        ip_checksum   = {l2_payload[10] , l2_payload[11]};
	        ip_sip        = {l2_payload[12] , l2_payload[13] , l2_payload[14] , l2_payload[15] };
	        ip_dip        = {l2_payload[16] , l2_payload[17] , l2_payload[18] , l2_payload[19] };
	        ip_opt        = {  };
	        ip_payload    = {  };
	        
	        if(ip_ihl>5) begin
	        	ip_opt     = l2_payload[20:ip_ihl*4-1];
	        	ip_payload = l2_payload[ip_ihl*4:$];
	        end else begin
	        	ip_payload = l2_payload[20:$];
	        end
        endtask


        task tcp_resolution;
	        tcpudp_sport    = {ip_payload[0],ip_payload[1]};
	        tcpudp_dport    = {ip_payload[2],ip_payload[3]};
	        tcp_seq_num     = {ip_payload[4] , ip_payload[5] , ip_payload[6]  , ip_payload[7]  };
	        tcp_ack_num     = {ip_payload[8] , ip_payload[9] , ip_payload[10] , ip_payload[11] };
	        tcp_data_offset =  ip_payload[12][7:4];
	        tcp_reserve     = {ip_payload[12][3:0],ip_payload[13][7:6]};
	        tcp_flag        =  ip_payload[13][5:0];
	        tcp_window      = {ip_payload[14],ip_payload[15]};
	        tcp_checksum    = {ip_payload[16],ip_payload[17]};
	        tcp_urgent      = {ip_payload[18],ip_payload[19]};
		tcp_opt         = {  };
	        tcp_payload     = {  }; 
	        
		if(tcp_data_offset>5 )begin
			tcp_opt     = ip_payload[20:tcp_data_offset*4-1];
			tcp_payload = ip_payload[tcp_data_offset*4:$];
		end else begin
	        	tcp_payload = ip_payload[20:$];
		end		
        endtask
        
        
        task udp_resolution;
	        tcpudp_sport  = {ip_payload[0],ip_payload[1]};
	        tcpudp_dport  = {ip_payload[2],ip_payload[3]};
		udp_len      = {ip_payload[4],ip_payload[5]};
		udp_checksum = {ip_payload[6],ip_payload[7]};
		udp_payload  =  ip_payload[8:$];
        endtask

        
	
	
	task get_packet;
		output [7:0] pkt_data[$];
	
		pkt_data=l2_pkt;
	endtask
	
//	function logic [7:0][$] get_packet_t();
//	
//		return l2_pkt;
//	endfunction
	
	
	
        task string2array;  //convert string to byte array
	    	input string string_in;
	    	output logic [7:0] array_out[$];
            	
	    	string	string_tmp;
	    	
	    	array_out = {};			 //清空队列
	    	for(int i=0;i<((string_in.len())/2);i++)begin
	    	    string_tmp = string_in.substr(i*2,i*2+1);//取出2个字符
	    	    array_out[i] = string_tmp.atohex();//转换成数据放入队列
	    	end
	endtask        
        
        
        
        task array2string;  //convert string to byte array
	    	input logic [7:0] array_in[$];
	    	output string string_out;
            	
	    	string	string_tmp;
	    	
	    	string_out={};
	    	
	    	for(int i=0;i<array_in.size();i++)begin
	    	    string_tmp.hextoa(array_in[i]); 
	    	    string_out = {string_out,string_tmp};
	    	end
	endtask        
        
        
        
	task print_packet;
		logic [7:0] temp_data[$];
		string      temp_string;

	    	get_packet(temp_data);
	    	array2string(temp_data,temp_string);
	
	  	$display("pkt is %s",temp_string);
	endtask
	
	task get_field;
		output logic  [4:0]   out_sport;          
		output logic  [47:0]  out_dmac;              
		output logic  [47:0]  out_smac;              
		output logic  [15:0]  out_ether_type;        
		output logic  [11:0]  out_vlan_id;           
		output logic  [2:0]   out_vlan_pri;          
		output logic  [31:0]  out_dip;               
		output logic  [31:0]  out_sip;               
		output logic  [7:0]   out_ip_protocol;       
		output logic  [15:0]  out_tcpudp_dport;     
		output logic  [15:0]  out_tcpudp_sport;     
		output logic  [5:0]   out_tcp_flag;   
		
		out_sport         =  sport            ;      
		out_dmac          =  l2_dmac          ;          
		out_smac          =  l2_smac          ;          
		out_ether_type    =  l2_ether_type    ;    
		out_vlan_id       =  l2_vlan_id       ;       
		out_vlan_pri      =  l2_vlan_pri      ;      
		out_dip           =  ip_dip           ;           
		out_sip           =  ip_sip           ;           
		out_ip_protocol   =  ip_protocol      ;   
		out_tcpudp_dport  =  tcpudp_dport     ; 
		out_tcpudp_sport  =  tcpudp_sport     ; 
		out_tcp_flag      =  tcp_flag         ;    
	endtask  
       

endclass




endpackage





import pkt_def::*;
















`timescale 1ns / 1ps 
`include "pkg_definitions.sv"

module pkt_generator();   
	c_packet pkt;
	mailbox mbx;
	

	function set_mbx(mailbox mbx_set);
		mbx=mbx_set;
	endfunction

	task send_user_pkt;
		input string pkt_string;
		
		pkt = new();
		pkt.set_pkt_by_string(pkt_string);
//		pkt.print_packet();
		mbx.put(pkt);
	endtask
endmodule



module pkt_internal_driver(
input                  rst,
input                  clk,
output reg             pkt_vld ,            
output reg             pkt_vld_sof    ,        
output reg             pkt_vld_eof    ,        
output reg [127:0]     pkt_data    ,           
output  PKT_INFO_t1 pkt_info               
);


c_packet pkt;
mailbox mbx;
logic [7:0] pkt_data_array[$];


function set_mbx(mailbox mbx_set);
	mbx=mbx_set;
endfunction

initial begin
	pkt_vld<=0;
	pkt_vld_sof<=0;
	pkt_vld_eof<=0;
	pkt_data<=0;
	pkt_info<=0;
end

initial
begin
	wait(mbx!=null);
	wait(rst==1'b0);
	forever begin
		mbx.get(pkt);
		pkt.print_packet();
		pkt.get_packet(pkt_data_array);
		$display("pkt field is %p",pkt);
		send_pkt;
	end
end

task send_pkt;
begin
	fork 
	begin
		@(posedge clk);
		pkt_vld<=1'b1;
		repeat(pkt_data_array.size() )  @(posedge clk);
		pkt_vld<=1'b0;
	end
	
	begin
		@(posedge clk);
		pkt_vld_sof<=1'b1;
		@(posedge clk);
		pkt_vld_sof<=1'b0;
	end
	
	begin
		repeat(pkt_data_array.size() )  @(posedge clk);
		pkt_vld_eof<=1'b1;
		@(posedge clk);
		pkt_vld_eof<=1'b0;
	end
		

	begin
		for(int i=0;i<(pkt_data_array.size());i++) begin
			@(posedge clk);
			pkt_data<=pkt_data_array[i];
		end
		@(posedge clk);
		pkt_data<=0;
	end		
	
	
	begin
		@(posedge clk);
		#1;
		pkt.get_field(   pkt_info.src_port,        
				 pkt_info.dmac,            
				 pkt_info.smac,            
				 pkt_info.ether_type,      
				 pkt_info.vlan_id,         
				 pkt_info.vlan_pri,        
				 pkt_info.dip,             
				 pkt_info.sip,             
				 pkt_info.ip_protocol,     
				 pkt_info.pkt_dtup_port,   
				 pkt_info.pkt_stup_port,   
				 pkt_info.tcp_flag      
				);
		@(posedge clk);
		pkt_info<=0;
	end
	join
	
	
end
endtask
	
endmodule






// module tb_gen_pkt();
// 
// mailbox mbx;
// reg clk=0;
// reg rst=1;
// 
// 
// always #4 clk=~clk;
// 
// initial begin
// 	#1us;
// 	rst=1'b0;
// end
// 
// 
// 
// pkt_generator u_pkt_generator();
// 
// pkt_internal_driver u_pkt_driver(
// .rst(rst),
// .clk(clk)
// );
// 
// initial
// begin
//     mbx=new();
//     u_pkt_generator.set_mbx(mbx);
//     u_pkt_driver.set_mbx(mbx);
// end
// 
// initial    
// begin    
// #2;
//     
// //    pkt_generator.send_user_pkt("342342342342342423400099");
//     u_pkt_generator.send_user_pkt("112233445566aabbccddeeff810003220800452233445566778800110000c0a80022c0a80055334455664023ffffffffffffff33535235436677686352352aaaaaaa66");
// end
// 
// 
// endmodule