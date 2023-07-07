########################
# BASICS               #
########################
# Create processing_system8 (MPSOC) and Genesys ZU board specifics
source cfg/essentials.tcl

# Create clk_wiz
cell xilinx.com:ip:clk_wiz pll_0 {
  PRIMITIVE PLL
  PRIM_IN_FREQ.VALUE_SRC USER
  PRIM_IN_FREQ 100.0
  CLKOUT1_USED true
  CLKOUT1_REQUESTED_OUT_FREQ 100.0
  JITTER_SEL Min_O_Jitter
  JITTER_OPTIONS PS
  CLKIN1_UI_JITTER 600
  USE_RESET false
} {
  clk_in1 ps_0/pl_clk0
  clk_out1 ps_0/maxihpm0_lpd_aclk
  clk_out1 ps_0/saxihpc0_fpd_aclk
}

# Create xlconstant
cell xilinx.com:ip:xlconstant const_0

# Create proc_sys_reset
cell xilinx.com:ip:proc_sys_reset rst_0 {} {
  ext_reset_in const_0/dout
}

# CFG
# Create axi_cfg_register
cell pavel-demin:user:axi_cfg_register cfg_0 {
  CFG_DATA_WIDTH 32
  AXI_ADDR_WIDTH 32
  AXI_DATA_WIDTH 32
}

# Create all required interconnections
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {/pll_0/clk_out1 (100 MHz)} Clk_xbar {Auto} Master {/ps_0/M_AXI_HPM0_LPD} Slave {cfg_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins cfg_0/S_AXI]

########################
# APPLICATION SPECIFIC #
########################

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
