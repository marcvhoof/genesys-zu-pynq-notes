########################
# BASICS #
########################
# Create processing_system8 (MPSOC) and Genesys ZU board specifics
source projects/IOstreamerDPU/essentials_adapted.tcl

# Create ports
set adc_cfg_o [ create_bd_port -dir O -from 9 -to 0 adc_cfg_o ]
set adc_clk_n_o [ create_bd_port -dir O -from 0 -to 0 -type clk adc_clk_n_o ]
set adc_clk_p_o [ create_bd_port -dir O -from 0 -to 0 -type clk adc_clk_p_o ]
set adc_data_i [ create_bd_port -dir I -from 13 -to 0 adc_data_i ]
set adc_dco_i [ create_bd_port -dir I adc_dco_i ]
set adc_spi_o [ create_bd_port -dir O -from 2 -to 0 adc_spi_o ]
set dac_cfg_o [ create_bd_port -dir O -from 3 -to 0 dac_cfg_o ]
set dac_clk_o [ create_bd_port -dir O dac_clk_o ]
set dac_data_o [ create_bd_port -dir O -from 13 -to 0 dac_data_o ]
set dac_spi_o [ create_bd_port -dir O -from 2 -to 0 dac_spi_o ]

# ADD and connect DPU Block design
#source projects/IOstreamerDPU/DPU_block.tcl

# ADD and connect IOStreamer Block design
#source projects/IOstreamerDPU/IOSTREAMER.tcl

proc COMMENTED_OUT {} {

# Create interface connections
connect_bd_intf_net -intf_net DPU_block_0_M00_AXI [get_bd_intf_pins DPU_block_0/M00_AXI] [get_bd_intf_pins ps_0/S_AXI_HP0_FPD]
connect_bd_intf_net -intf_net DPU_block_0_M00_AXI1 [get_bd_intf_pins DPU_block_0/M00_AXI1] [get_bd_intf_pins ps_0/S_AXI_HPC0_FPD]
connect_bd_intf_net -intf_net DPU_block_0_M00_AXI2 [get_bd_intf_pins DPU_block_0/M00_AXI2] [get_bd_intf_pins ps_0/S_AXI_HP3_FPD]
connect_bd_intf_net -intf_net DPU_block_0_M00_AXI3 [get_bd_intf_pins DPU_block_0/M00_AXI3] [get_bd_intf_pins ps_0/S_AXI_HP1_FPD]
connect_bd_intf_net -intf_net S00_AXI1_1 [get_bd_intf_pins DPU_block_0/S00_AXI1] [get_bd_intf_pins ps_0/M_AXI_HPM0_FPD]
connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins DPU_block_0/S00_AXI] [get_bd_intf_pins ps_0/M_AXI_HPM0_LPD]

connect_bd_intf_net -intf_net IOSTREAMER_M00_AXI [get_bd_intf_pins IOSTREAMER/M00_AXI] [get_bd_intf_pins ps_0/S_AXI_HP2_FPD]
connect_bd_intf_net -intf_net IOSTREAMER_M00_AXI1 [get_bd_intf_pins IOSTREAMER/M00_AXI1] [get_bd_intf_pins ps_0/S_AXI_LPD]
connect_bd_intf_net -intf_net IOSTREAMER_M00_AXI2 [get_bd_intf_pins IOSTREAMER/M00_AXI2] [get_bd_intf_pins ps_0/S_AXI_HPC1_FPD]
connect_bd_intf_net -intf_net S00_AXI_2 [get_bd_intf_pins IOSTREAMER/S00_AXI] [get_bd_intf_pins ps_0/M_AXI_HPM1_FPD]

