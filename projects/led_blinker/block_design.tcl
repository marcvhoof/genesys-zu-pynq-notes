# Create processing_system8 (MPSOC) and Genesys ZU board specifics
source cfg/essentials.tcl

#connect clock
connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins ps_0/maxihpm0_lpd_aclk] [get_bd_pins ps_0/pl_clk0] [get_bd_pins ps_0/saxihpc0_fpd_aclk]

# Create xlconstant
cell xilinx.com:ip:xlconstant const_0

# Create proc_sys_reset
cell xilinx.com:ip:proc_sys_reset rst_0 {} {
  ext_reset_in const_0/dout
  aux_reset_in ps_0/pl_resetn0
  slowest_sync_clk ps_0/pl_clk0
}

# Create button
# Create axis_gpio_reader
#cell pavel-demin:user:axis_gpio_reader gpio_0 {
#  AXIS_TDATA_WIDTH 5
#} {
#  gpio_data pl_buttons
#  aclk ps_0/pl_clk0
#}

# LED
# Create c_counter_binary
cell xilinx.com:ip:c_counter_binary cntr_0 {
  Output_Width 32
} {
  CLK ps_0/pl_clk0
}

# Create xlslice
cell xilinx.com:ip:xlslice slice_0 {
  DIN_WIDTH 32 DIN_FROM 26 DIN_TO 26 DOUT_WIDTH 1
} {
  Din cntr_0/Q
  Dout led_o
}

#The DNA reader has not been ported yet to DNA_PORTE2 (https://www.xilinx.com/support/documentation/user_guides/ug570-ultrascale-configuration.pdf).
#
