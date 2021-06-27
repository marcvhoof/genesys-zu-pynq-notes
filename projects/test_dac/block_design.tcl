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
cell pavel-demin:user:port_slicer slice_1 {
  DIN_WIDTH 32 DIN_FROM 19 DIN_TO 16
} {
  din cfg_0/cfg_data
  dout dac_cfg_o
}

# DAC SPI

# Create axi_axis_writer
cell pavel-demin:user:axi_axis_writer writer_1 {
  AXI_DATA_WIDTH 32
} {
  aclk pll_0/clk_out1
  aresetn rst_0/peripheral_aresetn
}

# Create axis_data_fifo
cell xilinx.com:ip:axis_data_fifo fifo_1 {
  TDATA_NUM_BYTES.VALUE_SRC USER
  TDATA_NUM_BYTES 4
  FIFO_DEPTH 1024
  HAS_WR_DATA_COUNT true
} {
  S_AXIS writer_1/M_AXIS
  s_axis_aclk pll_0/clk_out1
  s_axis_aresetn rst_0/peripheral_aresetn
}

# Create axis_spi
cell pavel-demin:user:axis_spi spi_1 {
  SPI_DATA_WIDTH 16
} {
  S_AXIS fifo_1/M_AXIS
  spi_data dac_spi_o
  aclk pll_0/clk_out1
  aresetn rst_0/peripheral_aresetn
}

# DAC

# Create dds_compiler
cell xilinx.com:ip:dds_compiler dds_0 {
  DDS_CLOCK_RATE 100
  SPURIOUS_FREE_DYNAMIC_RANGE 78
  NOISE_SHAPING Taylor_Series_Corrected
  FREQUENCY_RESOLUTION 0.1
  HAS_PHASE_OUT false
  OUTPUT_WIDTH 14
  OUTPUT_SELECTION Sine
  OUTPUT_FREQUENCY1 0.1
} {
  aclk pll_0/clk_out1
}

# Create dds_compiler
cell xilinx.com:ip:dds_compiler dds_1 {
  DDS_CLOCK_RATE 100
  SPURIOUS_FREE_DYNAMIC_RANGE 78
  NOISE_SHAPING Taylor_Series_Corrected
  FREQUENCY_RESOLUTION 0.1
  HAS_PHASE_OUT false
  OUTPUT_WIDTH 14
  OUTPUT_SELECTION Sine
  OUTPUT_FREQUENCY1 0.2
} {
  aclk pll_0/clk_out1
}

# Create axis_combiner
cell  xilinx.com:ip:axis_combiner comb_0 {
  TDATA_NUM_BYTES.VALUE_SRC USER
  TDATA_NUM_BYTES 2
  NUM_SI 2
} {
  S00_AXIS dds_0/M_AXIS_DATA
  S01_AXIS dds_1/M_AXIS_DATA
  aclk pll_0/clk_out1
  aresetn rst_0/peripheral_aresetn
}

# Create axis_zmod_dac
cell pavel-demin:user:axis_zmod_dac dac_0 {
  DAC_DATA_WIDTH 14
} {
  aclk pll_0/clk_out1
  locked pll_0/locked
  S_AXIS comb_0//M_AXIS
  dac_clk dac_clk_o
  dac_data dac_data_o
}

addr 0x80001000 4K cfg_0/S_AXI /ps_0/M_AXI_HPM0_LPD
addr 0x80002000 4K writer_1/S_AXI /ps_0/M_AXI_HPM0_LPD
