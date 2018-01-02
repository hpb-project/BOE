`ifndef PKT_PACKAGE_DONE
	`define PKT_PACKAGE_DONE



`timescale 1ns / 1ps


package pkt_package;
parameter PKT_MODE_ETHER = 0;
parameter PKT_MODE_HIGIG2 = 1;


class c_packet;
	integer mode=0;
	integer delay=0;
	
//higig2 
	logic [7:0] higig2_pkt[$];
	logic [7:0] higig2_head[$];
	logic [7:0] higig2_sport=0;
	logic [7:0] higig2_dport=0;

//ether field	
	logic [7:0]  ether_pkt[$];
	logic [47:0] ether_dmac=0;
	logic [47:0] ether_smac=0;
	logic [9:0 ] ether_vlan_id=0;
	logic [2:0 ] ether_vlan_pri=0;
	logic        ether_vlan_cfi=0;
	logic [15:0] ether_ether_type=0;
	logic [7:0 ] ether_payload[$];
        logic        ether_vlan_valid=0;

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
	
	
        
        	
	task set_mode;
	input integer user_mode;
	
		mode=user_mode;
	endtask
	
	
	task set_delay;
	input integer delay_set;
		delay=delay_set;
	endtask
	
	
	task set_higig2_by_string;
		input string pkt_by_string;
		
		mode=PKT_MODE_HIGIG2;
	        string2array(pkt_by_string,higig2_pkt);
	        higig2_resolution;
	endtask


	task set_ether_by_string;
		input string ether_by_string;
		
		mode=PKT_MODE_ETHER;
	        string2array(ether_by_string,ether_pkt);
	        ether_resolution;
	endtask



	task higig2_resolution;
		higig2_head=higig2_pkt[0:14];
		ether_pkt=higig2_pkt[15:$];
		ether_resolution;
	endtask



        task ether_resolution;
	        ether_dmac       = {ether_pkt[0], ether_pkt[1], ether_pkt[2], ether_pkt[3], ether_pkt[4] , ether_pkt[5]}; 
	        ether_smac       = {ether_pkt[6], ether_pkt[7], ether_pkt[8], ether_pkt[9], ether_pkt[10], ether_pkt[11]}; 
	        ether_ether_type = {ether_pkt[12],ether_pkt[13]};
	        
	        if (ether_ether_type=='h8100)begin
	                ether_vlan_valid = 1'b1;
	        	ether_vlan_id    = {ether_pkt[14][3:0],ether_pkt[15]};
	        	ether_vlan_pri   =  ether_pkt[14][7:5];
	        	ether_vlan_cfi   =  ether_pkt[14][4];
	        	ether_ether_type = {ether_pkt[16],ether_pkt[17]};
	        	ether_payload    =  ether_pkt[18:$];
	        end else begin
	                ether_vlan_valid = 1'b0;
	        	ether_payload    = ether_pkt[14:$];
	        end
	        
	        
	        if (ether_ether_type=='h0800)begin
                	ip_resolution;
	        end	        
        endtask


        task ip_resolution;
	        ip_version    =  ether_payload[0][7:4];
	        ip_ihl        =  ether_payload[0][3:0];
	        ip_tos        =  ether_payload[1];
	        ip_len        = {ether_payload[2] , ether_payload[3]};
	        ip_id         = {ether_payload[4] , ether_payload[5]};
	        ip_flag       =  ether_payload[6][7:5];
	        ip_frg_offset = {ether_payload[6][4:0],ether_payload[7]};
	        ip_ttl        =  ether_payload[8];
	        ip_protocol   =  ether_payload[9];
	        ip_checksum   = {ether_payload[10] , ether_payload[11]};
	        ip_sip        = {ether_payload[12] , ether_payload[13] , ether_payload[14] , ether_payload[15] };
	        ip_dip        = {ether_payload[16] , ether_payload[17] , ether_payload[18] , ether_payload[19] };
	        ip_opt        = {  };
	        ip_payload    = {  };
	        
	        if(ip_ihl>5) begin
	        	ip_opt     = ether_payload[20:ip_ihl*4-1];
	        	ip_payload = ether_payload[ip_ihl*4:$];
	        end else begin
	        	ip_payload = ether_payload[20:$];
	        end

                if(ip_protocol==6) begin//tcp
			tcp_resolution;
                end else if(ip_protocol==17) begin //udp
			udp_resolution;
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
	

	task get_packet;
		output [7:0] pkt_data[$];
		
		if(mode==PKT_MODE_HIGIG2)
			pkt_data=higig2_pkt;
		else if (mode==PKT_MODE_ETHER)
			pkt_data=ether_pkt;
	endtask
	

	task get_packet_length;
		output logic [15:0] length;
		
		logic [7:0] temp_array[$];
		
		get_packet(temp_array);
		length=temp_array.size();
	endtask
	
	
	task get_packet_by_128b;
		output logic [127:0] out_pkt_array[$];
		
		logic [7:0] temp_array[$];
		
		logic [15:0] byte_size;
		logic [15:0] vec_size;
		
		get_packet(temp_array);
		byte_size=temp_array.size();
		vec_size=(byte_size/16)+((byte_size%16)!=0);
		
		$display("byte_size=%d    vec_size=%d",byte_size,vec_size);
		for(int i=0;i<vec_size;i++)begin
			out_pkt_array[i]=0;
			for(int j=0;j<16;j++) begin
				if((i*16+j)<byte_size)
					out_pkt_array[i][(15-j)*8+7 -: 8]=temp_array[i*16+j];
			end
			$display("pkt by 128b: vector[%d] is : %h",i,out_pkt_array[i]);
		end
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
		
		out_sport         =  higig2_sport        ;      
		out_dmac          =  ether_dmac          ;          
		out_smac          =  ether_smac          ;          
		out_ether_type    =  ether_ether_type    ;    
		out_vlan_id       =  ether_vlan_id       ;       
		out_vlan_pri      =  ether_vlan_pri      ;      
		out_dip           =  ip_dip           ;           
		out_sip           =  ip_sip           ;           
		out_ip_protocol   =  ip_protocol      ;   
		out_tcpudp_dport  =  tcpudp_dport     ; 
		out_tcpudp_sport  =  tcpudp_sport     ; 
		out_tcp_flag      =  tcp_flag         ;    
	endtask  
       
endclass




endpackage


import pkt_package::* ;

`endif

