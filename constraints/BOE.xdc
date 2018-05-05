create_clock -period 5.000 -name mcb_clk_ref [get_ports clk_ref_p]


# Bank: 38 - Byte
set_property VCCAUX_IO DONTCARE [get_ports clk_ref_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_ref_p]

# Bank: 38 - Byte
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_ref_n]
set_property PACKAGE_PIN H19 [get_ports clk_ref_p]
set_property PACKAGE_PIN G18 [get_ports clk_ref_n]

create_clock -period 6.400 -name xgemac_clk_156 [get_ports xphy_refclk_p]

##GT Ref clk
set_property PACKAGE_PIN AH8 [get_ports xphy_refclk_p]
set_property PACKAGE_PIN AH7 [get_ports xphy_refclk_n]


create_generated_clock -name clk50 -source [get_ports clk_ref_p] -divide_by 4 [get_pins {u_clk_gen/clk_divide_reg[1]/Q}]
#set_clock_sense -positive u_NIU/clk_divide_reg[1]_i_1/O


#button
set_property PACKAGE_PIN AU38 [get_ports button_east]
set_property IOSTANDARD LVCMOS18 [get_ports button_east]
set_property PACKAGE_PIN AW40 [get_ports button_west]
set_property IOSTANDARD LVCMOS18 [get_ports button_west]

set_property PACKAGE_PIN AR40 [get_ports button_north]
set_property IOSTANDARD LVCMOS18 [get_ports button_north]
#set_property PACKAGE_PIN AP40 [get_ports button_south]
#set_property IOSTANDARD LVCMOS18 [get_ports button_south]
#set_property PACKAGE_PIN AV39 [get_ports button_center]
#set_property IOSTANDARD LVCMOS18 [get_ports button_center]


#UART
#set_property PACKAGE_PIN AU36 [get_ports TxD]
#set_property IOSTANDARD LVCMOS18 [get_ports TxD]

#set_property PACKAGE_PIN AU33 [get_ports RxD]
#set_property IOSTANDARD LVCMOS18 [get_ports RxD]

## bram locations
#set_property LOC RAMB36_X11Y69 [get_cells configIp/trmx/imx/ram[0].RAMB36_inst]
#set_property LOC RAMB36_X10Y68 [get_cells configIp/trmx/dmx/ram[0].RAMB36_inst]

# Needed by 10GBASE-R IP XDC
create_clock -period 6.400 -name clk156 [get_pins u_NIU/xgbaser_gt_wrapper_inst/clk156_bufg_inst/O]
create_clock -period 12.800 -name dclk [get_pins u_NIU/xgbaser_gt_wrapper_inst/dclk_bufg_inst/O]
create_clock -period 6.400 -name refclk [get_pins u_NIU/xgphy_refclk_ibuf/O]

# Needed by SmartCam
#create_clock -name clkout0 -period 6.400 [get_pins SmartCamCtl_inst/clk_u/clkout1_buf/O]
#create_clock -name clkout0 -period 6.400 [get_pins SmartCamCtl_inst/clk_u/mmcm_adv_inst/CLKOUT0]
#SmartCamCtl_inst/clk_u/mmcm_adv_inst/CLKOUT0
#SmartCamCtl_inst/clk_u/mmcm_adv_inst/CLKOUT0
#SmartCamCtl_inst/clk_u/mmcm_adv_inst/CLKFBOUT


