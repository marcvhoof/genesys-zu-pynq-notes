source projects/packetizer_test/block_design.tcl

# Create clk_wiz
cell xilinx.com:ip:clk_wiz:5.1 pll_0 {
  PRIMITIVE PLL
  PRIM_IN_FREQ.VALUE_SRC USER
  PRIM_IN_FREQ 125.0
  CONFIG.CLKOUT1_USED true
  CONFIG.CLKOUT2_USED true
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 125.0
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ 250.0
} {
  clk_in1 adc_0/adc_clk
}

# Create dds_compiler
cell xilinx.com:ip:dds_compiler:6.0 dds_0 {
  DDS_Clock_Rate 125
  Spurious_Free_Dynamic_Range 80
  Frequency_Resolution 0.5
  Output_Selection Sine
  Has_Phase_Out false
  Output_Frequency1 0.9765625  
} {
  aclk pll_0/clk_out1
}

# Create axis_red_pitaya_dac
cell pavel-demin:user:axis_red_pitaya_dac:1.0 dac_0 {} {
  aclk pll_0/clk_out1
  ddr_clk pll_0/clk_out2
  locked pll_0/locked
  S_AXIS dds_0/M_AXIS_DATA
  dac_clk dac_clk_o
  dac_rst dac_rst_o
  dac_sel dac_sel_o
  dac_wrt dac_wrt_o
  dac_dat dac_dat_o
}
