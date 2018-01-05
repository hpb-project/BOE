`ifndef PKT_PACKAGE_DONE
	`define PKT_PACKAGE_DONE



`timescale 1ns / 1ps


package pkt_package;
parameter PKT_MODE_USER_DEFINE = 0;
parameter PKT_MODE_ETHER       = 1;
parameter PKT_MODE_IP          = 2;
parameter PKT_MODE_TCP         = 3;
parameter PKT_MODE_UDP         = 4;


class c_packet;
	integer mode=0;
	integer delay=0;
  integer preamble_num=7;
  logic preamble_en = 1'b0;
  logic fcs32_en = 1'b1;
  	
	logic [7:0]  user_define_pkt[$];
	
//ether field	
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
	
	

	task set_user_define_by_string;
		   input string ether_by_string;
		   
		   mode=PKT_MODE_USER_DEFINE;
	     string2array(ether_by_string,user_define_pkt);
	     ether_resolution;
	endtask




  task ether_resolution;
       ether_dmac       = {user_define_pkt[0], user_define_pkt[1], user_define_pkt[2], user_define_pkt[3], user_define_pkt[4] , user_define_pkt[5]}; 
       ether_smac       = {user_define_pkt[6], user_define_pkt[7], user_define_pkt[8], user_define_pkt[9], user_define_pkt[10], user_define_pkt[11]}; 
       ether_ether_type = {user_define_pkt[12],user_define_pkt[13]};
       
       if (ether_ether_type=='h8100)begin
           ether_vlan_valid = 1'b1;
       	   ether_vlan_id    = {user_define_pkt[14][3:0],user_define_pkt[15]};
       	   ether_vlan_pri   =  user_define_pkt[14][7:5];
       	   ether_vlan_cfi   =  user_define_pkt[14][4];
       	   ether_ether_type = {user_define_pkt[16],user_define_pkt[17]};
       	   ether_payload    =  user_define_pkt[18:$];
       end else begin
           ether_vlan_valid = 1'b0;
       	   ether_payload    = user_define_pkt[14:$];
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
		   
		   logic [31:0] crc32;
		   
		   if (mode==PKT_MODE_USER_DEFINE)
		   	  pkt_data=user_define_pkt;
		   	  
		   if (preamble_en==1'b1) begin
		        pkt_data = {8'hd5,pkt_data};
		        for(int i =0;i<preamble_num;i++)
		            pkt_data = {8'h55,pkt_data};
		   end
		   
		   if(fcs32_en==1'b1) begin
     		   crc32=FCS32_CAL(pkt_data);
//     		   pkt_data={pkt_data,crc32[31:24],crc32[23:16],crc32[15:8],crc32[7:0]};
     		   pkt_data={pkt_data,{crc32[24],crc32[25],crc32[26],crc32[27],crc32[28],crc32[29],crc32[30],crc32[31]},
     		                      {crc32[16],crc32[17],crc32[18],crc32[19],crc32[20],crc32[21],crc32[22],crc32[23]},
     		                      {crc32[8],crc32[9],crc32[10],crc32[11],crc32[12],crc32[13],crc32[14],crc32[15]},
     		                      {crc32[0],crc32[1],crc32[2],crc32[3],crc32[4],crc32[5],crc32[6],crc32[7]}};
		   end  		   
	endtask
	
		
	//task get_packet_length;
	//	   output logic [15:0] length;
	//	   
	//	   logic [7:0] temp_array[$];
	//	   
	//	   get_packet(temp_array);
	//	   length=temp_array.size();
	//endtask
	
	
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

  function [31:0] FCS32_CAL;
      input [7:0] pkt_data[$];
      
      logic [31:0] crc;
      logic [7:0] data;
    
      begin 
      	   crc=32'hffffffff;
    	     for (int i=0;i <pkt_data.size();i++)
    	     begin
    	            data=pkt_data[i];
    	            data={data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7]};
    	     				crc = nextCRC32_D8(data,crc);
           end
           
           FCS32_CAL=~crc;
      end
   endfunction
        
  
  // polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
  // data width: 8
  // convention: the first serial bit is D[7]
  function [31:0] nextCRC32_D8;

    input [7:0] Data;
    input [31:0] crc;
    reg [7:0] d;
    reg [31:0] c;
    reg [31:0] newcrc;
  begin
    d = Data;
    c = crc;

    newcrc[0] = d[6] ^ d[0] ^ c[24] ^ c[30];
    newcrc[1] = d[7] ^ d[6] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[30] ^ c[31];
    newcrc[2] = d[7] ^ d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[26] ^ c[30] ^ c[31];
    newcrc[3] = d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[25] ^ c[26] ^ c[27] ^ c[31];
    newcrc[4] = d[6] ^ d[4] ^ d[3] ^ d[2] ^ d[0] ^ c[24] ^ c[26] ^ c[27] ^ c[28] ^ c[30];
    newcrc[5] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[6] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[7] = d[7] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[8] = d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
    newcrc[9] = d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29];
    newcrc[10] = d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[2] ^ c[24] ^ c[26] ^ c[27] ^ c[29];
    newcrc[11] = d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[3] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
    newcrc[12] = d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ d[0] ^ c[4] ^ c[24] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30];
    newcrc[13] = d[7] ^ d[6] ^ d[5] ^ d[3] ^ d[2] ^ d[1] ^ c[5] ^ c[25] ^ c[26] ^ c[27] ^ c[29] ^ c[30] ^ c[31];
    newcrc[14] = d[7] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ c[6] ^ c[26] ^ c[27] ^ c[28] ^ c[30] ^ c[31];
    newcrc[15] = d[7] ^ d[5] ^ d[4] ^ d[3] ^ c[7] ^ c[27] ^ c[28] ^ c[29] ^ c[31];
    newcrc[16] = d[5] ^ d[4] ^ d[0] ^ c[8] ^ c[24] ^ c[28] ^ c[29];
    newcrc[17] = d[6] ^ d[5] ^ d[1] ^ c[9] ^ c[25] ^ c[29] ^ c[30];
    newcrc[18] = d[7] ^ d[6] ^ d[2] ^ c[10] ^ c[26] ^ c[30] ^ c[31];
    newcrc[19] = d[7] ^ d[3] ^ c[11] ^ c[27] ^ c[31];
    newcrc[20] = d[4] ^ c[12] ^ c[28];
    newcrc[21] = d[5] ^ c[13] ^ c[29];
    newcrc[22] = d[0] ^ c[14] ^ c[24];
    newcrc[23] = d[6] ^ d[1] ^ d[0] ^ c[15] ^ c[24] ^ c[25] ^ c[30];
    newcrc[24] = d[7] ^ d[2] ^ d[1] ^ c[16] ^ c[25] ^ c[26] ^ c[31];
    newcrc[25] = d[3] ^ d[2] ^ c[17] ^ c[26] ^ c[27];
    newcrc[26] = d[6] ^ d[4] ^ d[3] ^ d[0] ^ c[18] ^ c[24] ^ c[27] ^ c[28] ^ c[30];
    newcrc[27] = d[7] ^ d[5] ^ d[4] ^ d[1] ^ c[19] ^ c[25] ^ c[28] ^ c[29] ^ c[31];
    newcrc[28] = d[6] ^ d[5] ^ d[2] ^ c[20] ^ c[26] ^ c[29] ^ c[30];
    newcrc[29] = d[7] ^ d[6] ^ d[3] ^ c[21] ^ c[27] ^ c[30] ^ c[31];
    newcrc[30] = d[7] ^ d[4] ^ c[22] ^ c[28] ^ c[31];
    newcrc[31] = d[5] ^ c[23] ^ c[29];
    nextCRC32_D8 = newcrc;
  end
  endfunction

endpackage


import pkt_package::* ;

`endif