# SFP TX Disable for 10G PHY
set_property PACKAGE_PIN AB41 [get_ports {sfp_tx_disable[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sfp_tx_disable[0]}]
set_property PACKAGE_PIN Y42 [get_ports {sfp_tx_disable[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sfp_tx_disable[1]}]
set_property PACKAGE_PIN AC38 [get_ports {sfp_tx_disable[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sfp_tx_disable[2]}]
set_property PACKAGE_PIN AC40 [get_ports {sfp_tx_disable[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sfp_tx_disable[3]}]

#10G
#create_generated_clock -name ddrclock -divide_by 1 -invert -source [get_pins DUT/rx_clk_ddr/C] [get_ports DUT/xgmii_rx_clk]
#set_output_delay -max 1.500 -clock [get_clocks ddrclock] [get_ports * -filter {NAME =~ *xgmii_rxd*}]
#set_output_delay -min -1.500 -clock [get_clocks ddrclock] [get_ports * -filter {NAME =~ *xgmii_rxd*}]
#set_output_delay -max 1.500 -clock [get_clocks ddrclock] [get_ports * -filter {NAME =~ *xgmii_rxc*}]
#set_output_delay -min -1.500 -clock [get_clocks ddrclock] [get_ports * -filter {NAME =~ *xgmii_rxc*}]

# False paths for async reset removal synchronizers
#set_false_path -to [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ ten_gig_eth_pcs_pma_core_support_layer/*shared*txusrclk2*}] -filter {NAME =~ *PRE}]
#set_false_path -to [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ ten_gig_eth_pcs_pma_core_support_layer/*shared*txusrclk2*}] -filter {NAME =~ *CLR}]
#set_false_path -to [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ ten_gig_eth_pcs_pma_core_support_layer/*shared*areset_refclk_bufh*}] -filter {NAME =~ *PRE}]
#set_false_path -to [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ ten_gig_eth_pcs_pma_core_support_layer/*shared*areset_clk156*}] -filter {NAME =~ *PRE}]
#set_false_path -to [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ ten_gig_eth_pcs_pma_core_support_layer/*shared*mmcm_locked_clk156*}] -filter {NAME =~ *CLR}]

##---------------------------------------------------------------------------------------
## 10GBASE-R constraints
##---------------------------------------------------------------------------------------
## SFP+ Cage mapping on VC709
# P2 --> X1Y13
# P3 --> X1Y12
# P4 --> X1Y14
# P5 --> X1Y15
## GT placement ## MGT_BANK_113

## Sample constraint for GT location
#set_property LOC GTHE2_CHANNEL_X1Y12 [get_cells u_NIU/network_inst_0/ten_gig_eth_pcs_pma_inst/inst/gt0_gtwizard_gth_10gbaser_i/gthe2_i]
#set_property LOC GTHE2_CHANNEL_X1Y13 [get_cells network_inst_1/ten_gig_eth_pcs_pma_inst/inst/gt0_gtwizard_gth_10gbaser_i/gthe2_i]
#set_property LOC GTHE2_CHANNEL_X1Y14 [get_cells network_inst_2/ten_gig_eth_pcs_pma_inst/inst/gt0_gtwizard_gth_10gbaser_i/gthe2_i]
#set_property LOC GTHE2_CHANNEL_X1Y15 [get_cells network_inst_3/ten_gig_eth_pcs_pma_inst/inst/gt0_gtwizard_gth_10gbaser_i/gthe2_i]

#set_property LOC GTHE2_CHANNEL_X1Y12 [get_cells DUT/ten_gig_eth_pcs_pma_core_support_layer/ten_gig_eth_pcs_pma_block/inst/gt0_gtwizard_gth_10gbaser_i/gthe2_i]
#set_property LOC GTHE2_CHANNEL_X1Y13 [get_cells inst_1/ten_gig_eth_pcs_pma_core_support_layer/ten_gig_eth_pcs_pma_block/*/gt0_gtwizard_gth_10gbaser_i/gthe2_i]
#set_property LOC GTHE2_COMMON_X1Y5 [get_cells */ten_gig_eth_pcs_pma_core_support_layer/ten_gig_eth_pcs_pma_gt_common_block/gthe2_common_0_i]

#set_property IOSTANDARD HSTL_I [get_ports {xgmii_txc[*]}]
#set_property IOSTANDARD HSTL_I [get_ports {xgmii_txd[*]}]

#set_property IOSTANDARD HSTL_I [get_ports {xgmii_rxc[*]}]
#set_property IOSTANDARD HSTL_I [get_ports {xgmii_rxd[*]}]

#set_property IOB TRUE [get_cells {xgmii_rxc_reg[*]}]
#set_property IOB TRUE [get_cells {xgmii_rxd_reg[*]}]

#set_property IOSTANDARD HSTL_I [get_ports xgmii_rx_clk]

set_property PACKAGE_PIN AN5 [get_ports xphy0_rxn]
set_property PACKAGE_PIN AN6 [get_ports xphy0_rxp]
set_property PACKAGE_PIN AP3 [get_ports xphy0_txn]
set_property PACKAGE_PIN AP4 [get_ports xphy0_txp]

#set_property PACKAGE_PIN AN2 [get_ports xphy1_txp]
#set_property PACKAGE_PIN AN1 [get_ports xphy1_txn]
#set_property PACKAGE_PIN AM8 [get_ports xphy1_rxp]
#set_property PACKAGE_PIN AM7 [get_ports xphy1_rxn]

#set_property PACKAGE_PIN AM4 [get_ports xphy2_txp]
#set_property PACKAGE_PIN AM3 [get_ports xphy2_txn]
#set_property PACKAGE_PIN AL6 [get_ports xphy2_rxp]
#set_property PACKAGE_PIN AL5 [get_ports xphy2_rxn]

#set_property PACKAGE_PIN AL2 [get_ports xphy3_txp]
#set_property PACKAGE_PIN AL1 [get_ports xphy3_txn]
#set_property PACKAGE_PIN AJ6 [get_ports xphy3_rxp]
#set_property PACKAGE_PIN AJ5 [get_ports xphy3_rxn]

#create_clock -name xphy_rxusrclkout0 -period 3.103 [get_pins u_NIU/network_inst_0/ten_gig_eth_pcs_pma_inst/inst/gt0_gtwizard_gth_10gbaser_i/gthe2_i/RXOUTCLK]
#create_clock -name xphy_txusrclkout0 -period 3.103 [get_pins u_NIU/network_inst_0/ten_gig_eth_pcs_pma_inst/inst/gt0_gtwizard_gth_10gbaser_i/gthe2_i/TXOUTCLK]
#create_clock -name xphy_rxusrclkout1 -period 3.103 [get_pins network_inst_1/ten_gig_eth_pcs_pma_inst/inst/gt0_gtwizard_gth_10gbaser_i/gthe2_i/RXOUTCLK]
#create_clock -name xphy_txusrclkout1 -period 3.103 [get_pins network_inst_1/ten_gig_eth_pcs_pma_inst/inst/gt0_gtwizard_gth_10gbaser_i/gthe2_i/TXOUTCLK]
#create_clock -name xphy_rxusrclkout2 -period 3.103 [get_pins network_inst_2/ten_gig_eth_pcs_pma_inst/inst/gt0_gtwizard_gth_10gbaser_i/gthe2_i/RXOUTCLK]
#create_clock -name xphy_txusrclkout2 -period 3.103 [get_pins network_inst_2/ten_gig_eth_pcs_pma_inst/inst/gt0_gtwizard_gth_10gbaser_i/gthe2_i/TXOUTCLK]
#create_clock -name xphy_rxusrclkout3 -period 3.103 [get_pins network_inst_3/ten_gig_eth_pcs_pma_inst/inst/gt0_gtwizard_gth_10gbaser_i/gthe2_i/RXOUTCLK]
#create_clock -name xphy_txusrclkout3 -period 3.103 [get_pins network_inst_3/ten_gig_eth_pcs_pma_inst/inst/gt0_gtwizard_gth_10gbaser_i/gthe2_i/TXOUTCLK]

##-------------------------------------
## LED Status Pinout   (bottom to top)
##-------------------------------------

set_property PACKAGE_PIN AM39 [get_ports {led[0]}]
set_property PACKAGE_PIN AN39 [get_ports {led[1]}]
set_property PACKAGE_PIN AR37 [get_ports {led[2]}]
set_property PACKAGE_PIN AT37 [get_ports {led[3]}]
set_property PACKAGE_PIN AR35 [get_ports {led[4]}]
set_property PACKAGE_PIN AP41 [get_ports {led[5]}]
set_property PACKAGE_PIN AP42 [get_ports {led[6]}]
set_property PACKAGE_PIN AU39 [get_ports {led[7]}]

set_property IOSTANDARD LVCMOS18 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[7]}]

set_property SLEW SLOW [get_ports {led[7]}]
set_property SLEW SLOW [get_ports {led[6]}]
set_property SLEW SLOW [get_ports {led[5]}]
set_property SLEW SLOW [get_ports {led[4]}]
set_property SLEW SLOW [get_ports {led[3]}]
set_property SLEW SLOW [get_ports {led[2]}]
set_property SLEW SLOW [get_ports {led[1]}]
set_property SLEW SLOW [get_ports {led[0]}]
set_property DRIVE 4 [get_ports {led[7]}]
set_property DRIVE 4 [get_ports {led[6]}]
set_property DRIVE 4 [get_ports {led[5]}]
set_property DRIVE 4 [get_ports {led[4]}]
set_property DRIVE 4 [get_ports {led[3]}]
set_property DRIVE 4 [get_ports {led[2]}]
set_property DRIVE 4 [get_ports {led[1]}]
set_property DRIVE 4 [get_ports {led[0]}]


##
## Switches
##
set_property PACKAGE_PIN AV30 [get_ports {gpio_switch[0]}]
set_property PACKAGE_PIN AY33 [get_ports {gpio_switch[1]}]
set_property PACKAGE_PIN BA31 [get_ports {gpio_switch[2]}]
set_property PACKAGE_PIN BA32 [get_ports {gpio_switch[3]}]
set_property PACKAGE_PIN AW30 [get_ports {gpio_switch[4]}]
set_property PACKAGE_PIN AY30 [get_ports {gpio_switch[5]}]
set_property PACKAGE_PIN BA30 [get_ports {gpio_switch[6]}]
set_property PACKAGE_PIN BB31 [get_ports {gpio_switch[7]}]

set_property IOSTANDARD LVCMOS18 [get_ports {gpio_switch[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {gpio_switch[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {gpio_switch[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {gpio_switch[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {gpio_switch[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {gpio_switch[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {gpio_switch[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {gpio_switch[7]}]

#i2c clk & stuff
set_property IOSTANDARD LVCMOS18 [get_ports i2c_clk]
set_property SLEW SLOW [get_ports i2c_clk]
set_property DRIVE 16 [get_ports i2c_clk]
set_property PULLUP true [get_ports i2c_clk]
set_property PACKAGE_PIN AT35 [get_ports i2c_clk]

set_property IOSTANDARD LVCMOS18 [get_ports i2c_data]
set_property SLEW SLOW [get_ports i2c_data]
set_property DRIVE 16 [get_ports i2c_data]
set_property PULLUP true [get_ports i2c_data]
set_property PACKAGE_PIN AU32 [get_ports i2c_data]

set_property IOSTANDARD LVCMOS18 [get_ports i2c_mux_rst_n]
set_property SLEW SLOW [get_ports i2c_mux_rst_n]
set_property DRIVE 16 [get_ports i2c_mux_rst_n]
set_property PACKAGE_PIN AY42 [get_ports i2c_mux_rst_n]

set_property IOSTANDARD LVCMOS18 [get_ports si5324_rst_n]
set_property SLEW SLOW [get_ports si5324_rst_n]
set_property DRIVE 16 [get_ports si5324_rst_n]
set_property PACKAGE_PIN AT36 [get_ports si5324_rst_n]


#Domain crossing constraints
set_clock_groups -name async_mcb_xgemac -asynchronous -group [get_clocks mcb_clk_ref] -group [get_clocks clk156]



set_clock_groups -name async_mig_ref_clk50 -asynchronous -group [get_clocks mcb_clk_ref] -group [get_clocks clk50]


#set_clock_groups -name async_rxusrclk_xgemac -asynchronous #  -group [get_clocks  xphy_rxusrclkout?] #  -group [get_clocks  clk156]

#set_clock_groups -name async_txusrclk_xgemac -asynchronous #  -group [get_clocks  xphy_txusrclkout?] #  -group [get_clocks  clk156]

#  set_clock_groups -name async_txusrclk_refclk -asynchronous #    -group [get_clocks  xphy_txusrclkout?] #    -group [get_clocks  -include_generated_clocks refclk]


set_clock_groups -name async_xgemac_drpclk -asynchronous -group [get_clocks -include_generated_clocks clk156] -group [get_clocks -include_generated_clocks dclk]

set_clock_groups -name async_xgemac_clk50 -asynchronous -group [get_clocks -include_generated_clocks clk156] -group [get_clocks clk50]

####contraints from DRAM MEM inf
create_clock -period 4.708 -name sys_clk [get_ports sys_clk_p]

# PadFunction: IO_L13P_T2_MRCC_32
set_property VCCAUX_IO DONTCARE [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p]

# PadFunction: IO_L13N_T2_MRCC_32
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_n]
set_property PACKAGE_PIN AY18 [get_ports sys_clk_p]
set_property PACKAGE_PIN AY17 [get_ports sys_clk_n]

# Reset
# PadFunction: IO_L13P_T2_MRCC_15
set_property VCCAUX_IO DONTCARE [get_ports sys_rst_i]
set_property IOSTANDARD LVCMOS18 [get_ports sys_rst_i]
set_property PACKAGE_PIN AV40 [get_ports sys_rst_i]


set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets clk233]

set_clock_groups -name clk156_pll_i -asynchronous -group [get_clocks clk_pll_i] -group [get_clocks clk156]
set_clock_groups -name clk156_pll_i_1 -asynchronous -group [get_clocks clk_pll_i_1] -group [get_clocks clk156]




create_clock -period 10.000 -name pcie_ref_clk [get_ports pcie_ref_clk_p]
set_false_path -from [get_ports pcie_sys_rst_n]
set_property PACKAGE_PIN AV35 [get_ports pcie_sys_rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_sys_rst_n]
set_property PULLUP true [get_ports pcie_sys_rst_n]
set_property LOC IBUFDS_GTE2_X1Y11 [get_cells refclk_ibuf]
set_false_path -to [get_ports -filter NAME=~led_*]

set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.BPI_SYNC_MODE Type1 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN div-1 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CONFIG_MODE BPI16 [current_design]
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

#create_debug_core u_ila_0 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
#set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#set_property port_width 1 [get_debug_ports u_ila_0/clk]
#connect_debug_port u_ila_0/clk [get_nets [list u_NIU/xgbaser_gt_wrapper_inst/coreclk]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
#set_property port_width 54 [get_debug_ports u_ila_0/probe0]
#connect_debug_port u_ila_0/probe0 [get_nets [list {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[0]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[1]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[2]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[3]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[4]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[5]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[6]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[7]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[8]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[9]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[10]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[11]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[12]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[13]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[14]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[15]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[16]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[17]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[18]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[19]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[20]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[21]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[22]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[23]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[24]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[25]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[26]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[27]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[28]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[29]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[30]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[31]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[32]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[33]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[34]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[35]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[36]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[37]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[38]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[39]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[40]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[41]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[42]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[43]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[44]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[45]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[46]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[47]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[48]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[49]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[50]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[51]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[52]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_dout[53]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
#set_property port_width 54 [get_debug_ports u_ila_0/probe1]
#connect_debug_port u_ila_0/probe1 [get_nets [list {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[0]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[1]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[2]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[3]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[4]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[5]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[6]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[7]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[8]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[9]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[10]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[11]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[12]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[13]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[14]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[15]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[16]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[17]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[18]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[19]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[20]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[21]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[22]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[23]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[24]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[25]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[26]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[27]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[28]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[29]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[30]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[31]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[32]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[33]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[34]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[35]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[36]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[37]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[38]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[39]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[40]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[41]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[42]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[43]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[44]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[45]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[46]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[47]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[48]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[49]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[50]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[51]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[52]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_dout[53]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
#set_property port_width 150 [get_debug_ports u_ila_0/probe2]
#connect_debug_port u_ila_0/probe2 [get_nets [list {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[0]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[1]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[2]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[3]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[4]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[5]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[6]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[7]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[8]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[9]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[10]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[11]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[12]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[13]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[14]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[15]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[16]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[17]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[18]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[19]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[20]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[21]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[22]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[23]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[24]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[25]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[26]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[27]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[28]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[29]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[30]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[31]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[32]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[33]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[34]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[35]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[36]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[37]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[38]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[39]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[40]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[41]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[42]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[43]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[44]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[45]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[46]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[47]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[48]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[49]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[50]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[51]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[52]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[53]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[54]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[55]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[56]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[57]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[58]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[59]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[60]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[61]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[62]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[63]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[64]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[65]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[66]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[67]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[68]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[69]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[70]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[71]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[72]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[73]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[74]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[75]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[76]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[77]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[78]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[79]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[80]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[81]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[82]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[83]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[84]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[85]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[86]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[87]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[88]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[89]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[90]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[91]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[92]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[93]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[94]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[95]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[96]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[97]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[98]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[99]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[100]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[101]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[102]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[103]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[104]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[105]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[106]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[107]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[108]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[109]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[110]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[111]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[112]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[113]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[114]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[115]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[116]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[117]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[118]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[119]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[120]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[121]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[122]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[123]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[124]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[125]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[126]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[127]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[128]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[129]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[130]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[131]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[132]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[133]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[134]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[135]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[136]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[137]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[138]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[139]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[140]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[141]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[142]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[143]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[144]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[145]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[146]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[147]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[148]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_din[149]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
#set_property port_width 150 [get_debug_ports u_ila_0/probe3]
#connect_debug_port u_ila_0/probe3 [get_nets [list {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[0]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[1]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[2]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[3]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[4]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[5]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[6]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[7]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[8]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[9]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[10]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[11]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[12]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[13]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[14]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[15]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[16]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[17]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[18]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[19]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[20]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[21]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[22]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[23]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[24]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[25]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[26]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[27]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[28]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[29]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[30]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[31]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[32]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[33]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[34]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[35]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[36]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[37]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[38]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[39]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[40]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[41]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[42]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[43]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[44]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[45]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[46]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[47]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[48]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[49]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[50]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[51]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[52]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[53]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[54]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[55]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[56]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[57]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[58]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[59]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[60]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[61]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[62]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[63]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[64]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[65]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[66]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[67]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[68]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[69]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[70]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[71]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[72]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[73]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[74]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[75]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[76]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[77]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[78]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[79]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[80]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[81]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[82]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[83]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[84]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[85]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[86]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[87]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[88]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[89]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[90]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[91]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[92]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[93]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[94]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[95]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[96]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[97]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[98]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[99]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[100]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[101]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[102]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[103]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[104]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[105]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[106]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[107]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[108]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[109]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[110]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[111]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[112]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[113]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[114]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[115]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[116]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[117]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[118]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[119]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[120]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[121]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[122]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[123]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[124]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[125]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[126]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[127]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[128]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[129]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[130]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[131]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[132]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[133]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[134]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[135]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[136]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[137]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[138]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[139]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[140]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[141]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[142]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[143]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[144]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[145]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[146]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[147]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[148]} {network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_dout[149]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
#set_property port_width 1 [get_debug_ports u_ila_0/probe4]
#connect_debug_port u_ila_0/probe4 [get_nets [list network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/eventEng2ackDelay_event_V_write]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
#set_property port_width 1 [get_debug_ports u_ila_0/probe5]
#connect_debug_port u_ila_0/probe5 [get_nets [list {network_stack_inst/toe_inst/inst/toe_U/toe_rxEngMemWrite_U0/gen_sr[15].mem_reg[15][32]_srl16_i_6_n_0}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
#set_property port_width 1 [get_debug_ports u_ila_0/probe6]
#connect_debug_port u_ila_0/probe6 [get_nets [list network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/rxEng2eventEng_setEvent_V_read]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
#set_property port_width 1 [get_debug_ports u_ila_0/probe7]
#connect_debug_port u_ila_0/probe7 [get_nets [list network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/timer2eventEng_setEvent_V_read]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
#set_property port_width 1 [get_debug_ports u_ila_0/probe8]
#connect_debug_port u_ila_0/probe8 [get_nets [list network_stack_inst/toe_inst/inst/toe_U/toe_event_engine_U0/txApp2eventEng_setEvent_V_read]]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets axi_clk]






connect_debug_port u_ila_0/probe69 [get_nets [list {network_stack_inst/toe_inst/inst/toe_U/toe_tasi_pkg_pusher_U0/tasi_pushMeta_drop_reg_n_0_[0]}]]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list u_NIU/xgbaser_gt_wrapper_inst/coreclk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {u_NIU/niu_single_inst/niu_rx_inst/state_rd[0]} {u_NIU/niu_single_inst/niu_rx_inst/state_rd[1]} {u_NIU/niu_single_inst/niu_rx_inst/state_rd[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 4 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {u_NIU/niu_single_inst/niu_rx_inst/state_wr[0]} {u_NIU/niu_single_inst/niu_rx_inst/state_wr[1]} {u_NIU/niu_single_inst/niu_rx_inst/state_wr[2]} {u_NIU/niu_single_inst/niu_rx_inst/state_wr[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 64 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[0]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[1]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[2]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[3]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[4]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[5]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[6]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[7]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[8]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[9]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[10]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[11]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[12]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[13]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[14]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[15]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[16]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[17]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[18]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[19]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[20]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[21]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[22]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[23]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[24]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[25]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[26]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[27]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[28]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[29]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[30]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[31]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[32]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[33]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[34]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[35]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[36]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[37]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[38]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[39]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[40]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[41]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[42]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[43]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[44]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[45]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[46]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[47]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[48]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[49]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[50]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[51]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[52]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[53]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[54]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[55]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[56]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[57]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[58]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[59]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[60]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[61]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[62]} {u_NIU/niu_single_inst/xgmac2rx_axis_tdata[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {u_NIU/niu_single_inst/xgmac2rx_axis_tkeep[0]} {u_NIU/niu_single_inst/xgmac2rx_axis_tkeep[1]} {u_NIU/niu_single_inst/xgmac2rx_axis_tkeep[2]} {u_NIU/niu_single_inst/xgmac2rx_axis_tkeep[3]} {u_NIU/niu_single_inst/xgmac2rx_axis_tkeep[4]} {u_NIU/niu_single_inst/xgmac2rx_axis_tkeep[5]} {u_NIU/niu_single_inst/xgmac2rx_axis_tkeep[6]} {u_NIU/niu_single_inst/xgmac2rx_axis_tkeep[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {myEchoServer/m_axis_tx_metadata_TDATA[0]} {myEchoServer/m_axis_tx_metadata_TDATA[1]} {myEchoServer/m_axis_tx_metadata_TDATA[2]} {myEchoServer/m_axis_tx_metadata_TDATA[3]} {myEchoServer/m_axis_tx_metadata_TDATA[4]} {myEchoServer/m_axis_tx_metadata_TDATA[5]} {myEchoServer/m_axis_tx_metadata_TDATA[6]} {myEchoServer/m_axis_tx_metadata_TDATA[7]} {myEchoServer/m_axis_tx_metadata_TDATA[8]} {myEchoServer/m_axis_tx_metadata_TDATA[9]} {myEchoServer/m_axis_tx_metadata_TDATA[10]} {myEchoServer/m_axis_tx_metadata_TDATA[11]} {myEchoServer/m_axis_tx_metadata_TDATA[12]} {myEchoServer/m_axis_tx_metadata_TDATA[13]} {myEchoServer/m_axis_tx_metadata_TDATA[14]} {myEchoServer/m_axis_tx_metadata_TDATA[15]} {myEchoServer/m_axis_tx_metadata_TDATA[16]} {myEchoServer/m_axis_tx_metadata_TDATA[17]} {myEchoServer/m_axis_tx_metadata_TDATA[18]} {myEchoServer/m_axis_tx_metadata_TDATA[19]} {myEchoServer/m_axis_tx_metadata_TDATA[20]} {myEchoServer/m_axis_tx_metadata_TDATA[21]} {myEchoServer/m_axis_tx_metadata_TDATA[22]} {myEchoServer/m_axis_tx_metadata_TDATA[23]} {myEchoServer/m_axis_tx_metadata_TDATA[24]} {myEchoServer/m_axis_tx_metadata_TDATA[25]} {myEchoServer/m_axis_tx_metadata_TDATA[26]} {myEchoServer/m_axis_tx_metadata_TDATA[27]} {myEchoServer/m_axis_tx_metadata_TDATA[28]} {myEchoServer/m_axis_tx_metadata_TDATA[29]} {myEchoServer/m_axis_tx_metadata_TDATA[30]} {myEchoServer/m_axis_tx_metadata_TDATA[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 17 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {myEchoServer/s_axis_tx_status_TDATA[0]} {myEchoServer/s_axis_tx_status_TDATA[1]} {myEchoServer/s_axis_tx_status_TDATA[2]} {myEchoServer/s_axis_tx_status_TDATA[3]} {myEchoServer/s_axis_tx_status_TDATA[4]} {myEchoServer/s_axis_tx_status_TDATA[5]} {myEchoServer/s_axis_tx_status_TDATA[6]} {myEchoServer/s_axis_tx_status_TDATA[7]} {myEchoServer/s_axis_tx_status_TDATA[8]} {myEchoServer/s_axis_tx_status_TDATA[9]} {myEchoServer/s_axis_tx_status_TDATA[10]} {myEchoServer/s_axis_tx_status_TDATA[11]} {myEchoServer/s_axis_tx_status_TDATA[12]} {myEchoServer/s_axis_tx_status_TDATA[13]} {myEchoServer/s_axis_tx_status_TDATA[14]} {myEchoServer/s_axis_tx_status_TDATA[15]} {myEchoServer/s_axis_tx_status_TDATA[16]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {network_stack_inst/mac_merger/M00_AXIS_TKEEP[0]} {network_stack_inst/mac_merger/M00_AXIS_TKEEP[1]} {network_stack_inst/mac_merger/M00_AXIS_TKEEP[2]} {network_stack_inst/mac_merger/M00_AXIS_TKEEP[3]} {network_stack_inst/mac_merger/M00_AXIS_TKEEP[4]} {network_stack_inst/mac_merger/M00_AXIS_TKEEP[5]} {network_stack_inst/mac_merger/M00_AXIS_TKEEP[6]} {network_stack_inst/mac_merger/M00_AXIS_TKEEP[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 64 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {network_stack_inst/mac_merger/S00_AXIS_TDATA[0]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[1]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[2]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[3]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[4]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[5]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[6]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[7]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[8]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[9]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[10]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[11]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[12]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[13]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[14]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[15]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[16]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[17]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[18]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[19]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[20]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[21]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[22]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[23]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[24]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[25]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[26]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[27]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[28]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[29]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[30]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[31]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[32]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[33]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[34]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[35]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[36]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[37]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[38]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[39]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[40]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[41]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[42]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[43]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[44]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[45]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[46]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[47]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[48]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[49]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[50]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[51]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[52]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[53]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[54]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[55]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[56]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[57]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[58]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[59]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[60]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[61]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[62]} {network_stack_inst/mac_merger/S00_AXIS_TDATA[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {network_stack_inst/mac_merger/S01_AXIS_TKEEP[0]} {network_stack_inst/mac_merger/S01_AXIS_TKEEP[1]} {network_stack_inst/mac_merger/S01_AXIS_TKEEP[2]} {network_stack_inst/mac_merger/S01_AXIS_TKEEP[3]} {network_stack_inst/mac_merger/S01_AXIS_TKEEP[4]} {network_stack_inst/mac_merger/S01_AXIS_TKEEP[5]} {network_stack_inst/mac_merger/S01_AXIS_TKEEP[6]} {network_stack_inst/mac_merger/S01_AXIS_TKEEP[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 8 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {network_stack_inst/mac_merger/S00_AXIS_TKEEP[0]} {network_stack_inst/mac_merger/S00_AXIS_TKEEP[1]} {network_stack_inst/mac_merger/S00_AXIS_TKEEP[2]} {network_stack_inst/mac_merger/S00_AXIS_TKEEP[3]} {network_stack_inst/mac_merger/S00_AXIS_TKEEP[4]} {network_stack_inst/mac_merger/S00_AXIS_TKEEP[5]} {network_stack_inst/mac_merger/S00_AXIS_TKEEP[6]} {network_stack_inst/mac_merger/S00_AXIS_TKEEP[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 64 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {network_stack_inst/mac_merger/S01_AXIS_TDATA[0]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[1]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[2]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[3]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[4]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[5]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[6]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[7]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[8]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[9]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[10]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[11]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[12]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[13]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[14]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[15]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[16]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[17]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[18]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[19]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[20]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[21]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[22]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[23]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[24]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[25]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[26]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[27]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[28]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[29]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[30]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[31]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[32]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[33]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[34]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[35]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[36]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[37]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[38]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[39]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[40]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[41]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[42]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[43]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[44]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[45]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[46]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[47]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[48]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[49]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[50]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[51]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[52]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[53]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[54]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[55]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[56]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[57]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[58]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[59]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[60]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[61]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[62]} {network_stack_inst/mac_merger/S01_AXIS_TDATA[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 64 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {network_stack_inst/mac_merger/M00_AXIS_TDATA[0]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[1]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[2]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[3]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[4]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[5]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[6]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[7]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[8]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[9]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[10]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[11]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[12]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[13]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[14]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[15]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[16]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[17]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[18]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[19]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[20]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[21]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[22]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[23]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[24]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[25]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[26]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[27]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[28]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[29]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[30]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[31]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[32]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[33]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[34]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[35]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[36]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[37]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[38]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[39]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[40]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[41]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[42]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[43]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[44]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[45]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[46]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[47]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[48]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[49]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[50]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[51]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[52]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[53]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[54]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[55]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[56]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[57]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[58]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[59]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[60]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[61]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[62]} {network_stack_inst/mac_merger/M00_AXIS_TDATA[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {network_stack_inst/ip_handler_inst/m_axis_ARP_TLAST[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 8 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {network_stack_inst/ip_handler_inst/m_axis_ARP_TKEEP[0]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TKEEP[1]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TKEEP[2]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TKEEP[3]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TKEEP[4]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TKEEP[5]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TKEEP[6]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TKEEP[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 8 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {network_stack_inst/ip_handler_inst/s_axis_raw_TKEEP[0]} {network_stack_inst/ip_handler_inst/s_axis_raw_TKEEP[1]} {network_stack_inst/ip_handler_inst/s_axis_raw_TKEEP[2]} {network_stack_inst/ip_handler_inst/s_axis_raw_TKEEP[3]} {network_stack_inst/ip_handler_inst/s_axis_raw_TKEEP[4]} {network_stack_inst/ip_handler_inst/s_axis_raw_TKEEP[5]} {network_stack_inst/ip_handler_inst/s_axis_raw_TKEEP[6]} {network_stack_inst/ip_handler_inst/s_axis_raw_TKEEP[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 64 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[0]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[1]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[2]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[3]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[4]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[5]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[6]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[7]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[8]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[9]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[10]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[11]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[12]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[13]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[14]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[15]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[16]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[17]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[18]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[19]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[20]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[21]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[22]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[23]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[24]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[25]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[26]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[27]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[28]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[29]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[30]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[31]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[32]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[33]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[34]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[35]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[36]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[37]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[38]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[39]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[40]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[41]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[42]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[43]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[44]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[45]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[46]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[47]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[48]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[49]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[50]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[51]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[52]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[53]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[54]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[55]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[56]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[57]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[58]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[59]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[60]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[61]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[62]} {network_stack_inst/ip_handler_inst/s_axis_raw_TDATA[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 8 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {network_stack_inst/ip_handler_inst/m_axis_TCP_TKEEP[0]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TKEEP[1]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TKEEP[2]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TKEEP[3]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TKEEP[4]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TKEEP[5]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TKEEP[6]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TKEEP[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 64 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[0]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[1]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[2]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[3]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[4]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[5]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[6]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[7]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[8]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[9]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[10]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[11]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[12]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[13]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[14]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[15]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[16]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[17]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[18]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[19]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[20]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[21]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[22]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[23]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[24]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[25]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[26]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[27]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[28]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[29]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[30]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[31]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[32]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[33]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[34]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[35]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[36]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[37]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[38]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[39]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[40]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[41]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[42]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[43]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[44]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[45]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[46]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[47]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[48]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[49]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[50]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[51]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[52]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[53]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[54]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[55]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[56]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[57]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[58]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[59]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[60]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[61]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[62]} {network_stack_inst/ip_handler_inst/m_axis_TCP_TDATA[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {network_stack_inst/ip_handler_inst/m_axis_TCP_TLAST[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {network_stack_inst/ip_handler_inst/s_axis_raw_TLAST[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 8 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {network_stack_inst/ip_handler_inst/m_axis_ICMP_TKEEP[0]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TKEEP[1]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TKEEP[2]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TKEEP[3]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TKEEP[4]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TKEEP[5]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TKEEP[6]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TKEEP[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {network_stack_inst/ip_handler_inst/m_axis_ICMP_TLAST[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 64 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[0]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[1]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[2]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[3]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[4]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[5]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[6]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[7]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[8]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[9]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[10]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[11]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[12]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[13]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[14]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[15]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[16]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[17]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[18]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[19]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[20]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[21]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[22]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[23]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[24]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[25]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[26]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[27]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[28]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[29]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[30]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[31]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[32]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[33]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[34]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[35]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[36]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[37]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[38]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[39]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[40]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[41]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[42]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[43]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[44]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[45]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[46]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[47]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[48]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[49]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[50]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[51]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[52]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[53]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[54]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[55]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[56]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[57]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[58]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[59]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[60]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[61]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[62]} {network_stack_inst/ip_handler_inst/m_axis_ICMP_TDATA[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 64 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[0]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[1]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[2]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[3]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[4]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[5]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[6]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[7]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[8]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[9]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[10]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[11]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[12]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[13]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[14]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[15]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[16]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[17]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[18]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[19]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[20]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[21]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[22]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[23]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[24]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[25]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[26]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[27]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[28]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[29]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[30]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[31]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[32]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[33]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[34]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[35]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[36]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[37]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[38]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[39]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[40]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[41]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[42]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[43]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[44]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[45]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[46]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[47]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[48]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[49]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[50]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[51]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[52]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[53]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[54]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[55]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[56]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[57]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[58]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[59]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[60]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[61]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[62]} {network_stack_inst/ip_handler_inst/m_axis_ARP_TDATA[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 8 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {network_stack_inst/ip_merger/S02_AXIS_TKEEP[0]} {network_stack_inst/ip_merger/S02_AXIS_TKEEP[1]} {network_stack_inst/ip_merger/S02_AXIS_TKEEP[2]} {network_stack_inst/ip_merger/S02_AXIS_TKEEP[3]} {network_stack_inst/ip_merger/S02_AXIS_TKEEP[4]} {network_stack_inst/ip_merger/S02_AXIS_TKEEP[5]} {network_stack_inst/ip_merger/S02_AXIS_TKEEP[6]} {network_stack_inst/ip_merger/S02_AXIS_TKEEP[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 64 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {network_stack_inst/ip_merger/S02_AXIS_TDATA[0]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[1]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[2]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[3]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[4]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[5]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[6]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[7]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[8]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[9]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[10]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[11]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[12]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[13]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[14]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[15]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[16]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[17]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[18]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[19]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[20]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[21]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[22]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[23]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[24]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[25]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[26]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[27]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[28]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[29]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[30]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[31]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[32]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[33]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[34]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[35]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[36]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[37]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[38]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[39]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[40]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[41]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[42]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[43]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[44]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[45]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[46]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[47]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[48]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[49]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[50]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[51]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[52]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[53]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[54]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[55]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[56]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[57]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[58]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[59]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[60]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[61]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[62]} {network_stack_inst/ip_merger/S02_AXIS_TDATA[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 8 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {network_stack_inst/ip_merger/S01_AXIS_TKEEP[0]} {network_stack_inst/ip_merger/S01_AXIS_TKEEP[1]} {network_stack_inst/ip_merger/S01_AXIS_TKEEP[2]} {network_stack_inst/ip_merger/S01_AXIS_TKEEP[3]} {network_stack_inst/ip_merger/S01_AXIS_TKEEP[4]} {network_stack_inst/ip_merger/S01_AXIS_TKEEP[5]} {network_stack_inst/ip_merger/S01_AXIS_TKEEP[6]} {network_stack_inst/ip_merger/S01_AXIS_TKEEP[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 64 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {network_stack_inst/ip_merger/S01_AXIS_TDATA[0]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[1]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[2]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[3]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[4]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[5]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[6]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[7]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[8]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[9]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[10]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[11]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[12]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[13]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[14]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[15]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[16]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[17]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[18]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[19]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[20]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[21]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[22]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[23]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[24]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[25]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[26]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[27]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[28]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[29]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[30]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[31]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[32]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[33]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[34]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[35]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[36]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[37]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[38]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[39]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[40]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[41]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[42]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[43]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[44]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[45]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[46]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[47]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[48]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[49]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[50]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[51]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[52]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[53]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[54]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[55]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[56]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[57]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[58]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[59]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[60]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[61]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[62]} {network_stack_inst/ip_merger/S01_AXIS_TDATA[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 64 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {network_stack_inst/ip_merger/S00_AXIS_TDATA[0]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[1]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[2]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[3]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[4]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[5]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[6]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[7]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[8]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[9]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[10]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[11]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[12]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[13]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[14]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[15]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[16]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[17]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[18]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[19]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[20]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[21]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[22]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[23]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[24]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[25]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[26]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[27]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[28]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[29]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[30]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[31]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[32]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[33]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[34]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[35]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[36]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[37]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[38]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[39]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[40]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[41]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[42]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[43]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[44]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[45]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[46]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[47]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[48]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[49]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[50]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[51]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[52]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[53]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[54]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[55]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[56]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[57]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[58]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[59]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[60]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[61]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[62]} {network_stack_inst/ip_merger/S00_AXIS_TDATA[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 8 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {network_stack_inst/ip_merger/S00_AXIS_TKEEP[0]} {network_stack_inst/ip_merger/S00_AXIS_TKEEP[1]} {network_stack_inst/ip_merger/S00_AXIS_TKEEP[2]} {network_stack_inst/ip_merger/S00_AXIS_TKEEP[3]} {network_stack_inst/ip_merger/S00_AXIS_TKEEP[4]} {network_stack_inst/ip_merger/S00_AXIS_TKEEP[5]} {network_stack_inst/ip_merger/S00_AXIS_TKEEP[6]} {network_stack_inst/ip_merger/S00_AXIS_TKEEP[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 8 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {network_stack_inst/ip_merger/M00_AXIS_TKEEP[0]} {network_stack_inst/ip_merger/M00_AXIS_TKEEP[1]} {network_stack_inst/ip_merger/M00_AXIS_TKEEP[2]} {network_stack_inst/ip_merger/M00_AXIS_TKEEP[3]} {network_stack_inst/ip_merger/M00_AXIS_TKEEP[4]} {network_stack_inst/ip_merger/M00_AXIS_TKEEP[5]} {network_stack_inst/ip_merger/M00_AXIS_TKEEP[6]} {network_stack_inst/ip_merger/M00_AXIS_TKEEP[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 64 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {network_stack_inst/ip_merger/M00_AXIS_TDATA[0]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[1]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[2]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[3]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[4]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[5]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[6]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[7]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[8]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[9]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[10]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[11]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[12]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[13]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[14]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[15]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[16]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[17]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[18]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[19]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[20]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[21]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[22]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[23]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[24]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[25]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[26]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[27]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[28]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[29]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[30]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[31]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[32]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[33]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[34]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[35]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[36]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[37]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[38]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[39]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[40]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[41]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[42]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[43]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[44]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[45]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[46]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[47]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[48]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[49]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[50]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[51]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[52]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[53]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[54]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[55]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[56]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[57]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[58]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[59]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[60]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[61]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[62]} {network_stack_inst/ip_merger/M00_AXIS_TDATA[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list network_stack_inst/ip_merger/M00_AXIS_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list network_stack_inst/mac_merger/M00_AXIS_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list network_stack_inst/ip_merger/M00_AXIS_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list network_stack_inst/mac_merger/M00_AXIS_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list network_stack_inst/ip_merger/M00_AXIS_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list network_stack_inst/mac_merger/M00_AXIS_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list network_stack_inst/ip_handler_inst/m_axis_ARP_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list network_stack_inst/ip_handler_inst/m_axis_ARP_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list network_stack_inst/ip_handler_inst/m_axis_ICMP_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list network_stack_inst/ip_handler_inst/m_axis_ICMP_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 1 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list network_stack_inst/ip_handler_inst/m_axis_TCP_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 1 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list network_stack_inst/ip_handler_inst/m_axis_TCP_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 1 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list myEchoServer/m_axis_tx_metadata_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 1 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list myEchoServer/m_axis_tx_metadata_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 1 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list network_stack_inst/ip_merger/S00_AXIS_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
set_property port_width 1 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list network_stack_inst/mac_merger/S00_AXIS_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe48]
set_property port_width 1 [get_debug_ports u_ila_0/probe48]
connect_debug_port u_ila_0/probe48 [get_nets [list network_stack_inst/ip_merger/S00_AXIS_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe49]
set_property port_width 1 [get_debug_ports u_ila_0/probe49]
connect_debug_port u_ila_0/probe49 [get_nets [list network_stack_inst/mac_merger/S00_AXIS_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe50]
set_property port_width 1 [get_debug_ports u_ila_0/probe50]
connect_debug_port u_ila_0/probe50 [get_nets [list network_stack_inst/ip_merger/S00_AXIS_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe51]
set_property port_width 1 [get_debug_ports u_ila_0/probe51]
connect_debug_port u_ila_0/probe51 [get_nets [list network_stack_inst/mac_merger/S00_AXIS_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe52]
set_property port_width 1 [get_debug_ports u_ila_0/probe52]
connect_debug_port u_ila_0/probe52 [get_nets [list network_stack_inst/mac_merger/S01_AXIS_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe53]
set_property port_width 1 [get_debug_ports u_ila_0/probe53]
connect_debug_port u_ila_0/probe53 [get_nets [list network_stack_inst/ip_merger/S01_AXIS_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe54]
set_property port_width 1 [get_debug_ports u_ila_0/probe54]
connect_debug_port u_ila_0/probe54 [get_nets [list network_stack_inst/mac_merger/S01_AXIS_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe55]
set_property port_width 1 [get_debug_ports u_ila_0/probe55]
connect_debug_port u_ila_0/probe55 [get_nets [list network_stack_inst/ip_merger/S01_AXIS_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe56]
set_property port_width 1 [get_debug_ports u_ila_0/probe56]
connect_debug_port u_ila_0/probe56 [get_nets [list network_stack_inst/mac_merger/S01_AXIS_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe57]
set_property port_width 1 [get_debug_ports u_ila_0/probe57]
connect_debug_port u_ila_0/probe57 [get_nets [list network_stack_inst/ip_merger/S01_AXIS_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe58]
set_property port_width 1 [get_debug_ports u_ila_0/probe58]
connect_debug_port u_ila_0/probe58 [get_nets [list network_stack_inst/ip_merger/S02_AXIS_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe59]
set_property port_width 1 [get_debug_ports u_ila_0/probe59]
connect_debug_port u_ila_0/probe59 [get_nets [list network_stack_inst/ip_merger/S02_AXIS_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe60]
set_property port_width 1 [get_debug_ports u_ila_0/probe60]
connect_debug_port u_ila_0/probe60 [get_nets [list network_stack_inst/ip_merger/S02_AXIS_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe61]
set_property port_width 1 [get_debug_ports u_ila_0/probe61]
connect_debug_port u_ila_0/probe61 [get_nets [list network_stack_inst/ip_handler_inst/s_axis_raw_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe62]
set_property port_width 1 [get_debug_ports u_ila_0/probe62]
connect_debug_port u_ila_0/probe62 [get_nets [list network_stack_inst/ip_handler_inst/s_axis_raw_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe63]
set_property port_width 1 [get_debug_ports u_ila_0/probe63]
connect_debug_port u_ila_0/probe63 [get_nets [list myEchoServer/s_axis_tx_status_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe64]
set_property port_width 1 [get_debug_ports u_ila_0/probe64]
connect_debug_port u_ila_0/probe64 [get_nets [list myEchoServer/s_axis_tx_status_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe65]
set_property port_width 1 [get_debug_ports u_ila_0/probe65]
connect_debug_port u_ila_0/probe65 [get_nets [list {network_stack_inst/toe_inst/inst/toe_U/toe_tasi_pkg_pusher_U0/tasi_pushMeta_drop[0]_i_1_n_0}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe66]
set_property port_width 1 [get_debug_ports u_ila_0/probe66]
connect_debug_port u_ila_0/probe66 [get_nets [list u_NIU/niu_single_inst/xgmac2rx_axis_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe67]
set_property port_width 1 [get_debug_ports u_ila_0/probe67]
connect_debug_port u_ila_0/probe67 [get_nets [list u_NIU/niu_single_inst/xgmac2rx_axis_tuser]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe68]
set_property port_width 1 [get_debug_ports u_ila_0/probe68]
connect_debug_port u_ila_0/probe68 [get_nets [list u_NIU/niu_single_inst/xgmac2rx_axis_tvalid]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets axi_clk]