# Create port connections
connect_bd_net -net DPU_block_0_clk_out3 [get_bd_pins DPU_block_0/clk_out3] [get_bd_pins ps_0/maxihpm0_lpd_aclk]
connect_bd_net -net DPU_block_0_irq [get_bd_pins DPU_block_0/irq] [get_bd_pins ps_0/pl_ps_irq0]
connect_bd_net -net IOSTREAMER_clk_out1 [get_bd_pins IOSTREAMER/clk_out1] [get_bd_pins ps_0/maxihpm1_fpd_aclk] [get_bd_pins ps_0/saxi_lpd_aclk] [get_bd_pins ps_0/saxihp2_fpd_aclk] [get_bd_pins ps_0/saxihpc1_fpd_aclk]
connect_bd_net -net Net [get_bd_pins DPU_block_0/clk_out2] [get_bd_pins ps_0/maxihpm0_fpd_aclk] [get_bd_pins ps_0/saxihp0_fpd_aclk] [get_bd_pins ps_0/saxihp1_fpd_aclk] [get_bd_pins ps_0/saxihp3_fpd_aclk] [get_bd_pins ps_0/saxihpc0_fpd_aclk]
connect_bd_net -net adc_data_i_1 [get_bd_ports adc_data_i] [get_bd_pins IOSTREAMER/adc_data_i]
connect_bd_net -net adc_dco_i_1 [get_bd_ports adc_dco_i] [get_bd_pins IOSTREAMER/adc_dco_i]
connect_bd_net -net dac_0_dac_clk [get_bd_ports dac_clk_o] [get_bd_pins IOSTREAMER/dac_clk_o]
connect_bd_net -net dac_0_dac_data [get_bd_ports dac_data_o] [get_bd_pins IOSTREAMER/dac_data_o]
connect_bd_net -net obufds_0_OBUF_DS_N [get_bd_ports adc_clk_n_o] [get_bd_pins IOSTREAMER/adc_clk_n_o]
connect_bd_net -net obufds_0_OBUF_DS_P [get_bd_ports adc_clk_p_o] [get_bd_pins IOSTREAMER/adc_clk_p_o]
connect_bd_net -net ps_0_pl_clk0 [get_bd_pins DPU_block_0/clk_in1] [get_bd_pins IOSTREAMER/clk_in1] [get_bd_pins ps_0/pl_clk0]
connect_bd_net -net ps_0_pl_resetn0 [get_bd_pins DPU_block_0/resetn] [get_bd_pins IOSTREAMER/ext_reset_in] [get_bd_pins ps_0/pl_resetn0]
connect_bd_net -net slice_0_dout [get_bd_ports adc_cfg_o] [get_bd_pins IOSTREAMER/adc_cfg_o]
connect_bd_net -net slice_1_dout1 [get_bd_ports dac_cfg_o] [get_bd_pins IOSTREAMER/dac_cfg_o]
connect_bd_net -net spi_0_spi_data [get_bd_ports adc_spi_o] [get_bd_pins IOSTREAMER/adc_spi_o]
connect_bd_net -net spi_1_spi_data [get_bd_ports dac_spi_o] [get_bd_pins IOSTREAMER/dac_spi_o]

# Create address segments
#DPU components
assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_GP0] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_DDR_LOW] -force
assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_GP0] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_QSPI] -force
assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_GP0] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_LPS_OCM] -force

assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_HP0] [get_bd_addr_segs ps_0/SAXIGP2/HP0_DDR_LOW] -force
assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_HP0] [get_bd_addr_segs ps_0/SAXIGP2/HP0_QSPI] -force
assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_HP0] [get_bd_addr_segs ps_0/SAXIGP2/HP0_LPS_OCM] -force

assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_HP2] [get_bd_addr_segs ps_0/SAXIGP3/HP1_DDR_LOW] -force
assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_HP2] [get_bd_addr_segs ps_0/SAXIGP3/HP1_QSPI] -force
assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_HP2] [get_bd_addr_segs ps_0/SAXIGP3/HP1_LPS_OCM] -force

assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DPU_block_0/axi_vip_0/Master_AXI] [get_bd_addr_segs ps_0/SAXIGP5/HP3_DDR_LOW] -force
assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces DPU_block_0/axi_vip_0/Master_AXI] [get_bd_addr_segs ps_0/SAXIGP5/HP3_QSPI] -force
assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces DPU_block_0/axi_vip_0/Master_AXI] [get_bd_addr_segs ps_0/SAXIGP5/HP3_LPS_OCM] -force

assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DPU_block_0/axi_vip_1/Master_AXI] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_DDR_LOW] -force
assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces DPU_block_0/axi_vip_1/Master_AXI] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_QSPI] -force
assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces DPU_block_0/axi_vip_1/Master_AXI] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_LPS_OCM] -force
#IOSTREAMER components
assign_bd_address -offset 0x000800000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs ps_0/SAXIGP6/LPD_DDR_HIGH] -force
assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs ps_0/SAXIGP6/LPD_DDR_LOW] -force
assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs ps_0/SAXIGP6/LPD_LPS_OCM] -force

