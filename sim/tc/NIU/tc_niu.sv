module tc_niu();

tb_niu tb();

//----------------------test case----------------------------------

initial    
begin    
wait(tb.init_done==1'b1)

//    pkt_generator.send_user_pkt("342342342342342423400099");
    tb.u_xgmii_pkt_generator.send_ether_pkt("112233445566aabbccddeeff810003220800452233445566778800110000c0a80022c0a80055334455664023ffffffffffffff33535235436677686352352aaaaaaa66");
    tb.u_xgmii_pkt_generator.send_ether_pkt("998877665544aabbccddeeff810003220800452233445566778800110000c0a80022c0a80055334455664023ffffffffffffff33535235436677686352352aaaaaaa66");
    tb.u_xgmii_pkt_generator.send_ether_pkt("112233445566aabbccddeeff810003220800452233445566778800110000c0a80022c0a80055334455664023ddffffffffffffff33535235436677686352352aaaaaaa66");
end

endmodule
