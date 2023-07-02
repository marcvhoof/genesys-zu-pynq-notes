
################################################################
# This is a generated script based on design: IOSTREAMER
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source IOSTREAMER_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu3eg-sfvc784-1-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name IOSTREAMER

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
pavel-demin:user:axis_zmod_adc:1.0\
xilinx.com:ip:axi_mcdma:1.1\
xilinx.com:ip:smartconnect:1.0\
pavel-demin:user:axis_accumulator:1.0\
xilinx.com:ip:axis_broadcaster:1.1\
pavel-demin:user:axis_counter:1.0\
pavel-demin:user:axis_multiport_acc:1.0\
xilinx.com:ip:axis_subset_converter:1.1\
xilinx.com:ip:axis_switch:1.1\
xilinx.com:ip:c_addsub:12.0\
pavel-demin:user:axi_cfg_register:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:axis_dwidth_converter:1.1\
pavel-demin:user:axis_zmod_dac:1.0\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:util_ds_buf:2.2\
pavel-demin:user:axis_packetizer:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
pavel-demin:user:port_slicer:1.0\
xilinx.com:ip:xlslice:1.0\
pavel-demin:user:axis_spi:1.0\
pavel-demin:user:axi_sts_register:1.0\
xilinx.com:ip:util_vector_logic:2.0\
pavel-demin:user:axi_axis_writer:1.0\
xilinx.com:ip:xlconstant:1.1\
pavel-demin:user:axis_zeroer:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set M00_AXI [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {49} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {WRITE_ONLY} \
   ] $M00_AXI

  set M00_AXI1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {49} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_BRESP {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_WSTRB {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $M00_AXI1

  set M00_AXI2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI2 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {49} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $M00_AXI2

  set S00_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {16} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {8} \
   CONFIG.NUM_READ_THREADS {4} \
   CONFIG.NUM_WRITE_OUTSTANDING {8} \
   CONFIG.NUM_WRITE_THREADS {4} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S00_AXI


  # Create ports
  set adc_cfg_o [ create_bd_port -dir O -from 9 -to 0 adc_cfg_o ]
  set adc_clk_n_o [ create_bd_port -dir O -from 0 -to 0 -type clk adc_clk_n_o ]
  set adc_clk_p_o [ create_bd_port -dir O -from 0 -to 0 -type clk adc_clk_p_o ]
  set adc_data_i [ create_bd_port -dir I -from 13 -to 0 adc_data_i ]
  set adc_dco_i [ create_bd_port -dir I adc_dco_i ]
  set adc_spi_o [ create_bd_port -dir O -from 2 -to 0 adc_spi_o ]
  set clk_in1 [ create_bd_port -dir I -type clk clk_in1 ]
  set clk_out1 [ create_bd_port -dir O -type clk clk_out1 ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI:M00_AXI1:S00_AXI:M00_AXI2} \
 ] $clk_out1
  set_property CONFIG.ASSOCIATED_BUSIF.VALUE_SRC DEFAULT $clk_out1

  set dac_cfg_o [ create_bd_port -dir O -from 3 -to 0 dac_cfg_o ]
  set dac_clk_o [ create_bd_port -dir O -type clk dac_clk_o ]
  set dac_data_o [ create_bd_port -dir O -from 13 -to 0 dac_data_o ]
  set dac_spi_o [ create_bd_port -dir O -from 2 -to 0 dac_spi_o ]
  set ext_reset_in [ create_bd_port -dir I -type rst ext_reset_in ]

  # Create instance: adc_0, and set properties
  set adc_0 [ create_bd_cell -type ip -vlnv pavel-demin:user:axis_zmod_adc:1.0 adc_0 ]
  set_property -dict [ list \
   CONFIG.ADC_DATA_WIDTH {14} \
 ] $adc_0

  # Create instance: axi_mcdma_0, and set properties
  set axi_mcdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mcdma:1.1 axi_mcdma_0 ]
  set_property -dict [ list \
   CONFIG.c_addr_width {64} \
   CONFIG.c_group1_mm2s {0000000000001111} \
   CONFIG.c_group1_s2mm {0000000000000001} \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
   CONFIG.c_m_axi_mm2s_data_width {64} \
   CONFIG.c_m_axis_mm2s_tdata_width {64} \
   CONFIG.c_mm2s_burst_size {64} \
   CONFIG.c_mm2s_scheduler {2} \
   CONFIG.c_num_mm2s_channels {4} \
   CONFIG.c_num_s2mm_channels {1} \
   CONFIG.c_prmry_is_aclk_async {0} \
   CONFIG.c_s2mm_burst_size {64} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $axi_mcdma_0

  # Create instance: axi_smc_1, and set properties
  set axi_smc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc_1 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {1} \
 ] $axi_smc_1

  # Create instance: axi_smc_2, and set properties
  set axi_smc_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc_2 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {1} \
 ] $axi_smc_2

  # Create instance: axi_smc_3, and set properties
  set axi_smc_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc_3 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {1} \
 ] $axi_smc_3

  # Create instance: axis_accumulator_0, and set properties
  set axis_accumulator_0 [ create_bd_cell -type ip -vlnv pavel-demin:user:axis_accumulator:1.0 axis_accumulator_0 ]
  set_property -dict [ list \
   CONFIG.AXIS_TDATA_SIGNED {TRUE} \
   CONFIG.CNTR_WIDTH {32} \
   CONFIG.CONTINUOUS {FALSE} \
   CONFIG.M_AXIS_TDATA_WIDTH {64} \
 ] $axis_accumulator_0

  # Create instance: axis_accumulator_1, and set properties
  set axis_accumulator_1 [ create_bd_cell -type ip -vlnv pavel-demin:user:axis_accumulator:1.0 axis_accumulator_1 ]
  set_property -dict [ list \
   CONFIG.AXIS_TDATA_SIGNED {TRUE} \
   CONFIG.CNTR_WIDTH {32} \
   CONFIG.CONTINUOUS {FALSE} \
   CONFIG.M_AXIS_TDATA_WIDTH {64} \
 ] $axis_accumulator_1

  # Create instance: axis_broadcaster_2, and set properties
  set axis_broadcaster_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_2 ]
  set_property -dict [ list \
   CONFIG.M00_TDATA_REMAP {tdata[31:0]} \
   CONFIG.M01_TDATA_REMAP {tdata[31:0]} \
   CONFIG.M02_TDATA_REMAP {tdata[31:0]} \
   CONFIG.M03_TDATA_REMAP {tdata[31:0]} \
   CONFIG.NUM_MI {3} \
 ] $axis_broadcaster_2

  # Create instance: axis_counter_0, and set properties
  set axis_counter_0 [ create_bd_cell -type ip -vlnv pavel-demin:user:axis_counter:1.0 axis_counter_0 ]

  # Create instance: axis_counter_1, and set properties
  set axis_counter_1 [ create_bd_cell -type ip -vlnv pavel-demin:user:axis_counter:1.0 axis_counter_1 ]

  # Create instance: axis_counter_2, and set properties
  set axis_counter_2 [ create_bd_cell -type ip -vlnv pavel-demin:user:axis_counter:1.0 axis_counter_2 ]

  # Create instance: axis_multiport_acc_0, and set properties
  set axis_multiport_acc_0 [ create_bd_cell -type ip -vlnv pavel-demin:user:axis_multiport_acc:1.0 axis_multiport_acc_0 ]
  set_property -dict [ list \
   CONFIG.AXIS_TDATA_SIGNED {TRUE} \
 ] $axis_multiport_acc_0

  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [ list \
   CONFIG.M_TDATA_NUM_BYTES {2} \
   CONFIG.TDATA_REMAP {tdata[15:0]} \
   CONFIG.TLAST_REMAP {tlast[0]} \
 ] $axis_subset_converter_0

  # Create instance: axis_subset_converter_1, and set properties
  set axis_subset_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_1 ]
  set_property -dict [ list \
   CONFIG.M_TDATA_NUM_BYTES {2} \
   CONFIG.TDATA_REMAP {tdata[31:16]} \
   CONFIG.TLAST_REMAP {tlast[0]} \
 ] $axis_subset_converter_1

  # Create instance: axis_switch_0, and set properties
  set axis_switch_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_0 ]
  set_property -dict [ list \
   CONFIG.DECODER_REG {1} \
   CONFIG.M01_S00_CONNECTIVITY {1} \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
   CONFIG.ROUTING_MODE {1} \
 ] $axis_switch_0

  # Create instance: axis_switch_1, and set properties
  set axis_switch_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_1 ]
  set_property -dict [ list \
   CONFIG.DECODER_REG {1} \
   CONFIG.M00_S01_CONNECTIVITY {1} \
   CONFIG.M01_S00_CONNECTIVITY {0} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.OUTPUT_REG {1} \
   CONFIG.ROUTING_MODE {1} \
 ] $axis_switch_1

  # Create instance: axis_switch_2, and set properties
  set axis_switch_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_2 ]
  set_property -dict [ list \
   CONFIG.DECODER_REG {1} \
   CONFIG.M00_S01_CONNECTIVITY {1} \
   CONFIG.M01_S00_CONNECTIVITY {1} \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
   CONFIG.OUTPUT_REG {0} \
   CONFIG.ROUTING_MODE {0} \
 ] $axis_switch_2

  # Create instance: axis_switch_3, and set properties
  set axis_switch_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_3 ]
  set_property -dict [ list \
   CONFIG.DECODER_REG {1} \
   CONFIG.NUM_MI {2} \
   CONFIG.OUTPUT_REG {1} \
   CONFIG.ROUTING_MODE {1} \
 ] $axis_switch_3

  # Create instance: c_addsub_0, and set properties
  set c_addsub_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {32} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Constant {false} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {00000000000000000000000000000000} \
   CONFIG.B_Width {32} \
   CONFIG.CE {false} \
   CONFIG.Implementation {DSP48} \
   CONFIG.Latency {1} \
   CONFIG.Out_Width {32} \
 ] $c_addsub_0

  # Create instance: c_addsub_1, and set properties
  set c_addsub_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_1 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {32} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Constant {false} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {00000000000000000000000000000000} \
   CONFIG.B_Width {32} \
   CONFIG.CE {false} \
   CONFIG.Implementation {DSP48} \
   CONFIG.Latency {1} \
   CONFIG.Out_Width {32} \
 ] $c_addsub_1

  # Create instance: c_addsub_2, and set properties
  set c_addsub_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_2 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {32} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Constant {false} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {00000000000000000000000000000000} \
   CONFIG.B_Width {32} \
   CONFIG.CE {false} \
   CONFIG.Implementation {DSP48} \
   CONFIG.Latency {1} \
   CONFIG.Out_Width {32} \
 ] $c_addsub_2

  # Create instance: cfg_0, and set properties
  set cfg_0 [ create_bd_cell -type ip -vlnv pavel-demin:user:axi_cfg_register:1.0 cfg_0 ]
  set_property -dict [ list \
   CONFIG.AXI_ADDR_WIDTH {32} \
   CONFIG.AXI_DATA_WIDTH {32} \
   CONFIG.CFG_DATA_WIDTH {64} \
 ] $cfg_0

  # Create instance: cfg_1, and set properties
  set cfg_1 [ create_bd_cell -type ip -vlnv pavel-demin:user:axi_cfg_register:1.0 cfg_1 ]
  set_property -dict [ list \
   CONFIG.AXI_ADDR_WIDTH {32} \
   CONFIG.AXI_DATA_WIDTH {32} \
   CONFIG.CFG_DATA_WIDTH {32} \
 ] $cfg_1

  # Create instance: concat_0, and set properties
  set concat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {32} \
   CONFIG.IN1_WIDTH {64} \
   CONFIG.IN2_WIDTH {64} \
   CONFIG.IN3_WIDTH {32} \
   CONFIG.IN4_WIDTH {32} \
   CONFIG.IN5_WIDTH {32} \
   CONFIG.IN6_WIDTH {32} \
   CONFIG.IN7_WIDTH {32} \
   CONFIG.IN8_WIDTH {32} \
   CONFIG.IN9_WIDTH {32} \
   CONFIG.NUM_PORTS {10} \
 ] $concat_0

  # Create instance: concat_1, and set properties
  set concat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {16} \
 ] $concat_1

  # Create instance: conv_0, and set properties
  set conv_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 conv_0 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $conv_0

  # Create instance: conv_1, and set properties
  set conv_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 conv_1 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {0} \
   CONFIG.M_TDATA_NUM_BYTES {4} \
   CONFIG.S_TDATA_NUM_BYTES {8} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_BITS_PER_BYTE {0} \
 ] $conv_1

  # Create instance: conv_2, and set properties
  set conv_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 conv_2 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $conv_2

  # Create instance: dac_0, and set properties
  set dac_0 [ create_bd_cell -type ip -vlnv pavel-demin:user:axis_zmod_dac:1.0 dac_0 ]
  set_property -dict [ list \
   CONFIG.DAC_DATA_WIDTH {14} \
 ] $dac_0

  # Create instance: fifo_0, and set properties
  set fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 fifo_0 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {1024} \
   CONFIG.HAS_WR_DATA_COUNT {1} \
   CONFIG.TDATA_NUM_BYTES {4} \
 ] $fifo_0

  # Create instance: fifo_1, and set properties
  set fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 fifo_1 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {64} \
   CONFIG.HAS_RD_DATA_COUNT {1} \
   CONFIG.HAS_WR_DATA_COUNT {1} \
   CONFIG.SYNCHRONIZATION_STAGES {3} \
   CONFIG.TDATA_NUM_BYTES {4} \
 ] $fifo_1

  # Create instance: fifo_2, and set properties
  set fifo_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 fifo_2 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {128} \
   CONFIG.HAS_RD_DATA_COUNT {1} \
   CONFIG.HAS_WR_DATA_COUNT {1} \
   CONFIG.SYNCHRONIZATION_STAGES {3} \
   CONFIG.TDATA_NUM_BYTES {8} \
 ] $fifo_2

  # Create instance: fifo_3, and set properties
  set fifo_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 fifo_3 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {128} \
   CONFIG.HAS_RD_DATA_COUNT {1} \
   CONFIG.HAS_WR_DATA_COUNT {1} \
   CONFIG.SYNCHRONIZATION_STAGES {3} \
   CONFIG.TDATA_NUM_BYTES {4} \
 ] $fifo_3

  # Create instance: fifo_4, and set properties
  set fifo_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 fifo_4 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {128} \
   CONFIG.HAS_RD_DATA_COUNT {1} \
   CONFIG.HAS_WR_DATA_COUNT {1} \
   CONFIG.SYNCHRONIZATION_STAGES {3} \
   CONFIG.TDATA_NUM_BYTES {4} \
 ] $fifo_4

  # Create instance: fifo_5, and set properties
  set fifo_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 fifo_5 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {128} \
   CONFIG.HAS_RD_DATA_COUNT {1} \
   CONFIG.HAS_WR_DATA_COUNT {1} \
   CONFIG.SYNCHRONIZATION_STAGES {3} \
   CONFIG.TDATA_NUM_BYTES {8} \
 ] $fifo_5

  # Create instance: fifo_6, and set properties
  set fifo_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 fifo_6 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {1024} \
   CONFIG.HAS_WR_DATA_COUNT {1} \
   CONFIG.TDATA_NUM_BYTES {4} \
 ] $fifo_6

  # Create instance: fifo_9, and set properties
  set fifo_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 fifo_9 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {512} \
   CONFIG.HAS_RD_DATA_COUNT {1} \
   CONFIG.HAS_WR_DATA_COUNT {1} \
   CONFIG.SYNCHRONIZATION_STAGES {3} \
 ] $fifo_9

  # Create instance: obufds_0, and set properties
  set obufds_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 obufds_0 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {OBUFDS} \
 ] $obufds_0

  # Create instance: pktzr_0, and set properties
  set pktzr_0 [ create_bd_cell -type ip -vlnv pavel-demin:user:axis_packetizer:1.0 pktzr_0 ]
  set_property -dict [ list \
   CONFIG.AXIS_TDATA_WIDTH {32} \
   CONFIG.CNTR_WIDTH {32} \
   CONFIG.CONTINUOUS {FALSE} \
 ] $pktzr_0

  # Create instance: pktzr_1, and set properties
  set pktzr_1 [ create_bd_cell -type ip -vlnv pavel-demin:user:axis_packetizer:1.0 pktzr_1 ]
  set_property -dict [ list \
   CONFIG.ALWAYS_READY {FALSE} \
   CONFIG.AXIS_TDATA_WIDTH {64} \
   CONFIG.CNTR_WIDTH {32} \
   CONFIG.CONTINUOUS {FALSE} \
 ] $pktzr_1

  # Create instance: pll_1, and set properties
  set pll_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 pll_1 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {600} \
   CONFIG.CLKIN1_UI_JITTER {600} \
   CONFIG.CLKIN2_JITTER_PS {100.000} \
   CONFIG.CLKIN2_UI_JITTER {100.000} \
   CONFIG.CLKOUT1_JITTER {149.106} \
   CONFIG.CLKOUT1_PHASE_ERROR {79.592} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.0} \
   CONFIG.CLKOUT1_USED {true} \
   CONFIG.JITTER_OPTIONS {PS} \
   CONFIG.JITTER_SEL {Min_O_Jitter} \
   CONFIG.MMCM_BANDWIDTH {HIGH} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {14} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {14} \
   CONFIG.MMCM_REF_JITTER1 {0.060} \
   CONFIG.PRIMITIVE {PLL} \
   CONFIG.PRIM_IN_FREQ {100.0} \
   CONFIG.USE_RESET {false} \
 ] $pll_1

  # Create instance: pll_2, and set properties
  set pll_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 pll_2 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {600} \
   CONFIG.CLKIN1_UI_JITTER {600} \
   CONFIG.CLKIN2_JITTER_PS {100.000} \
   CONFIG.CLKIN2_UI_JITTER {100.000} \
   CONFIG.CLKOUT1_JITTER {149.106} \
   CONFIG.CLKOUT1_PHASE_ERROR {79.592} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.0} \
   CONFIG.CLKOUT1_USED {true} \
   CONFIG.JITTER_OPTIONS {PS} \
   CONFIG.JITTER_SEL {Min_O_Jitter} \
   CONFIG.MMCM_BANDWIDTH {HIGH} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {14} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {14} \
   CONFIG.MMCM_REF_JITTER1 {0.060} \
   CONFIG.PRIMITIVE {PLL} \
   CONFIG.PRIM_IN_FREQ {100.0} \
   CONFIG.USE_RESET {false} \
 ] $pll_2

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
 ] $proc_sys_reset_1

  # Create instance: ps_0_axi_periph, and set properties
  set ps_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {3} \
   CONFIG.M01_HAS_REGSLICE {3} \
   CONFIG.M02_HAS_REGSLICE {3} \
   CONFIG.M03_HAS_REGSLICE {3} \
   CONFIG.M04_HAS_REGSLICE {3} \
   CONFIG.M05_HAS_REGSLICE {3} \
   CONFIG.NUM_MI {9} \
   CONFIG.S00_HAS_REGSLICE {3} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
 ] $ps_0_axi_periph

  # Create instance: slice_0, and set properties
  set slice_0 [ create_bd_cell -type ip -vlnv pavel-demin:user:port_slicer:1.0 slice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {32} \
 ] $slice_0

  # Create instance: slice_1, and set properties
  set slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {1} \
 ] $slice_1

  # Create instance: slice_2, and set properties
  set slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {1} \
 ] $slice_2

  # Create instance: slice_3, and set properties
  set slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {1} \
 ] $slice_3

  # Create instance: slice_4, and set properties
  set slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {63} \
   CONFIG.DIN_TO {32} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {32} \
 ] $slice_4

  # Create instance: slice_5, and set properties
  set slice_5 [ create_bd_cell -type ip -vlnv pavel-demin:user:port_slicer:1.0 slice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {16} \
   CONFIG.DIN_WIDTH {32} \
 ] $slice_5

  # Create instance: slice_8, and set properties
  set slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {1} \
 ] $slice_8

  # Create instance: spi_0, and set properties
  set spi_0 [ create_bd_cell -type ip -vlnv pavel-demin:user:axis_spi:1.0 spi_0 ]
  set_property -dict [ list \
   CONFIG.SPI_DATA_WIDTH {24} \
 ] $spi_0

  # Create instance: spi_1, and set properties
  set spi_1 [ create_bd_cell -type ip -vlnv pavel-demin:user:axis_spi:1.0 spi_1 ]
  set_property -dict [ list \
   CONFIG.SPI_DATA_WIDTH {16} \
 ] $spi_1

  # Create instance: sts_0, and set properties
  set sts_0 [ create_bd_cell -type ip -vlnv pavel-demin:user:axi_sts_register:1.0 sts_0 ]
  set_property -dict [ list \
   CONFIG.AXI_ADDR_WIDTH {32} \
   CONFIG.AXI_DATA_WIDTH {32} \
   CONFIG.STS_DATA_WIDTH {384} \
 ] $sts_0

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {xor} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_xorgate.png} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {xor} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_xorgate.png} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_2

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_3

  # Create instance: writer_0, and set properties
  set writer_0 [ create_bd_cell -type ip -vlnv pavel-demin:user:axi_axis_writer:1.0 writer_0 ]
  set_property -dict [ list \
   CONFIG.AXI_DATA_WIDTH {32} \
 ] $writer_0

  # Create instance: writer_1, and set properties
  set writer_1 [ create_bd_cell -type ip -vlnv pavel-demin:user:axi_axis_writer:1.0 writer_1 ]
  set_property -dict [ list \
   CONFIG.AXI_DATA_WIDTH {32} \
 ] $writer_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {4} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0xFFFFFFFF} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_1

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0xFFFFFFFF} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0xFFFFFFFF} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_3

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0xFFFFFFFF} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_4

  # Create instance: xlconstant_5, and set properties
  set xlconstant_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0xFFFFFFFF} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_5

  # Create instance: zeroer_0, and set properties
  set zeroer_0 [ create_bd_cell -type ip -vlnv pavel-demin:user:axis_zeroer:1.0 zeroer_0 ]
  set_property -dict [ list \
   CONFIG.AXIS_TDATA_WIDTH {32} \
 ] $zeroer_0

  # Create interface connections
  connect_bd_intf_net -intf_net adc_0_M_AXIS [get_bd_intf_pins adc_0/M_AXIS] [get_bd_intf_pins axis_switch_3/S00_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_mcdma_0/M_AXIS_MM2S] [get_bd_intf_pins conv_1/S_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_MM2S [get_bd_intf_pins axi_mcdma_0/M_AXI_MM2S] [get_bd_intf_pins axi_smc_1/S00_AXI]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_S2MM [get_bd_intf_pins axi_mcdma_0/M_AXI_S2MM] [get_bd_intf_pins axi_smc_3/S00_AXI]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_SG [get_bd_intf_pins axi_mcdma_0/M_AXI_SG] [get_bd_intf_pins axi_smc_2/S00_AXI]
  connect_bd_intf_net -intf_net axi_smc_1_M00_AXI [get_bd_intf_ports M00_AXI1] [get_bd_intf_pins axi_smc_1/M00_AXI]
  connect_bd_intf_net -intf_net axi_smc_2_M00_AXI [get_bd_intf_ports M00_AXI2] [get_bd_intf_pins axi_smc_2/M00_AXI]
  connect_bd_intf_net -intf_net axi_smc_3_M00_AXI [get_bd_intf_ports M00_AXI] [get_bd_intf_pins axi_smc_3/M00_AXI]
  connect_bd_intf_net -intf_net axis_broadcaster_2_M00_AXIS [get_bd_intf_pins axis_broadcaster_2/M00_AXIS] [get_bd_intf_pins conv_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_2_M01_AXIS [get_bd_intf_pins axis_broadcaster_2/M01_AXIS] [get_bd_intf_pins axis_subset_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_2_M02_AXIS [get_bd_intf_pins axis_broadcaster_2/M02_AXIS] [get_bd_intf_pins axis_subset_converter_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_multiport_acc_0_M_AXIS [get_bd_intf_pins axis_multiport_acc_0/M_AXIS] [get_bd_intf_pins pktzr_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_accumulator_0/S_AXIS] [get_bd_intf_pins axis_subset_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_1_M_AXIS [get_bd_intf_pins axis_accumulator_1/S_AXIS] [get_bd_intf_pins axis_subset_converter_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M00_AXIS [get_bd_intf_pins axis_switch_0/M00_AXIS] [get_bd_intf_pins fifo_9/S_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M01_AXIS [get_bd_intf_pins axis_multiport_acc_0/S_AXIS_2] [get_bd_intf_pins axis_switch_0/M01_AXIS]
  connect_bd_intf_net -intf_net axis_switch_1_M00_AXIS [get_bd_intf_pins axis_switch_1/M00_AXIS] [get_bd_intf_pins fifo_2/S_AXIS]
  connect_bd_intf_net -intf_net axis_switch_2_M00_AXIS [get_bd_intf_pins axis_switch_2/M00_AXIS] [get_bd_intf_pins fifo_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_switch_2_M01_AXIS [get_bd_intf_pins axis_switch_2/M01_AXIS] [get_bd_intf_pins fifo_3/S_AXIS]
  connect_bd_intf_net -intf_net axis_switch_2_M02_AXIS [get_bd_intf_pins axis_switch_2/M02_AXIS] [get_bd_intf_pins fifo_4/S_AXIS]
  connect_bd_intf_net -intf_net axis_switch_2_M03_AXIS [get_bd_intf_pins axis_switch_2/M03_AXIS] [get_bd_intf_pins conv_2/S_AXIS]
  connect_bd_intf_net -intf_net axis_switch_3_M00_AXIS [get_bd_intf_pins axis_switch_3/M00_AXIS] [get_bd_intf_pins pktzr_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_switch_3_M01_AXIS [get_bd_intf_pins axis_switch_3/M01_AXIS] [get_bd_intf_pins zeroer_0/S_AXIS]
  connect_bd_intf_net -intf_net conv_0_M_AXIS [get_bd_intf_pins axis_switch_1/S00_AXIS] [get_bd_intf_pins conv_0/M_AXIS]
  connect_bd_intf_net -intf_net conv_1_M_AXIS [get_bd_intf_pins axis_switch_2/S00_AXIS] [get_bd_intf_pins conv_1/M_AXIS]
  connect_bd_intf_net -intf_net conv_2_M_AXIS [get_bd_intf_pins conv_2/M_AXIS] [get_bd_intf_pins fifo_5/S_AXIS]
  connect_bd_intf_net -intf_net fifo_0_M_AXIS [get_bd_intf_pins fifo_0/M_AXIS] [get_bd_intf_pins spi_0/S_AXIS]
  connect_bd_intf_net -intf_net fifo_1_M_AXIS [get_bd_intf_pins axis_switch_0/S00_AXIS] [get_bd_intf_pins fifo_1/M_AXIS]
  connect_bd_intf_net -intf_net fifo_1_M_AXIS1 [get_bd_intf_pins fifo_6/M_AXIS] [get_bd_intf_pins spi_1/S_AXIS]
  connect_bd_intf_net -intf_net fifo_2_M_AXIS [get_bd_intf_pins axi_mcdma_0/S_AXIS_S2MM] [get_bd_intf_pins fifo_2/M_AXIS]
  connect_bd_intf_net -intf_net fifo_3_M_AXIS [get_bd_intf_pins axis_multiport_acc_0/S_AXIS_1] [get_bd_intf_pins fifo_3/M_AXIS]
  connect_bd_intf_net -intf_net fifo_4_M_AXIS [get_bd_intf_pins axis_multiport_acc_0/S_AXIS_0] [get_bd_intf_pins fifo_4/M_AXIS]
  connect_bd_intf_net -intf_net fifo_5_M_AXIS [get_bd_intf_pins axis_multiport_acc_0/S_AXIS_accin] [get_bd_intf_pins fifo_5/M_AXIS]
  connect_bd_intf_net -intf_net fifo_9_M_AXIS [get_bd_intf_pins axis_switch_3/S01_AXIS] [get_bd_intf_pins fifo_9/M_AXIS]
  connect_bd_intf_net -intf_net pktzr_0_M_AXIS [get_bd_intf_pins axis_broadcaster_2/S_AXIS] [get_bd_intf_pins pktzr_0/M_AXIS]
  connect_bd_intf_net -intf_net pktzr_1_M_AXIS [get_bd_intf_pins axis_switch_1/S01_AXIS] [get_bd_intf_pins pktzr_1/M_AXIS]
  connect_bd_intf_net -intf_net ps_0_M_AXI_HPM0_FPD [get_bd_intf_ports S00_AXI] [get_bd_intf_pins ps_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps_0_axi_periph_M00_AXI [get_bd_intf_pins cfg_0/S_AXI] [get_bd_intf_pins ps_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps_0_axi_periph_M01_AXI [get_bd_intf_pins ps_0_axi_periph/M01_AXI] [get_bd_intf_pins sts_0/S_AXI]
  connect_bd_intf_net -intf_net ps_0_axi_periph_M02_AXI [get_bd_intf_pins axi_mcdma_0/S_AXI_LITE] [get_bd_intf_pins ps_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps_0_axi_periph_M03_AXI [get_bd_intf_pins axis_switch_1/S_AXI_CTRL] [get_bd_intf_pins ps_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net ps_0_axi_periph_M04_AXI [get_bd_intf_pins axis_switch_0/S_AXI_CTRL] [get_bd_intf_pins ps_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net ps_0_axi_periph_M05_AXI [get_bd_intf_pins axis_switch_3/S_AXI_CTRL] [get_bd_intf_pins ps_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net ps_0_axi_periph_M06_AXI [get_bd_intf_pins cfg_1/S_AXI] [get_bd_intf_pins ps_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net ps_0_axi_periph_M07_AXI [get_bd_intf_pins ps_0_axi_periph/M07_AXI] [get_bd_intf_pins writer_0/S_AXI]
  connect_bd_intf_net -intf_net ps_0_axi_periph_M08_AXI [get_bd_intf_pins ps_0_axi_periph/M08_AXI] [get_bd_intf_pins writer_1/S_AXI]
  connect_bd_intf_net -intf_net writer_0_M_AXIS [get_bd_intf_pins fifo_0/S_AXIS] [get_bd_intf_pins writer_0/M_AXIS]
  connect_bd_intf_net -intf_net writer_1_M_AXIS [get_bd_intf_pins fifo_6/S_AXIS] [get_bd_intf_pins writer_1/M_AXIS]
  connect_bd_intf_net -intf_net zeroer_0_M_AXIS [get_bd_intf_pins dac_0/S_AXIS] [get_bd_intf_pins zeroer_0/M_AXIS]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins proc_sys_reset_1/interconnect_aresetn] [get_bd_pins ps_0_axi_periph/ARESETN]
  connect_bd_net -net adc_data_i_1 [get_bd_ports adc_data_i] [get_bd_pins adc_0/adc_data]
  connect_bd_net -net adc_dco_i_1 [get_bd_ports adc_dco_i] [get_bd_pins pll_1/clk_in1]
  connect_bd_net -net axis_accumulator_0_m_axis_tdata [get_bd_pins axis_accumulator_0/m_axis_tdata] [get_bd_pins concat_0/In2]
  connect_bd_net -net axis_accumulator_1_m_axis_tdata [get_bd_pins axis_accumulator_1/m_axis_tdata] [get_bd_pins concat_0/In1]
  connect_bd_net -net axis_counter_1_m_axis_tdata [get_bd_pins axis_counter_1/m_axis_tdata] [get_bd_pins c_addsub_0/B]
  connect_bd_net -net axis_counter_2_m_axis_tdata [get_bd_pins axis_counter_2/m_axis_tdata] [get_bd_pins c_addsub_1/B]
  connect_bd_net -net axis_multiport_acc_0_m_axis_tlast [get_bd_pins axis_multiport_acc_0/m_axis_tlast] [get_bd_pins concat_1/In5]
  connect_bd_net -net axis_switch_1_m_axis_tlast [get_bd_pins axis_switch_1/m_axis_tlast] [get_bd_pins concat_1/In1] [get_bd_pins fifo_2/s_axis_tlast]
  connect_bd_net -net axis_switch_1_m_axis_tvalid [get_bd_pins axis_switch_1/m_axis_tvalid] [get_bd_pins concat_1/In2] [get_bd_pins fifo_2/s_axis_tvalid]
  connect_bd_net -net axis_switch_2_s_decode_err [get_bd_pins axis_switch_2/s_decode_err] [get_bd_pins concat_1/In0]
  connect_bd_net -net c_addsub_0_S [get_bd_pins c_addsub_0/S] [get_bd_pins c_addsub_2/A]
  connect_bd_net -net c_addsub_1_S [get_bd_pins c_addsub_1/S] [get_bd_pins c_addsub_2/B]
  connect_bd_net -net c_addsub_2_S [get_bd_pins c_addsub_2/S] [get_bd_pins concat_0/In0]
  connect_bd_net -net cfg_0_cfg_data [get_bd_pins cfg_0/cfg_data] [get_bd_pins slice_1/Din] [get_bd_pins slice_2/Din] [get_bd_pins slice_3/Din] [get_bd_pins slice_4/Din] [get_bd_pins slice_8/Din]
  connect_bd_net -net cfg_0_cfg_data1 [get_bd_pins cfg_1/cfg_data] [get_bd_pins slice_0/din] [get_bd_pins slice_5/din]
  connect_bd_net -net concat_0_dout [get_bd_pins concat_0/dout] [get_bd_pins sts_0/sts_data]
  connect_bd_net -net concat_1_dout [get_bd_pins concat_0/In8] [get_bd_pins concat_1/dout]
  connect_bd_net -net dac_0_dac_clk [get_bd_ports dac_clk_o] [get_bd_pins dac_0/dac_clk]
  connect_bd_net -net dac_0_dac_data [get_bd_ports dac_data_o] [get_bd_pins dac_0/dac_data]
  connect_bd_net -net fifo_1_axis_rd_data_count [get_bd_pins concat_0/In5] [get_bd_pins fifo_1/axis_rd_data_count]
  connect_bd_net -net fifo_1_m_axis_tlast [get_bd_pins axis_switch_0/s_axis_tlast] [get_bd_pins concat_1/In6] [get_bd_pins fifo_1/m_axis_tlast] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net fifo_2_axis_rd_data_count [get_bd_pins concat_0/In7] [get_bd_pins fifo_2/axis_rd_data_count]
  connect_bd_net -net fifo_2_m_axis_tlast [get_bd_pins axi_mcdma_0/s_axis_s2mm_tlast] [get_bd_pins concat_1/In4] [get_bd_pins fifo_2/m_axis_tlast] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net fifo_2_s_axis_tready [get_bd_pins axis_switch_1/m_axis_tready] [get_bd_pins concat_1/In3] [get_bd_pins fifo_2/s_axis_tready]
  connect_bd_net -net fifo_3_axis_rd_data_count [get_bd_pins concat_0/In4] [get_bd_pins fifo_3/axis_rd_data_count]
  connect_bd_net -net fifo_4_axis_rd_data_count [get_bd_pins concat_0/In3] [get_bd_pins fifo_4/axis_rd_data_count]
  connect_bd_net -net fifo_5_axis_rd_data_count [get_bd_pins concat_0/In6] [get_bd_pins fifo_5/axis_rd_data_count]
  connect_bd_net -net fifo_9_axis_rd_data_count [get_bd_pins concat_0/In9] [get_bd_pins fifo_9/axis_rd_data_count]
  connect_bd_net -net obufds_0_OBUF_DS_N [get_bd_ports adc_clk_n_o] [get_bd_pins obufds_0/OBUF_DS_N]
  connect_bd_net -net obufds_0_OBUF_DS_P [get_bd_ports adc_clk_p_o] [get_bd_pins obufds_0/OBUF_DS_P]
  connect_bd_net -net pll_0_clk_out2 [get_bd_ports clk_out1] [get_bd_pins adc_0/aclk] [get_bd_pins axi_mcdma_0/s_axi_aclk] [get_bd_pins axi_mcdma_0/s_axi_lite_aclk] [get_bd_pins axi_smc_1/aclk] [get_bd_pins axi_smc_2/aclk] [get_bd_pins axi_smc_3/aclk] [get_bd_pins axis_accumulator_0/aclk] [get_bd_pins axis_accumulator_1/aclk] [get_bd_pins axis_broadcaster_2/aclk] [get_bd_pins axis_counter_0/aclk] [get_bd_pins axis_counter_1/aclk] [get_bd_pins axis_counter_2/aclk] [get_bd_pins axis_multiport_acc_0/aclk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins axis_subset_converter_1/aclk] [get_bd_pins axis_switch_0/aclk] [get_bd_pins axis_switch_0/s_axi_ctrl_aclk] [get_bd_pins axis_switch_1/aclk] [get_bd_pins axis_switch_1/s_axi_ctrl_aclk] [get_bd_pins axis_switch_2/aclk] [get_bd_pins axis_switch_3/aclk] [get_bd_pins axis_switch_3/s_axi_ctrl_aclk] [get_bd_pins c_addsub_0/CLK] [get_bd_pins c_addsub_1/CLK] [get_bd_pins c_addsub_2/CLK] [get_bd_pins cfg_0/aclk] [get_bd_pins cfg_1/aclk] [get_bd_pins conv_0/aclk] [get_bd_pins conv_1/aclk] [get_bd_pins conv_2/aclk] [get_bd_pins dac_0/aclk] [get_bd_pins fifo_0/s_axis_aclk] [get_bd_pins fifo_1/s_axis_aclk] [get_bd_pins fifo_2/s_axis_aclk] [get_bd_pins fifo_3/s_axis_aclk] [get_bd_pins fifo_4/s_axis_aclk] [get_bd_pins fifo_5/s_axis_aclk] [get_bd_pins fifo_6/s_axis_aclk] [get_bd_pins fifo_9/s_axis_aclk] [get_bd_pins pktzr_0/aclk] [get_bd_pins pktzr_1/aclk] [get_bd_pins pll_1/clk_out1] [get_bd_pins proc_sys_reset_1/slowest_sync_clk] [get_bd_pins ps_0_axi_periph/ACLK] [get_bd_pins ps_0_axi_periph/M00_ACLK] [get_bd_pins ps_0_axi_periph/M01_ACLK] [get_bd_pins ps_0_axi_periph/M02_ACLK] [get_bd_pins ps_0_axi_periph/M03_ACLK] [get_bd_pins ps_0_axi_periph/M04_ACLK] [get_bd_pins ps_0_axi_periph/M05_ACLK] [get_bd_pins ps_0_axi_periph/M06_ACLK] [get_bd_pins ps_0_axi_periph/M07_ACLK] [get_bd_pins ps_0_axi_periph/M08_ACLK] [get_bd_pins ps_0_axi_periph/S00_ACLK] [get_bd_pins spi_0/aclk] [get_bd_pins spi_1/aclk] [get_bd_pins sts_0/aclk] [get_bd_pins writer_0/aclk] [get_bd_pins writer_1/aclk] [get_bd_pins zeroer_0/aclk]
  connect_bd_net -net pll_0_locked1 [get_bd_pins dac_0/locked] [get_bd_pins pll_1/locked] [get_bd_pins proc_sys_reset_1/dcm_locked]
  connect_bd_net -net pll_1_clk_out1 [get_bd_pins obufds_0/OBUF_IN] [get_bd_pins pll_2/clk_out1]
  connect_bd_net -net ps_0_pl_clk0 [get_bd_ports clk_in1] [get_bd_pins pll_2/clk_in1]
  connect_bd_net -net ps_0_pl_resetn0 [get_bd_ports ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net rst_0_peripheral_aresetn [get_bd_pins axi_mcdma_0/axi_resetn] [get_bd_pins axi_smc_1/aresetn] [get_bd_pins axi_smc_2/aresetn] [get_bd_pins axi_smc_3/aresetn] [get_bd_pins axis_broadcaster_2/aresetn] [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins axis_subset_converter_1/aresetn] [get_bd_pins axis_switch_0/aresetn] [get_bd_pins axis_switch_0/s_axi_ctrl_aresetn] [get_bd_pins axis_switch_1/aresetn] [get_bd_pins axis_switch_1/s_axi_ctrl_aresetn] [get_bd_pins axis_switch_2/aresetn] [get_bd_pins axis_switch_3/aresetn] [get_bd_pins axis_switch_3/s_axi_ctrl_aresetn] [get_bd_pins cfg_0/aresetn] [get_bd_pins cfg_1/aresetn] [get_bd_pins fifo_0/s_axis_aresetn] [get_bd_pins fifo_6/s_axis_aresetn] [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins ps_0_axi_periph/M00_ARESETN] [get_bd_pins ps_0_axi_periph/M01_ARESETN] [get_bd_pins ps_0_axi_periph/M02_ARESETN] [get_bd_pins ps_0_axi_periph/M03_ARESETN] [get_bd_pins ps_0_axi_periph/M04_ARESETN] [get_bd_pins ps_0_axi_periph/M05_ARESETN] [get_bd_pins ps_0_axi_periph/M06_ARESETN] [get_bd_pins ps_0_axi_periph/M07_ARESETN] [get_bd_pins ps_0_axi_periph/M08_ARESETN] [get_bd_pins ps_0_axi_periph/S00_ARESETN] [get_bd_pins spi_0/aresetn] [get_bd_pins spi_1/aresetn] [get_bd_pins sts_0/aresetn] [get_bd_pins writer_0/aresetn] [get_bd_pins writer_1/aresetn]
  connect_bd_net -net slice_0_dout [get_bd_ports adc_cfg_o] [get_bd_pins slice_0/dout]
  connect_bd_net -net slice_1_Dout [get_bd_pins axis_accumulator_0/aresetn] [get_bd_pins axis_accumulator_1/aresetn] [get_bd_pins pktzr_0/aresetn] [get_bd_pins pktzr_1/aresetn] [get_bd_pins slice_1/Dout]
  connect_bd_net -net slice_1_dout1 [get_bd_ports dac_cfg_o] [get_bd_pins slice_5/dout]
  connect_bd_net -net slice_2_Dout [get_bd_pins conv_0/aresetn] [get_bd_pins conv_1/aresetn] [get_bd_pins conv_2/aresetn] [get_bd_pins fifo_1/s_axis_aresetn] [get_bd_pins fifo_2/s_axis_aresetn] [get_bd_pins fifo_3/s_axis_aresetn] [get_bd_pins fifo_4/s_axis_aresetn] [get_bd_pins fifo_5/s_axis_aresetn] [get_bd_pins fifo_9/s_axis_aresetn] [get_bd_pins slice_2/Dout]
  connect_bd_net -net slice_3_Dout [get_bd_pins axis_counter_0/aresetn] [get_bd_pins slice_3/Dout]
  connect_bd_net -net slice_4_Dout [get_bd_pins pktzr_0/cfg_data] [get_bd_pins pktzr_1/cfg_data] [get_bd_pins slice_4/Dout]
  connect_bd_net -net slice_6_Dout [get_bd_pins axis_counter_0/m_axis_tdata] [get_bd_pins c_addsub_0/A] [get_bd_pins c_addsub_1/A]
  connect_bd_net -net slice_8_Dout [get_bd_pins slice_8/Dout] [get_bd_pins util_vector_logic_0/Op2] [get_bd_pins util_vector_logic_1/Op2]
  connect_bd_net -net spi_0_spi_data [get_bd_ports adc_spi_o] [get_bd_pins spi_0/spi_data]
  connect_bd_net -net spi_1_spi_data [get_bd_ports dac_spi_o] [get_bd_pins spi_1/spi_data]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins axis_counter_1/aresetn] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net util_vector_logic_0_Res1 [get_bd_pins util_vector_logic_0/Res] [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins axis_counter_2/aresetn] [get_bd_pins util_vector_logic_2/Res]
  connect_bd_net -net util_vector_logic_1_Res1 [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins axi_mcdma_0/s_axis_s2mm_tdest] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins axis_accumulator_0/cfg_data] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins axis_accumulator_1/cfg_data] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins axis_counter_0/cfg_data] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins axis_counter_2/cfg_data] [get_bd_pins xlconstant_4/dout]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins axis_counter_1/cfg_data] [get_bd_pins xlconstant_5/dout]

  # Create address segments
  assign_bd_address -external -dict [list offset 0x000800000000 range 0x20000000 offset 0x40000000 range 0x10000000 offset 0xFF000000 range 0x01000000] -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_MM2S] [get_bd_addr_segs M00_AXI1/Reg] -force
  assign_bd_address -external -dict [list offset 0x000800000000 range 0x20000000 offset 0x40000000 range 0x10000000] -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_S2MM] [get_bd_addr_segs M00_AXI/Reg] -force
  assign_bd_address -external -dict [list offset 0x000800000000 range 0x20000000 offset 0x40000000 range 0x10000000 offset 0xFF000000 range 0x01000000] -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_SG] [get_bd_addr_segs M00_AXI2/Reg] -force
  assign_bd_address -offset 0xB0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs axi_mcdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xB0030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs axis_switch_0/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0xB0040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs axis_switch_1/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0xB0050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs axis_switch_3/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x000500000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs cfg_0/s_axi/reg0] -force
  assign_bd_address -offset 0x004800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs cfg_1/s_axi/reg0] -force
  assign_bd_address -offset 0x004900000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs sts_0/s_axi/reg0] -force
  assign_bd_address -offset 0xB0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs writer_0/s_axi/reg0] -force
  assign_bd_address -offset 0xB0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs writer_1/s_axi/reg0] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_MM2S] [get_bd_addr_segs M00_AXI1/Reg]

  set_property USAGE memory [get_bd_addr_segs M00_AXI/Reg]
  set_property USAGE memory [get_bd_addr_segs M00_AXI1/Reg]
  set_property USAGE memory [get_bd_addr_segs M00_AXI2/Reg]


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