assign_bd_address -offset 0x000800000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_S2MM] [get_bd_addr_segs ps_0/SAXIGP4/HP2_DDR_HIGH] -force
assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_S2MM] [get_bd_addr_segs ps_0/SAXIGP4/HP2_DDR_LOW] -force
assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs ps_0/SAXIGP4/HP2_LPS_OCM] -force

assign_bd_address -offset 0x000800000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_SG] [get_bd_addr_segs ps_0/SAXIGP1/HPC1_DDR_HIGH] -force
assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_SG] [get_bd_addr_segs ps_0/SAXIGP1/HPC1_DDR_LOW] -force
assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_SG] [get_bd_addr_segs ps_0/SAXIGP1/HPC1_LPS_OCM] -force

assign_bd_address -offset 0x80010000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs DPU_block_0/DPUCZDX8G_1/S_AXI_CONTROL/reg0] -force

assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs DPU_block_0/axi_intc_0/S_AXI/Reg] -force

assign_bd_address -offset 0xB0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs IOSTREAMER/axi_mcdma_0/S_AXI_LITE/Reg] -force

assign_bd_address -offset 0xB0030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs IOSTREAMER/axis_switch_0/S_AXI_CTRL/Reg] -force

assign_bd_address -offset 0xB0040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs IOSTREAMER/axis_switch_1/S_AXI_CTRL/Reg] -force

assign_bd_address -offset 0xB0050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs IOSTREAMER/axis_switch_3/S_AXI_CTRL/Reg] -force

assign_bd_address -offset 0x000500000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs IOSTREAMER/cfg_0/s_axi/reg0] -force

assign_bd_address -offset 0x004800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs IOSTREAMER/cfg_1/s_axi/reg0] -force

assign_bd_address -offset 0x004900000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs IOSTREAMER/sts_0/s_axi/reg0] -force

assign_bd_address -offset 0xB0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs IOSTREAMER/writer_0/s_axi/reg0] -force

assign_bd_address -offset 0xB0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs IOSTREAMER/writer_1/s_axi/reg0] -force

# Exclude Address Segments
exclude_bd_addr_seg -offset 0x000800000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_GP0] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_DDR_HIGH]
exclude_bd_addr_seg -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_GP0] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_PCIE_LOW]
exclude_bd_addr_seg -offset 0x000800000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_HP0] [get_bd_addr_segs ps_0/SAXIGP2/HP0_DDR_HIGH]
exclude_bd_addr_seg -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_HP0] [get_bd_addr_segs ps_0/SAXIGP2/HP0_PCIE_LOW]
exclude_bd_addr_seg -offset 0x000800000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_HP2] [get_bd_addr_segs ps_0/SAXIGP3/HP1_DDR_HIGH]
exclude_bd_addr_seg -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces DPU_block_0/DPUCZDX8G_1/M_AXI_HP2] [get_bd_addr_segs ps_0/SAXIGP3/HP1_PCIE_LOW]
exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces DPU_block_0/axi_vip_0/Master_AXI] [get_bd_addr_segs ps_0/SAXIGP5/HP3_DDR_HIGH]
exclude_bd_addr_seg -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces DPU_block_0/axi_vip_0/Master_AXI] [get_bd_addr_segs ps_0/SAXIGP5/HP3_PCIE_LOW]
exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces DPU_block_0/axi_vip_1/Master_AXI] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_DDR_HIGH]
exclude_bd_addr_seg -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces DPU_block_0/axi_vip_1/Master_AXI] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_PCIE_LOW]

exclude_bd_addr_seg -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs ps_0/SAXIGP6/LPD_PCIE_LOW]
exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs ps_0/SAXIGP6/LPD_QSPI]
exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_S2MM] [get_bd_addr_segs ps_0/SAXIGP4/HP2_PCIE_LOW]
exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_S2MM] [get_bd_addr_segs ps_0/SAXIGP4/HP2_QSPI]
exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_SG] [get_bd_addr_segs ps_0/SAXIGP1/HPC1_PCIE_LOW]
exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces IOSTREAMER/axi_mcdma_0/Data_SG] [get_bd_addr_segs ps_0/SAXIGP1/HPC1_QSPI]
}
