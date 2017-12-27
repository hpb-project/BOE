set proj_name       "boe_vc709"
set repo_dir        ../BOE
set root_dir        [pwd]
set proj_dir        $root_dir/$proj_name
set src_dir         $repo_dir/rtl
set ip_dir          $repo_dir/ip
set constraints_dir $repo_dir/constraints

# if { [file isdirectory $root_dir/build/ipRepository] } {
# 	set lib_dir "$root_dir/build/ipRepository"
# } else {
# 	puts "ipRepository directory could not be found."
# 	exit 1
# }                  

# Create project
create_project $proj_name $proj_dir

# Set project properties
set obj [get_projects $proj_name]
set_property part xc7vx690tffg1761-2 $obj
set_property "target_language" "Verilog" $obj

# set_property IP_REPO_PATHS $lib_dir [current_fileset]
# update_ip_catalog

# Add sources
add_files $src_dir/TOP
add_files $src_dir/NIU
set_property top NIU_test [current_fileset]

add_files -fileset constrs_1 $constraints_dir/NIU_test_vc709.xdc


#create ips
create_ip -name ten_gig_eth_pcs_pma -vendor xilinx.com -library ip -version 6.0 -module_name ten_gig_eth_pcs_pma_ip
set_property -dict [list CONFIG.MDIO_Management {false} CONFIG.base_kr {BASE-R} CONFIG.baser32 {64bit}] [get_ips ten_gig_eth_pcs_pma_ip]
generate_target {instantiation_template} [get_files $proj_dir/$proj_name.srcs/sources_1/ip/ten_gig_eth_pcs_pma_ip/ten_gig_eth_pcs_pma_ip.xci]
update_compile_order -fileset sources_1

create_ip -name ten_gig_eth_mac -vendor xilinx.com -library ip -version 15.1 -module_name ten_gig_eth_mac_ip
set_property -dict [list CONFIG.Management_Interface {false} CONFIG.Statistics_Gathering {false}] [get_ips ten_gig_eth_mac_ip]
generate_target {instantiation_template} [get_files $proj_dir/$proj_name.srcs/sources_1/ip/ten_gig_eth_mac_ip/ten_gig_eth_mac_ip.xci]
update_compile_order -fileset sources_1


create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.1 -module_name axis_sync_fifo
set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {8} CONFIG.TUSER_WIDTH {0} CONFIG.Enable_TLAST {true} CONFIG.HAS_TKEEP {true} CONFIG.Enable_Data_Counts_axis {true} CONFIG.Reset_Type {Asynchronous_Reset} CONFIG.Full_Flags_Reset_Value {1} CONFIG.TSTRB_WIDTH {8} CONFIG.TKEEP_WIDTH {8} CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_wach {15} CONFIG.Empty_Threshold_Assert_Value_wach {14} CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_wrch {15} CONFIG.Empty_Threshold_Assert_Value_wrch {14} CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_rach {15} CONFIG.Empty_Threshold_Assert_Value_rach {14}] [get_ips axis_sync_fifo]
generate_target {instantiation_template} [get_files $proj_dir/$proj_name.srcs/sources_1/ip/axis_sync_fifo/axis_sync_fifo.xci]
update_compile_order -fileset sources_1


create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.1 -module_name cmd_fifo_xgemac_rxif
set_property -dict [list CONFIG.Input_Data_Width {16} CONFIG.Output_Data_Width {16} CONFIG.Reset_Type {Asynchronous_Reset} CONFIG.Full_Flags_Reset_Value {1}] [get_ips cmd_fifo_xgemac_rxif]
generate_target {instantiation_template} [get_files $proj_dir/$proj_name.srcs/sources_1/ip/cmd_fifo_xgemac_rxif/cmd_fifo_xgemac_rxif.xci]
update_compile_order -fileset sources_1

create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.1 -module_name cmd_fifo_xgemac_txif
set_property -dict [list CONFIG.Input_Data_Width {1} CONFIG.Output_Data_Width {1} CONFIG.Reset_Type {Asynchronous_Reset} CONFIG.Full_Flags_Reset_Value {1}] [get_ips cmd_fifo_xgemac_txif]
generate_target {instantiation_template} [get_files $proj_dir/$proj_name.srcs/sources_1/ip/cmd_fifo_xgemac_txif/cmd_fifo_xgemac_txif.xci]
update_compile_order -fileset sources_1


create_ip -name axis_data_fifo -vendor xilinx.com -library ip -version 1.1 -module_name axis_pkt_fifo
set_property -dict [list CONFIG.TDATA_NUM_BYTES {8} CONFIG.FIFO_MODE {2} CONFIG.HAS_TKEEP {1} CONFIG.HAS_TLAST {1}] [get_ips axis_pkt_fifo]
generate_target {instantiation_template} [get_files $proj_dir/$proj_name.srcs/sources_1/ip/axis_pkt_fifo/axis_pkt_fifo.xci]
update_compile_order -fileset sources_1




create_ip -name axis_register_slice -vendor xilinx.com -library ip -version 1.1 -module_name axis_register_slice_64
set_property -dict [list CONFIG.TDATA_NUM_BYTES {8} CONFIG.HAS_TKEEP {1} CONFIG.HAS_TLAST {1}] [get_ips axis_register_slice_64]
generate_target {instantiation_template} [get_files $proj_dir/$proj_name.srcs/sources_1/ip/axis_register_slice_64/axis_register_slice_64.xci]
update_compile_order -fileset sources_1


start_gui
