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


# Create port_slicer
cell pavel-demin:user:port_slicer slice_0 {
  DIN_WIDTH 32 DIN_FROM 9 DIN_TO 0
} {
  din cfg_0/cfg_data
  dout adc_cfg_o
}

# ADC SPI

# Create axi_axis_writer
cell pavel-demin:user:axi_axis_writer writer_0 {
  AXI_DATA_WIDTH 32
} {
  aclk pll_0/clk_out1
  aresetn rst_0/peripheral_aresetn
}

# Create axis_data_fifo
cell xilinx.com:ip:axis_data_fifo fifo_0 {
  TDATA_NUM_BYTES.VALUE_SRC USER
  TDATA_NUM_BYTES 4
  FIFO_DEPTH 1024
  HAS_WR_DATA_COUNT true
} {
  S_AXIS writer_0/M_AXIS
  s_axis_aclk pll_0/clk_out1
  s_axis_aresetn rst_0/peripheral_aresetn
}

# Create axis_spi
cell pavel-demin:user:axis_spi spi_0 {
  SPI_DATA_WIDTH 24
} {
  S_AXIS fifo_0/M_AXIS
  spi_data adc_spi_o
  aclk pll_0/clk_out1
  aresetn rst_0/peripheral_aresetn
}

# ADC

# Create clk_wiz
cell xilinx.com:ip:clk_wiz pll_1 {
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
}

# Create util_ds_buf
cell xilinx.com:ip:util_ds_buf obufds_0 {
  C_BUF_TYPE OBUFDS
} {
  OBUF_IN pll_1/clk_out1
  OBUF_DS_N adc_clk_n_o
  OBUF_DS_P adc_clk_p_o
}

# Create axis_zmod_adc
cell pavel-demin:user:axis_zmod_adc adc_0 {
  ADC_DATA_WIDTH 14
} {
  aclk pll_0/clk_out1
  adc_data adc_data_i
}

# Create axis_broadcaster
cell xilinx.com:ip:axis_broadcaster bcast_0 {
  S_TDATA_NUM_BYTES.VALUE_SRC USER
  M_TDATA_NUM_BYTES.VALUE_SRC USER
  S_TDATA_NUM_BYTES 4
  M_TDATA_NUM_BYTES 2
  M00_TDATA_REMAP {tdata[15:0]}
  M01_TDATA_REMAP {tdata[31:16]}
} {
  S_AXIS adc_0/M_AXIS
  aclk pll_0/clk_out1
  aresetn rst_0/peripheral_aresetn
}

addr 0x80001000 4K cfg_0/S_AXI /ps_0/M_AXI_HPM0_LPD
addr 0x80002000 4K writer_0/S_AXI /ps_0/M_AXI_HPM0_LPD
