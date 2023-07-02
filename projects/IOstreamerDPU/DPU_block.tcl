
################################################################
# This is a generated script based on design: DPU_block
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
# source DPU_block_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu3eg-sfvc784-1-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name DPU_block

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
xilinx.com:RTLKernel:DPUCZDX8G:1.0\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:axi_register_slice:2.1\
xilinx.com:ip:axi_vip:1.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:proc_sys_reset:5.0\
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
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.FREQ_HZ {300000000} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {16} \
   CONFIG.NUM_WRITE_OUTSTANDING {16} \
   CONFIG.PROTOCOL {AXI4} \
   ] $M00_AXI

  set M00_AXI1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {300000000} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {16} \
   CONFIG.NUM_WRITE_OUTSTANDING {16} \
   CONFIG.PROTOCOL {AXI4} \
   ] $M00_AXI1

  set M00_AXI2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI2 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.FREQ_HZ {300000000} \
   CONFIG.NUM_READ_OUTSTANDING {16} \
   CONFIG.NUM_WRITE_OUTSTANDING {16} \
   CONFIG.PROTOCOL {AXI4} \
   ] $M00_AXI2

  set M00_AXI3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI3 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.FREQ_HZ {300000000} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {16} \
   CONFIG.NUM_WRITE_OUTSTANDING {16} \
   CONFIG.PROTOCOL {AXI4} \
   ] $M00_AXI3

  set S00_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {75000000} \
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

  set S00_AXI1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.ARUSER_WIDTH {16} \
   CONFIG.AWUSER_WIDTH {16} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.FREQ_HZ {300000000} \
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
   ] $S00_AXI1


  # Create ports
  set clk_in1 [ create_bd_port -dir I -type clk clk_in1 ]
  set clk_out2 [ create_bd_port -dir O -type clk clk_out2 ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI:M00_AXI3:M00_AXI1:M00_AXI2:S00_AXI1} \
   CONFIG.FREQ_HZ {300000000} \
 ] $clk_out2
  set_property CONFIG.ASSOCIATED_BUSIF.VALUE_SRC DEFAULT $clk_out2

  set clk_out3 [ create_bd_port -dir O -type clk clk_out3 ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
   CONFIG.FREQ_HZ {75000000} \
 ] $clk_out3
  set_property CONFIG.ASSOCIATED_BUSIF.VALUE_SRC DEFAULT $clk_out3

  set irq [ create_bd_port -dir O -type intr irq ]
  set resetn [ create_bd_port -dir I -type rst resetn ]

  # Create instance: DPUCZDX8G_1, and set properties
  set DPUCZDX8G_1 [ create_bd_cell -type ip -vlnv xilinx.com:RTLKernel:DPUCZDX8G:1.0 DPUCZDX8G_1 ]
  set_property HDL_ATTRIBUTE.aclk.FREQ_HZ {300000000} [get_bd_cells DPUCZDX8G_1]
  set_property HDL_ATTRIBUTE.aclk.FREQ_HZ_TOLERANCE {15000000} [get_bd_cells DPUCZDX8G_1]
  set_property HDL_ATTRIBUTE.ap_clk_2.FREQ_HZ {600000000} [get_bd_cells DPUCZDX8G_1]
  set_property HDL_ATTRIBUTE.ap_clk_2.FREQ_HZ_TOLERANCE {30000000} [get_bd_cells DPUCZDX8G_1]

  # Create instance: axi_ic_ps_e_S_AXI_HP0_FPD, and set properties
  set axi_ic_ps_e_S_AXI_HP0_FPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_ps_e_S_AXI_HP0_FPD ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {0} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $axi_ic_ps_e_S_AXI_HP0_FPD

  # Create instance: axi_ic_ps_e_S_AXI_HP1_FPD, and set properties
  set axi_ic_ps_e_S_AXI_HP1_FPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_ps_e_S_AXI_HP1_FPD ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {0} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $axi_ic_ps_e_S_AXI_HP1_FPD

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]
  set_property -dict [ list \
   CONFIG.C_ASYNC_INTR {0xFFFFFFFF} \
   CONFIG.C_CASCADE_MASTER {0} \
   CONFIG.C_DISABLE_SYNCHRONIZERS {0} \
   CONFIG.C_ENABLE_ASYNC {0} \
   CONFIG.C_EN_CASCADE_MODE {0} \
   CONFIG.C_HAS_CIE {1} \
   CONFIG.C_HAS_FAST {0} \
   CONFIG.C_HAS_ILR {0} \
   CONFIG.C_HAS_IPR {1} \
   CONFIG.C_HAS_IVR {1} \
   CONFIG.C_HAS_SIE {1} \
   CONFIG.C_IRQ_ACTIVE {0x1} \
   CONFIG.C_IRQ_CONNECTION {1} \
   CONFIG.C_IRQ_IS_LEVEL {1} \
   CONFIG.C_KIND_OF_EDGE {0xFFFFFFFF} \
   CONFIG.C_KIND_OF_INTR {0xFFFFFFFF} \
   CONFIG.C_KIND_OF_LVL {0xFFFFFFFF} \
   CONFIG.C_MB_CLK_NOT_CONNECTED {1} \
   CONFIG.C_NUM_SW_INTR {0} \
   CONFIG.C_NUM_SYNC_FF {2} \
   CONFIG.C_PROCESSOR_CLK_FREQ_MHZ {100.0} \
   CONFIG.C_S_AXI_ACLK_FREQ_MHZ {75.0} \
   CONFIG.Sense_of_IRQ_Edge_Type {Rising} \
   CONFIG.Sense_of_IRQ_Level_Type {Active_High} \
 ] $axi_intc_0

  # Create instance: axi_intc_0_intr_1_interrupt_concat, and set properties
  set axi_intc_0_intr_1_interrupt_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 axi_intc_0_intr_1_interrupt_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $axi_intc_0_intr_1_interrupt_concat

  # Create instance: axi_interconnect_hpc0, and set properties
  set axi_interconnect_hpc0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_hpc0 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
   CONFIG.ENABLE_PROTOCOL_CHECKERS {0} \
   CONFIG.M00_HAS_DATA_FIFO {0} \
   CONFIG.M00_HAS_REGSLICE {0} \
   CONFIG.M00_ISSUANCE {0} \
   CONFIG.M00_SECURE {0} \
   CONFIG.M01_HAS_DATA_FIFO {0} \
   CONFIG.M01_HAS_REGSLICE {0} \
   CONFIG.M01_ISSUANCE {0} \
   CONFIG.M01_SECURE {0} \
   CONFIG.M02_HAS_DATA_FIFO {0} \
   CONFIG.M02_HAS_REGSLICE {0} \
   CONFIG.M02_ISSUANCE {0} \
   CONFIG.M02_SECURE {0} \
   CONFIG.M03_HAS_DATA_FIFO {0} \
   CONFIG.M03_HAS_REGSLICE {0} \
   CONFIG.M03_ISSUANCE {0} \
   CONFIG.M03_SECURE {0} \
   CONFIG.M04_HAS_DATA_FIFO {0} \
   CONFIG.M04_HAS_REGSLICE {0} \
   CONFIG.M04_ISSUANCE {0} \
   CONFIG.M04_SECURE {0} \
   CONFIG.M05_HAS_DATA_FIFO {0} \
   CONFIG.M05_HAS_REGSLICE {0} \
   CONFIG.M05_ISSUANCE {0} \
   CONFIG.M05_SECURE {0} \
   CONFIG.M06_HAS_DATA_FIFO {0} \
   CONFIG.M06_HAS_REGSLICE {0} \
   CONFIG.M06_ISSUANCE {0} \
   CONFIG.M06_SECURE {0} \
   CONFIG.M07_HAS_DATA_FIFO {0} \
   CONFIG.M07_HAS_REGSLICE {0} \
   CONFIG.M07_ISSUANCE {0} \
   CONFIG.M07_SECURE {0} \
   CONFIG.M08_HAS_DATA_FIFO {0} \
   CONFIG.M08_HAS_REGSLICE {0} \
   CONFIG.M08_ISSUANCE {0} \
   CONFIG.M08_SECURE {0} \
   CONFIG.M09_HAS_DATA_FIFO {0} \
   CONFIG.M09_HAS_REGSLICE {0} \
   CONFIG.M09_ISSUANCE {0} \
   CONFIG.M09_SECURE {0} \
   CONFIG.M10_HAS_DATA_FIFO {0} \
   CONFIG.M10_HAS_REGSLICE {0} \
   CONFIG.M10_ISSUANCE {0} \
   CONFIG.M10_SECURE {0} \
   CONFIG.M11_HAS_DATA_FIFO {0} \
   CONFIG.M11_HAS_REGSLICE {0} \
   CONFIG.M11_ISSUANCE {0} \
   CONFIG.M11_SECURE {0} \
   CONFIG.M12_HAS_DATA_FIFO {0} \
   CONFIG.M12_HAS_REGSLICE {0} \
   CONFIG.M12_ISSUANCE {0} \
   CONFIG.M12_SECURE {0} \
   CONFIG.M13_HAS_DATA_FIFO {0} \
   CONFIG.M13_HAS_REGSLICE {0} \
   CONFIG.M13_ISSUANCE {0} \
   CONFIG.M13_SECURE {0} \
   CONFIG.M14_HAS_DATA_FIFO {0} \
   CONFIG.M14_HAS_REGSLICE {0} \
   CONFIG.M14_ISSUANCE {0} \
   CONFIG.M14_SECURE {0} \
   CONFIG.M15_HAS_DATA_FIFO {0} \
   CONFIG.M15_HAS_REGSLICE {0} \
   CONFIG.M15_ISSUANCE {0} \
   CONFIG.M15_SECURE {0} \
   CONFIG.M16_HAS_DATA_FIFO {0} \
   CONFIG.M16_HAS_REGSLICE {0} \
   CONFIG.M16_ISSUANCE {0} \
   CONFIG.M16_SECURE {0} \
   CONFIG.M17_HAS_DATA_FIFO {0} \
   CONFIG.M17_HAS_REGSLICE {0} \
   CONFIG.M17_ISSUANCE {0} \
   CONFIG.M17_SECURE {0} \
   CONFIG.M18_HAS_DATA_FIFO {0} \
   CONFIG.M18_HAS_REGSLICE {0} \
   CONFIG.M18_ISSUANCE {0} \
   CONFIG.M18_SECURE {0} \
   CONFIG.M19_HAS_DATA_FIFO {0} \
   CONFIG.M19_HAS_REGSLICE {0} \
   CONFIG.M19_ISSUANCE {0} \
   CONFIG.M19_SECURE {0} \
   CONFIG.M20_HAS_DATA_FIFO {0} \
   CONFIG.M20_HAS_REGSLICE {0} \
   CONFIG.M20_ISSUANCE {0} \
   CONFIG.M20_SECURE {0} \
   CONFIG.M21_HAS_DATA_FIFO {0} \
   CONFIG.M21_HAS_REGSLICE {0} \
   CONFIG.M21_ISSUANCE {0} \
   CONFIG.M21_SECURE {0} \
   CONFIG.M22_HAS_DATA_FIFO {0} \
   CONFIG.M22_HAS_REGSLICE {0} \
   CONFIG.M22_ISSUANCE {0} \
   CONFIG.M22_SECURE {0} \
   CONFIG.M23_HAS_DATA_FIFO {0} \
   CONFIG.M23_HAS_REGSLICE {0} \
   CONFIG.M23_ISSUANCE {0} \
   CONFIG.M23_SECURE {0} \
   CONFIG.M24_HAS_DATA_FIFO {0} \
   CONFIG.M24_HAS_REGSLICE {0} \
   CONFIG.M24_ISSUANCE {0} \
   CONFIG.M24_SECURE {0} \
   CONFIG.M25_HAS_DATA_FIFO {0} \
   CONFIG.M25_HAS_REGSLICE {0} \
   CONFIG.M25_ISSUANCE {0} \
   CONFIG.M25_SECURE {0} \
   CONFIG.M26_HAS_DATA_FIFO {0} \
   CONFIG.M26_HAS_REGSLICE {0} \
   CONFIG.M26_ISSUANCE {0} \
   CONFIG.M26_SECURE {0} \
   CONFIG.M27_HAS_DATA_FIFO {0} \
   CONFIG.M27_HAS_REGSLICE {0} \
   CONFIG.M27_ISSUANCE {0} \
   CONFIG.M27_SECURE {0} \
   CONFIG.M28_HAS_DATA_FIFO {0} \
   CONFIG.M28_HAS_REGSLICE {0} \
   CONFIG.M28_ISSUANCE {0} \
   CONFIG.M28_SECURE {0} \
   CONFIG.M29_HAS_DATA_FIFO {0} \
   CONFIG.M29_HAS_REGSLICE {0} \
   CONFIG.M29_ISSUANCE {0} \
   CONFIG.M29_SECURE {0} \
   CONFIG.M30_HAS_DATA_FIFO {0} \
   CONFIG.M30_HAS_REGSLICE {0} \
   CONFIG.M30_ISSUANCE {0} \
   CONFIG.M30_SECURE {0} \
   CONFIG.M31_HAS_DATA_FIFO {0} \
   CONFIG.M31_HAS_REGSLICE {0} \
   CONFIG.M31_ISSUANCE {0} \
   CONFIG.M31_SECURE {0} \
   CONFIG.M32_HAS_DATA_FIFO {0} \
   CONFIG.M32_HAS_REGSLICE {0} \
   CONFIG.M32_ISSUANCE {0} \
   CONFIG.M32_SECURE {0} \
   CONFIG.M33_HAS_DATA_FIFO {0} \
   CONFIG.M33_HAS_REGSLICE {0} \
   CONFIG.M33_ISSUANCE {0} \
   CONFIG.M33_SECURE {0} \
   CONFIG.M34_HAS_DATA_FIFO {0} \
   CONFIG.M34_HAS_REGSLICE {0} \
   CONFIG.M34_ISSUANCE {0} \
   CONFIG.M34_SECURE {0} \
   CONFIG.M35_HAS_DATA_FIFO {0} \
   CONFIG.M35_HAS_REGSLICE {0} \
   CONFIG.M35_ISSUANCE {0} \
   CONFIG.M35_SECURE {0} \
   CONFIG.M36_HAS_DATA_FIFO {0} \
   CONFIG.M36_HAS_REGSLICE {0} \
   CONFIG.M36_ISSUANCE {0} \
   CONFIG.M36_SECURE {0} \
   CONFIG.M37_HAS_DATA_FIFO {0} \
   CONFIG.M37_HAS_REGSLICE {0} \
   CONFIG.M37_ISSUANCE {0} \
   CONFIG.M37_SECURE {0} \
   CONFIG.M38_HAS_DATA_FIFO {0} \
   CONFIG.M38_HAS_REGSLICE {0} \
   CONFIG.M38_ISSUANCE {0} \
   CONFIG.M38_SECURE {0} \
   CONFIG.M39_HAS_DATA_FIFO {0} \
   CONFIG.M39_HAS_REGSLICE {0} \
   CONFIG.M39_ISSUANCE {0} \
   CONFIG.M39_SECURE {0} \
   CONFIG.M40_HAS_DATA_FIFO {0} \
   CONFIG.M40_HAS_REGSLICE {0} \
   CONFIG.M40_ISSUANCE {0} \
   CONFIG.M40_SECURE {0} \
   CONFIG.M41_HAS_DATA_FIFO {0} \
   CONFIG.M41_HAS_REGSLICE {0} \
   CONFIG.M41_ISSUANCE {0} \
   CONFIG.M41_SECURE {0} \
   CONFIG.M42_HAS_DATA_FIFO {0} \
   CONFIG.M42_HAS_REGSLICE {0} \
   CONFIG.M42_ISSUANCE {0} \
   CONFIG.M42_SECURE {0} \
   CONFIG.M43_HAS_DATA_FIFO {0} \
   CONFIG.M43_HAS_REGSLICE {0} \
   CONFIG.M43_ISSUANCE {0} \
   CONFIG.M43_SECURE {0} \
   CONFIG.M44_HAS_DATA_FIFO {0} \
   CONFIG.M44_HAS_REGSLICE {0} \
   CONFIG.M44_ISSUANCE {0} \
   CONFIG.M44_SECURE {0} \
   CONFIG.M45_HAS_DATA_FIFO {0} \
   CONFIG.M45_HAS_REGSLICE {0} \
   CONFIG.M45_ISSUANCE {0} \
   CONFIG.M45_SECURE {0} \
   CONFIG.M46_HAS_DATA_FIFO {0} \
   CONFIG.M46_HAS_REGSLICE {0} \
   CONFIG.M46_ISSUANCE {0} \
   CONFIG.M46_SECURE {0} \
   CONFIG.M47_HAS_DATA_FIFO {0} \
   CONFIG.M47_HAS_REGSLICE {0} \
   CONFIG.M47_ISSUANCE {0} \
   CONFIG.M47_SECURE {0} \
   CONFIG.M48_HAS_DATA_FIFO {0} \
   CONFIG.M48_HAS_REGSLICE {0} \
   CONFIG.M48_ISSUANCE {0} \
   CONFIG.M48_SECURE {0} \
   CONFIG.M49_HAS_DATA_FIFO {0} \
   CONFIG.M49_HAS_REGSLICE {0} \
   CONFIG.M49_ISSUANCE {0} \
   CONFIG.M49_SECURE {0} \
   CONFIG.M50_HAS_DATA_FIFO {0} \
   CONFIG.M50_HAS_REGSLICE {0} \
   CONFIG.M50_ISSUANCE {0} \
   CONFIG.M50_SECURE {0} \
   CONFIG.M51_HAS_DATA_FIFO {0} \
   CONFIG.M51_HAS_REGSLICE {0} \
   CONFIG.M51_ISSUANCE {0} \
   CONFIG.M51_SECURE {0} \
   CONFIG.M52_HAS_DATA_FIFO {0} \
   CONFIG.M52_HAS_REGSLICE {0} \
   CONFIG.M52_ISSUANCE {0} \
   CONFIG.M52_SECURE {0} \
   CONFIG.M53_HAS_DATA_FIFO {0} \
   CONFIG.M53_HAS_REGSLICE {0} \
   CONFIG.M53_ISSUANCE {0} \
   CONFIG.M53_SECURE {0} \
   CONFIG.M54_HAS_DATA_FIFO {0} \
   CONFIG.M54_HAS_REGSLICE {0} \
   CONFIG.M54_ISSUANCE {0} \
   CONFIG.M54_SECURE {0} \
   CONFIG.M55_HAS_DATA_FIFO {0} \
   CONFIG.M55_HAS_REGSLICE {0} \
   CONFIG.M55_ISSUANCE {0} \
   CONFIG.M55_SECURE {0} \
   CONFIG.M56_HAS_DATA_FIFO {0} \
   CONFIG.M56_HAS_REGSLICE {0} \
   CONFIG.M56_ISSUANCE {0} \
   CONFIG.M56_SECURE {0} \
   CONFIG.M57_HAS_DATA_FIFO {0} \
   CONFIG.M57_HAS_REGSLICE {0} \
   CONFIG.M57_ISSUANCE {0} \
   CONFIG.M57_SECURE {0} \
   CONFIG.M58_HAS_DATA_FIFO {0} \
   CONFIG.M58_HAS_REGSLICE {0} \
   CONFIG.M58_ISSUANCE {0} \
   CONFIG.M58_SECURE {0} \
   CONFIG.M59_HAS_DATA_FIFO {0} \
   CONFIG.M59_HAS_REGSLICE {0} \
   CONFIG.M59_ISSUANCE {0} \
   CONFIG.M59_SECURE {0} \
   CONFIG.M60_HAS_DATA_FIFO {0} \
   CONFIG.M60_HAS_REGSLICE {0} \
   CONFIG.M60_ISSUANCE {0} \
   CONFIG.M60_SECURE {0} \
   CONFIG.M61_HAS_DATA_FIFO {0} \
   CONFIG.M61_HAS_REGSLICE {0} \
   CONFIG.M61_ISSUANCE {0} \
   CONFIG.M61_SECURE {0} \
   CONFIG.M62_HAS_DATA_FIFO {0} \
   CONFIG.M62_HAS_REGSLICE {0} \
   CONFIG.M62_ISSUANCE {0} \
   CONFIG.M62_SECURE {0} \
   CONFIG.M63_HAS_DATA_FIFO {0} \
   CONFIG.M63_HAS_REGSLICE {0} \
   CONFIG.M63_ISSUANCE {0} \
   CONFIG.M63_SECURE {0} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.PCHK_MAX_RD_BURSTS {2} \
   CONFIG.PCHK_MAX_WR_BURSTS {2} \
   CONFIG.PCHK_WAITS {0} \
   CONFIG.S00_ARB_PRIORITY {0} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
   CONFIG.S01_ARB_PRIORITY {0} \
   CONFIG.S01_HAS_DATA_FIFO {0} \
   CONFIG.S01_HAS_REGSLICE {0} \
   CONFIG.S02_ARB_PRIORITY {0} \
   CONFIG.S02_HAS_DATA_FIFO {0} \
   CONFIG.S02_HAS_REGSLICE {0} \
   CONFIG.S03_ARB_PRIORITY {0} \
   CONFIG.S03_HAS_DATA_FIFO {0} \
   CONFIG.S03_HAS_REGSLICE {0} \
   CONFIG.S04_ARB_PRIORITY {0} \
   CONFIG.S04_HAS_DATA_FIFO {0} \
   CONFIG.S04_HAS_REGSLICE {0} \
   CONFIG.S05_ARB_PRIORITY {0} \
   CONFIG.S05_HAS_DATA_FIFO {0} \
   CONFIG.S05_HAS_REGSLICE {0} \
   CONFIG.S06_ARB_PRIORITY {0} \
   CONFIG.S06_HAS_DATA_FIFO {0} \
   CONFIG.S06_HAS_REGSLICE {0} \
   CONFIG.S07_ARB_PRIORITY {0} \
   CONFIG.S07_HAS_DATA_FIFO {0} \
   CONFIG.S07_HAS_REGSLICE {0} \
   CONFIG.S08_ARB_PRIORITY {0} \
   CONFIG.S08_HAS_DATA_FIFO {0} \
   CONFIG.S08_HAS_REGSLICE {0} \
   CONFIG.S09_ARB_PRIORITY {0} \
   CONFIG.S09_HAS_DATA_FIFO {0} \
   CONFIG.S09_HAS_REGSLICE {0} \
   CONFIG.S10_ARB_PRIORITY {0} \
   CONFIG.S10_HAS_DATA_FIFO {0} \
   CONFIG.S10_HAS_REGSLICE {0} \
   CONFIG.S11_ARB_PRIORITY {0} \
   CONFIG.S11_HAS_DATA_FIFO {0} \
   CONFIG.S11_HAS_REGSLICE {0} \
   CONFIG.S12_ARB_PRIORITY {0} \
   CONFIG.S12_HAS_DATA_FIFO {0} \
   CONFIG.S12_HAS_REGSLICE {0} \
   CONFIG.S13_ARB_PRIORITY {0} \
   CONFIG.S13_HAS_DATA_FIFO {0} \
   CONFIG.S13_HAS_REGSLICE {0} \
   CONFIG.S14_ARB_PRIORITY {0} \
   CONFIG.S14_HAS_DATA_FIFO {0} \
   CONFIG.S14_HAS_REGSLICE {0} \
   CONFIG.S15_ARB_PRIORITY {0} \
   CONFIG.S15_HAS_DATA_FIFO {0} \
   CONFIG.S15_HAS_REGSLICE {0} \
   CONFIG.STRATEGY {0} \
   CONFIG.SYNCHRONIZATION_STAGES {3} \
   CONFIG.XBAR_DATA_WIDTH {32} \
 ] $axi_interconnect_hpc0

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.ARUSER_WIDTH {16} \
   CONFIG.AWUSER_WIDTH {16} \
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
   CONFIG.NUM_SLR_CROSSINGS {0} \
   CONFIG.NUM_WRITE_OUTSTANDING {8} \
   CONFIG.NUM_WRITE_THREADS {4} \
   CONFIG.PIPELINES_MASTER_AR {0} \
   CONFIG.PIPELINES_MASTER_AW {0} \
   CONFIG.PIPELINES_MASTER_B {0} \
   CONFIG.PIPELINES_MASTER_R {0} \
   CONFIG.PIPELINES_MASTER_W {0} \
   CONFIG.PIPELINES_MIDDLE_AR {0} \
   CONFIG.PIPELINES_MIDDLE_AW {0} \
   CONFIG.PIPELINES_MIDDLE_B {0} \
   CONFIG.PIPELINES_MIDDLE_R {0} \
   CONFIG.PIPELINES_MIDDLE_W {0} \
   CONFIG.PIPELINES_SLAVE_AR {0} \
   CONFIG.PIPELINES_SLAVE_AW {0} \
   CONFIG.PIPELINES_SLAVE_B {0} \
   CONFIG.PIPELINES_SLAVE_R {0} \
   CONFIG.PIPELINES_SLAVE_W {0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {1} \
   CONFIG.REG_W {1} \
   CONFIG.RESERVE_MODE {0} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.USE_AUTOPIPELINING {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_register_slice_0

  # Create instance: axi_vip_0, and set properties
  set axi_vip_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_ACLKEN {0} \
   CONFIG.HAS_ARESETN {1} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_SIZE {0} \
   CONFIG.HAS_USER_BITS_PER_BYTE {0} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.VIP_PKG_NAME {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_0

  # Create instance: axi_vip_1, and set properties
  set axi_vip_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_ACLKEN {0} \
   CONFIG.HAS_ARESETN {1} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_SIZE {0} \
   CONFIG.HAS_USER_BITS_PER_BYTE {0} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.VIP_PKG_NAME {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_1

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.AUTO_PRIMITIVE {MMCM} \
   CONFIG.AXI_DRP {false} \
   CONFIG.CALC_DONE {empty} \
   CONFIG.CDDCDONE_PORT {cddcdone} \
   CONFIG.CDDCREQ_PORT {cddcreq} \
   CONFIG.CLKFB_IN_N_PORT {clkfb_in_n} \
   CONFIG.CLKFB_IN_PORT {clkfb_in} \
   CONFIG.CLKFB_IN_P_PORT {clkfb_in_p} \
   CONFIG.CLKFB_IN_SIGNALING {SINGLE} \
   CONFIG.CLKFB_OUT_N_PORT {clkfb_out_n} \
   CONFIG.CLKFB_OUT_PORT {clkfb_out} \
   CONFIG.CLKFB_OUT_P_PORT {clkfb_out_p} \
   CONFIG.CLKFB_STOPPED_PORT {clkfb_stopped} \
   CONFIG.CLKIN1_JITTER_PS {100.01} \
   CONFIG.CLKIN1_UI_JITTER {0.010} \
   CONFIG.CLKIN2_JITTER_PS {100.0} \
   CONFIG.CLKIN2_UI_JITTER {0.010} \
   CONFIG.CLKOUT1_DRIVES {Buffer} \
   CONFIG.CLKOUT1_JITTER {107.579} \
   CONFIG.CLKOUT1_MATCHED_ROUTING {false} \
   CONFIG.CLKOUT1_PHASE_ERROR {87.187} \
   CONFIG.CLKOUT1_REQUESTED_DUTY_CYCLE {50.000} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {150} \
   CONFIG.CLKOUT1_REQUESTED_PHASE {0.000} \
   CONFIG.CLKOUT1_SEQUENCE_NUMBER {1} \
   CONFIG.CLKOUT1_USED {true} \
   CONFIG.CLKOUT2_DRIVES {Buffer} \
   CONFIG.CLKOUT2_JITTER {94.872} \
   CONFIG.CLKOUT2_MATCHED_ROUTING {false} \
   CONFIG.CLKOUT2_PHASE_ERROR {87.187} \
   CONFIG.CLKOUT2_REQUESTED_DUTY_CYCLE {50.000} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {300} \
   CONFIG.CLKOUT2_REQUESTED_PHASE {0.000} \
   CONFIG.CLKOUT2_SEQUENCE_NUMBER {1} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_DRIVES {Buffer} \
   CONFIG.CLKOUT3_JITTER {122.171} \
   CONFIG.CLKOUT3_MATCHED_ROUTING {false} \
   CONFIG.CLKOUT3_PHASE_ERROR {87.187} \
   CONFIG.CLKOUT3_REQUESTED_DUTY_CYCLE {50.000} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {75} \
   CONFIG.CLKOUT3_REQUESTED_PHASE {0.000} \
   CONFIG.CLKOUT3_SEQUENCE_NUMBER {1} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_DRIVES {Buffer} \
   CONFIG.CLKOUT4_JITTER {115.843} \
   CONFIG.CLKOUT4_MATCHED_ROUTING {false} \
   CONFIG.CLKOUT4_PHASE_ERROR {87.187} \
   CONFIG.CLKOUT4_REQUESTED_DUTY_CYCLE {50.000} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT4_REQUESTED_PHASE {0.000} \
   CONFIG.CLKOUT4_SEQUENCE_NUMBER {1} \
   CONFIG.CLKOUT4_USED {true} \
   CONFIG.CLKOUT5_DRIVES {Buffer} \
   CONFIG.CLKOUT5_JITTER {102.096} \
   CONFIG.CLKOUT5_MATCHED_ROUTING {false} \
   CONFIG.CLKOUT5_PHASE_ERROR {87.187} \
   CONFIG.CLKOUT5_REQUESTED_DUTY_CYCLE {50.000} \
   CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT5_REQUESTED_PHASE {0.000} \
   CONFIG.CLKOUT5_SEQUENCE_NUMBER {1} \
   CONFIG.CLKOUT5_USED {true} \
   CONFIG.CLKOUT6_DRIVES {Buffer} \
   CONFIG.CLKOUT6_JITTER {90.083} \
   CONFIG.CLKOUT6_MATCHED_ROUTING {false} \
   CONFIG.CLKOUT6_PHASE_ERROR {87.187} \
   CONFIG.CLKOUT6_REQUESTED_DUTY_CYCLE {50.000} \
   CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {400.000} \
   CONFIG.CLKOUT6_REQUESTED_PHASE {0.000} \
   CONFIG.CLKOUT6_SEQUENCE_NUMBER {1} \
   CONFIG.CLKOUT6_USED {true} \
   CONFIG.CLKOUT7_DRIVES {Buffer} \
   CONFIG.CLKOUT7_JITTER {83.777} \
   CONFIG.CLKOUT7_MATCHED_ROUTING {false} \
   CONFIG.CLKOUT7_PHASE_ERROR {87.187} \
   CONFIG.CLKOUT7_REQUESTED_DUTY_CYCLE {50.000} \
   CONFIG.CLKOUT7_REQUESTED_OUT_FREQ {600.000} \
   CONFIG.CLKOUT7_REQUESTED_PHASE {0.000} \
   CONFIG.CLKOUT7_SEQUENCE_NUMBER {1} \
   CONFIG.CLKOUT7_USED {true} \
   CONFIG.CLKOUTPHY_REQUESTED_FREQ {600.000} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {Custom} \
   CONFIG.CLK_IN2_BOARD_INTERFACE {Custom} \
   CONFIG.CLK_IN_SEL_PORT {clk_in_sel} \
   CONFIG.CLK_OUT1_PORT {clk_out1} \
   CONFIG.CLK_OUT1_USE_FINE_PS_GUI {false} \
   CONFIG.CLK_OUT2_PORT {clk_out2} \
   CONFIG.CLK_OUT2_USE_FINE_PS_GUI {false} \
   CONFIG.CLK_OUT3_PORT {clk_out3} \
   CONFIG.CLK_OUT3_USE_FINE_PS_GUI {false} \
   CONFIG.CLK_OUT4_PORT {clk_out4} \
   CONFIG.CLK_OUT4_USE_FINE_PS_GUI {false} \
   CONFIG.CLK_OUT5_PORT {clk_out5} \
   CONFIG.CLK_OUT5_USE_FINE_PS_GUI {false} \
   CONFIG.CLK_OUT6_PORT {clk_out6} \
   CONFIG.CLK_OUT6_USE_FINE_PS_GUI {false} \
   CONFIG.CLK_OUT7_PORT {clk_out7} \
   CONFIG.CLK_OUT7_USE_FINE_PS_GUI {false} \
   CONFIG.CLK_VALID_PORT {CLK_VALID} \
   CONFIG.CLOCK_MGR_TYPE {auto} \
   CONFIG.DADDR_PORT {daddr} \
   CONFIG.DCLK_PORT {dclk} \
   CONFIG.DEN_PORT {den} \
   CONFIG.DIFF_CLK_IN1_BOARD_INTERFACE {Custom} \
   CONFIG.DIFF_CLK_IN2_BOARD_INTERFACE {Custom} \
   CONFIG.DIN_PORT {din} \
   CONFIG.DOUT_PORT {dout} \
   CONFIG.DRDY_PORT {drdy} \
   CONFIG.DWE_PORT {dwe} \
   CONFIG.ENABLE_CDDC {false} \
   CONFIG.ENABLE_CLKOUTPHY {false} \
   CONFIG.ENABLE_CLOCK_MONITOR {false} \
   CONFIG.ENABLE_USER_CLOCK0 {false} \
   CONFIG.ENABLE_USER_CLOCK1 {false} \
   CONFIG.ENABLE_USER_CLOCK2 {false} \
   CONFIG.ENABLE_USER_CLOCK3 {false} \
   CONFIG.Enable_PLL0 {false} \
   CONFIG.Enable_PLL1 {false} \
   CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
   CONFIG.INPUT_CLK_STOPPED_PORT {input_clk_stopped} \
   CONFIG.INPUT_MODE {frequency} \
   CONFIG.INTERFACE_SELECTION {Enable_AXI} \
   CONFIG.IN_FREQ_UNITS {Units_MHz} \
   CONFIG.IN_JITTER_UNITS {Units_UI} \
   CONFIG.JITTER_OPTIONS {UI} \
   CONFIG.JITTER_SEL {No_Jitter} \
   CONFIG.LOCKED_PORT {locked} \
   CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {12.000} \
   CONFIG.MMCM_CLKFBOUT_PHASE {0.000} \
   CONFIG.MMCM_CLKFBOUT_USE_FINE_PS {false} \
   CONFIG.MMCM_CLKIN1_PERIOD {10.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
   CONFIG.MMCM_CLKOUT0_DUTY_CYCLE {0.500} \
   CONFIG.MMCM_CLKOUT0_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT0_USE_FINE_PS {false} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {4} \
   CONFIG.MMCM_CLKOUT1_DUTY_CYCLE {0.500} \
   CONFIG.MMCM_CLKOUT1_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT1_USE_FINE_PS {false} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {16} \
   CONFIG.MMCM_CLKOUT2_DUTY_CYCLE {0.500} \
   CONFIG.MMCM_CLKOUT2_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT2_USE_FINE_PS {false} \
   CONFIG.MMCM_CLKOUT3_DIVIDE {12} \
   CONFIG.MMCM_CLKOUT3_DUTY_CYCLE {0.500} \
   CONFIG.MMCM_CLKOUT3_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT3_USE_FINE_PS {false} \
   CONFIG.MMCM_CLKOUT4_CASCADE {false} \
   CONFIG.MMCM_CLKOUT4_DIVIDE {6} \
   CONFIG.MMCM_CLKOUT4_DUTY_CYCLE {0.500} \
   CONFIG.MMCM_CLKOUT4_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT4_USE_FINE_PS {false} \
   CONFIG.MMCM_CLKOUT5_DIVIDE {3} \
   CONFIG.MMCM_CLKOUT5_DUTY_CYCLE {0.500} \
   CONFIG.MMCM_CLKOUT5_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT5_USE_FINE_PS {false} \
   CONFIG.MMCM_CLKOUT6_DIVIDE {2} \
   CONFIG.MMCM_CLKOUT6_DUTY_CYCLE {0.500} \
   CONFIG.MMCM_CLKOUT6_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT6_USE_FINE_PS {false} \
   CONFIG.MMCM_CLOCK_HOLD {false} \
   CONFIG.MMCM_COMPENSATION {AUTO} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.MMCM_NOTES {None} \
   CONFIG.MMCM_REF_JITTER1 {0.010} \
   CONFIG.MMCM_REF_JITTER2 {0.010} \
   CONFIG.MMCM_STARTUP_WAIT {false} \
   CONFIG.NUM_OUT_CLKS {7} \
   CONFIG.OPTIMIZE_CLOCKING_STRUCTURE_EN {false} \
   CONFIG.OVERRIDE_MMCM {false} \
   CONFIG.OVERRIDE_PLL {false} \
   CONFIG.PHASESHIFT_MODE {LATENCY} \
   CONFIG.PHASE_DUTY_CONFIG {false} \
   CONFIG.PLATFORM {UNKNOWN} \
   CONFIG.PLL_BANDWIDTH {OPTIMIZED} \
   CONFIG.PLL_CLKFBOUT_MULT {4} \
   CONFIG.PLL_CLKFBOUT_PHASE {0.000} \
   CONFIG.PLL_CLKIN_PERIOD {10.000} \
   CONFIG.PLL_CLKOUT0_DIVIDE {1} \
   CONFIG.PLL_CLKOUT0_DUTY_CYCLE {0.500} \
   CONFIG.PLL_CLKOUT0_PHASE {0.000} \
   CONFIG.PLL_CLKOUT1_DIVIDE {1} \
   CONFIG.PLL_CLKOUT1_DUTY_CYCLE {0.500} \
   CONFIG.PLL_CLKOUT1_PHASE {0.000} \
   CONFIG.PLL_CLKOUT2_DIVIDE {1} \
   CONFIG.PLL_CLKOUT2_DUTY_CYCLE {0.500} \
   CONFIG.PLL_CLKOUT2_PHASE {0.000} \
   CONFIG.PLL_CLKOUT3_DIVIDE {1} \
   CONFIG.PLL_CLKOUT3_DUTY_CYCLE {0.500} \
   CONFIG.PLL_CLKOUT3_PHASE {0.000} \
   CONFIG.PLL_CLKOUT4_DIVIDE {1} \
   CONFIG.PLL_CLKOUT4_DUTY_CYCLE {0.500} \
   CONFIG.PLL_CLKOUT4_PHASE {0.000} \
   CONFIG.PLL_CLKOUT5_DIVIDE {1} \
   CONFIG.PLL_CLKOUT5_DUTY_CYCLE {0.500} \
   CONFIG.PLL_CLKOUT5_PHASE {0.000} \
   CONFIG.PLL_CLK_FEEDBACK {CLKFBOUT} \
   CONFIG.PLL_COMPENSATION {SYSTEM_SYNCHRONOUS} \
   CONFIG.PLL_DIVCLK_DIVIDE {1} \
   CONFIG.PLL_NOTES {None} \
   CONFIG.PLL_REF_JITTER {0.010} \
   CONFIG.POWER_DOWN_PORT {power_down} \
   CONFIG.PRECISION {1} \
   CONFIG.PRIMARY_PORT {clk_in1} \
   CONFIG.PRIMITIVE {MMCM} \
   CONFIG.PRIMTYPE_SEL {mmcm_adv} \
   CONFIG.PRIM_IN_FREQ {100.000} \
   CONFIG.PRIM_IN_JITTER {0.010} \
   CONFIG.PRIM_IN_TIMEPERIOD {10.000} \
   CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.PSCLK_PORT {psclk} \
   CONFIG.PSDONE_PORT {psdone} \
   CONFIG.PSEN_PORT {psen} \
   CONFIG.PSINCDEC_PORT {psincdec} \
   CONFIG.REF_CLK_FREQ {100.0} \
   CONFIG.RELATIVE_INCLK {REL_PRIMARY} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.SECONDARY_IN_FREQ {100.000} \
   CONFIG.SECONDARY_IN_JITTER {0.010} \
   CONFIG.SECONDARY_IN_TIMEPERIOD {10.000} \
   CONFIG.SECONDARY_PORT {clk_in2} \
   CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.SS_MODE {CENTER_HIGH} \
   CONFIG.SS_MOD_FREQ {250} \
   CONFIG.SS_MOD_TIME {0.004} \
   CONFIG.STATUS_PORT {STATUS} \
   CONFIG.SUMMARY_STRINGS {empty} \
   CONFIG.USER_CLK_FREQ0 {100.0} \
   CONFIG.USER_CLK_FREQ1 {100.0} \
   CONFIG.USER_CLK_FREQ2 {100.0} \
   CONFIG.USER_CLK_FREQ3 {100.0} \
   CONFIG.USE_BOARD_FLOW {false} \
   CONFIG.USE_CLKFB_STOPPED {false} \
   CONFIG.USE_CLK_VALID {false} \
   CONFIG.USE_CLOCK_SEQUENCING {false} \
   CONFIG.USE_DYN_PHASE_SHIFT {false} \
   CONFIG.USE_DYN_RECONFIG {false} \
   CONFIG.USE_FREEZE {false} \
   CONFIG.USE_FREQ_SYNTH {true} \
   CONFIG.USE_INCLK_STOPPED {false} \
   CONFIG.USE_INCLK_SWITCHOVER {false} \
   CONFIG.USE_LOCKED {true} \
   CONFIG.USE_MAX_I_JITTER {false} \
   CONFIG.USE_MIN_O_JITTER {false} \
   CONFIG.USE_MIN_POWER {false} \
   CONFIG.USE_PHASE_ALIGNMENT {false} \
   CONFIG.USE_POWER_DOWN {false} \
   CONFIG.USE_RESET {true} \
   CONFIG.USE_SAFE_CLOCK_STARTUP {false} \
   CONFIG.USE_SPREAD_SPECTRUM {false} \
   CONFIG.USE_STATUS {false} \
 ] $clk_wiz_0

  # Create instance: interconnect_axifull, and set properties
  set interconnect_axifull [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axifull ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
   CONFIG.ENABLE_PROTOCOL_CHECKERS {0} \
   CONFIG.M00_HAS_DATA_FIFO {0} \
   CONFIG.M00_HAS_REGSLICE {0} \
   CONFIG.M00_ISSUANCE {0} \
   CONFIG.M00_SECURE {0} \
   CONFIG.M01_HAS_DATA_FIFO {0} \
   CONFIG.M01_HAS_REGSLICE {0} \
   CONFIG.M01_ISSUANCE {0} \
   CONFIG.M01_SECURE {0} \
   CONFIG.M02_HAS_DATA_FIFO {0} \
   CONFIG.M02_HAS_REGSLICE {0} \
   CONFIG.M02_ISSUANCE {0} \
   CONFIG.M02_SECURE {0} \
   CONFIG.M03_HAS_DATA_FIFO {0} \
   CONFIG.M03_HAS_REGSLICE {0} \
   CONFIG.M03_ISSUANCE {0} \
   CONFIG.M03_SECURE {0} \
   CONFIG.M04_HAS_DATA_FIFO {0} \
   CONFIG.M04_HAS_REGSLICE {0} \
   CONFIG.M04_ISSUANCE {0} \
   CONFIG.M04_SECURE {0} \
   CONFIG.M05_HAS_DATA_FIFO {0} \
   CONFIG.M05_HAS_REGSLICE {0} \
   CONFIG.M05_ISSUANCE {0} \
   CONFIG.M05_SECURE {0} \
   CONFIG.M06_HAS_DATA_FIFO {0} \
   CONFIG.M06_HAS_REGSLICE {0} \
   CONFIG.M06_ISSUANCE {0} \
   CONFIG.M06_SECURE {0} \
   CONFIG.M07_HAS_DATA_FIFO {0} \
   CONFIG.M07_HAS_REGSLICE {0} \
   CONFIG.M07_ISSUANCE {0} \
   CONFIG.M07_SECURE {0} \
   CONFIG.M08_HAS_DATA_FIFO {0} \
   CONFIG.M08_HAS_REGSLICE {0} \
   CONFIG.M08_ISSUANCE {0} \
   CONFIG.M08_SECURE {0} \
   CONFIG.M09_HAS_DATA_FIFO {0} \
   CONFIG.M09_HAS_REGSLICE {0} \
   CONFIG.M09_ISSUANCE {0} \
   CONFIG.M09_SECURE {0} \
   CONFIG.M10_HAS_DATA_FIFO {0} \
   CONFIG.M10_HAS_REGSLICE {0} \
   CONFIG.M10_ISSUANCE {0} \
   CONFIG.M10_SECURE {0} \
   CONFIG.M11_HAS_DATA_FIFO {0} \
   CONFIG.M11_HAS_REGSLICE {0} \
   CONFIG.M11_ISSUANCE {0} \
   CONFIG.M11_SECURE {0} \
   CONFIG.M12_HAS_DATA_FIFO {0} \
   CONFIG.M12_HAS_REGSLICE {0} \
   CONFIG.M12_ISSUANCE {0} \
   CONFIG.M12_SECURE {0} \
   CONFIG.M13_HAS_DATA_FIFO {0} \
   CONFIG.M13_HAS_REGSLICE {0} \
   CONFIG.M13_ISSUANCE {0} \
   CONFIG.M13_SECURE {0} \
   CONFIG.M14_HAS_DATA_FIFO {0} \
   CONFIG.M14_HAS_REGSLICE {0} \
   CONFIG.M14_ISSUANCE {0} \
   CONFIG.M14_SECURE {0} \
   CONFIG.M15_HAS_DATA_FIFO {0} \
   CONFIG.M15_HAS_REGSLICE {0} \
   CONFIG.M15_ISSUANCE {0} \
   CONFIG.M15_SECURE {0} \
   CONFIG.M16_HAS_DATA_FIFO {0} \
   CONFIG.M16_HAS_REGSLICE {0} \
   CONFIG.M16_ISSUANCE {0} \
   CONFIG.M16_SECURE {0} \
   CONFIG.M17_HAS_DATA_FIFO {0} \
   CONFIG.M17_HAS_REGSLICE {0} \
   CONFIG.M17_ISSUANCE {0} \
   CONFIG.M17_SECURE {0} \
   CONFIG.M18_HAS_DATA_FIFO {0} \
   CONFIG.M18_HAS_REGSLICE {0} \
   CONFIG.M18_ISSUANCE {0} \
   CONFIG.M18_SECURE {0} \
   CONFIG.M19_HAS_DATA_FIFO {0} \
   CONFIG.M19_HAS_REGSLICE {0} \
   CONFIG.M19_ISSUANCE {0} \
   CONFIG.M19_SECURE {0} \
   CONFIG.M20_HAS_DATA_FIFO {0} \
   CONFIG.M20_HAS_REGSLICE {0} \
   CONFIG.M20_ISSUANCE {0} \
   CONFIG.M20_SECURE {0} \
   CONFIG.M21_HAS_DATA_FIFO {0} \
   CONFIG.M21_HAS_REGSLICE {0} \
   CONFIG.M21_ISSUANCE {0} \
   CONFIG.M21_SECURE {0} \
   CONFIG.M22_HAS_DATA_FIFO {0} \
   CONFIG.M22_HAS_REGSLICE {0} \
   CONFIG.M22_ISSUANCE {0} \
   CONFIG.M22_SECURE {0} \
   CONFIG.M23_HAS_DATA_FIFO {0} \
   CONFIG.M23_HAS_REGSLICE {0} \
   CONFIG.M23_ISSUANCE {0} \
   CONFIG.M23_SECURE {0} \
   CONFIG.M24_HAS_DATA_FIFO {0} \
   CONFIG.M24_HAS_REGSLICE {0} \
   CONFIG.M24_ISSUANCE {0} \
   CONFIG.M24_SECURE {0} \
   CONFIG.M25_HAS_DATA_FIFO {0} \
   CONFIG.M25_HAS_REGSLICE {0} \
   CONFIG.M25_ISSUANCE {0} \
   CONFIG.M25_SECURE {0} \
   CONFIG.M26_HAS_DATA_FIFO {0} \
   CONFIG.M26_HAS_REGSLICE {0} \
   CONFIG.M26_ISSUANCE {0} \
   CONFIG.M26_SECURE {0} \
   CONFIG.M27_HAS_DATA_FIFO {0} \
   CONFIG.M27_HAS_REGSLICE {0} \
   CONFIG.M27_ISSUANCE {0} \
   CONFIG.M27_SECURE {0} \
   CONFIG.M28_HAS_DATA_FIFO {0} \
   CONFIG.M28_HAS_REGSLICE {0} \
   CONFIG.M28_ISSUANCE {0} \
   CONFIG.M28_SECURE {0} \
   CONFIG.M29_HAS_DATA_FIFO {0} \
   CONFIG.M29_HAS_REGSLICE {0} \
   CONFIG.M29_ISSUANCE {0} \
   CONFIG.M29_SECURE {0} \
   CONFIG.M30_HAS_DATA_FIFO {0} \
   CONFIG.M30_HAS_REGSLICE {0} \
   CONFIG.M30_ISSUANCE {0} \
   CONFIG.M30_SECURE {0} \
   CONFIG.M31_HAS_DATA_FIFO {0} \
   CONFIG.M31_HAS_REGSLICE {0} \
   CONFIG.M31_ISSUANCE {0} \
   CONFIG.M31_SECURE {0} \
   CONFIG.M32_HAS_DATA_FIFO {0} \
   CONFIG.M32_HAS_REGSLICE {0} \
   CONFIG.M32_ISSUANCE {0} \
   CONFIG.M32_SECURE {0} \
   CONFIG.M33_HAS_DATA_FIFO {0} \
   CONFIG.M33_HAS_REGSLICE {0} \
   CONFIG.M33_ISSUANCE {0} \
   CONFIG.M33_SECURE {0} \
   CONFIG.M34_HAS_DATA_FIFO {0} \
   CONFIG.M34_HAS_REGSLICE {0} \
   CONFIG.M34_ISSUANCE {0} \
   CONFIG.M34_SECURE {0} \
   CONFIG.M35_HAS_DATA_FIFO {0} \
   CONFIG.M35_HAS_REGSLICE {0} \
   CONFIG.M35_ISSUANCE {0} \
   CONFIG.M35_SECURE {0} \
   CONFIG.M36_HAS_DATA_FIFO {0} \
   CONFIG.M36_HAS_REGSLICE {0} \
   CONFIG.M36_ISSUANCE {0} \
   CONFIG.M36_SECURE {0} \
   CONFIG.M37_HAS_DATA_FIFO {0} \
   CONFIG.M37_HAS_REGSLICE {0} \
   CONFIG.M37_ISSUANCE {0} \
   CONFIG.M37_SECURE {0} \
   CONFIG.M38_HAS_DATA_FIFO {0} \
   CONFIG.M38_HAS_REGSLICE {0} \
   CONFIG.M38_ISSUANCE {0} \
   CONFIG.M38_SECURE {0} \
   CONFIG.M39_HAS_DATA_FIFO {0} \
   CONFIG.M39_HAS_REGSLICE {0} \
   CONFIG.M39_ISSUANCE {0} \
   CONFIG.M39_SECURE {0} \
   CONFIG.M40_HAS_DATA_FIFO {0} \
   CONFIG.M40_HAS_REGSLICE {0} \
   CONFIG.M40_ISSUANCE {0} \
   CONFIG.M40_SECURE {0} \
   CONFIG.M41_HAS_DATA_FIFO {0} \
   CONFIG.M41_HAS_REGSLICE {0} \
   CONFIG.M41_ISSUANCE {0} \
   CONFIG.M41_SECURE {0} \
   CONFIG.M42_HAS_DATA_FIFO {0} \
   CONFIG.M42_HAS_REGSLICE {0} \
   CONFIG.M42_ISSUANCE {0} \
   CONFIG.M42_SECURE {0} \
   CONFIG.M43_HAS_DATA_FIFO {0} \
   CONFIG.M43_HAS_REGSLICE {0} \
   CONFIG.M43_ISSUANCE {0} \
   CONFIG.M43_SECURE {0} \
   CONFIG.M44_HAS_DATA_FIFO {0} \
   CONFIG.M44_HAS_REGSLICE {0} \
   CONFIG.M44_ISSUANCE {0} \
   CONFIG.M44_SECURE {0} \
   CONFIG.M45_HAS_DATA_FIFO {0} \
   CONFIG.M45_HAS_REGSLICE {0} \
   CONFIG.M45_ISSUANCE {0} \
   CONFIG.M45_SECURE {0} \
   CONFIG.M46_HAS_DATA_FIFO {0} \
   CONFIG.M46_HAS_REGSLICE {0} \
   CONFIG.M46_ISSUANCE {0} \
   CONFIG.M46_SECURE {0} \
   CONFIG.M47_HAS_DATA_FIFO {0} \
   CONFIG.M47_HAS_REGSLICE {0} \
   CONFIG.M47_ISSUANCE {0} \
   CONFIG.M47_SECURE {0} \
   CONFIG.M48_HAS_DATA_FIFO {0} \
   CONFIG.M48_HAS_REGSLICE {0} \
   CONFIG.M48_ISSUANCE {0} \
   CONFIG.M48_SECURE {0} \
   CONFIG.M49_HAS_DATA_FIFO {0} \
   CONFIG.M49_HAS_REGSLICE {0} \
   CONFIG.M49_ISSUANCE {0} \
   CONFIG.M49_SECURE {0} \
   CONFIG.M50_HAS_DATA_FIFO {0} \
   CONFIG.M50_HAS_REGSLICE {0} \
   CONFIG.M50_ISSUANCE {0} \
   CONFIG.M50_SECURE {0} \
   CONFIG.M51_HAS_DATA_FIFO {0} \
   CONFIG.M51_HAS_REGSLICE {0} \
   CONFIG.M51_ISSUANCE {0} \
   CONFIG.M51_SECURE {0} \
   CONFIG.M52_HAS_DATA_FIFO {0} \
   CONFIG.M52_HAS_REGSLICE {0} \
   CONFIG.M52_ISSUANCE {0} \
   CONFIG.M52_SECURE {0} \
   CONFIG.M53_HAS_DATA_FIFO {0} \
   CONFIG.M53_HAS_REGSLICE {0} \
   CONFIG.M53_ISSUANCE {0} \
   CONFIG.M53_SECURE {0} \
   CONFIG.M54_HAS_DATA_FIFO {0} \
   CONFIG.M54_HAS_REGSLICE {0} \
   CONFIG.M54_ISSUANCE {0} \
   CONFIG.M54_SECURE {0} \
   CONFIG.M55_HAS_DATA_FIFO {0} \
   CONFIG.M55_HAS_REGSLICE {0} \
   CONFIG.M55_ISSUANCE {0} \
   CONFIG.M55_SECURE {0} \
   CONFIG.M56_HAS_DATA_FIFO {0} \
   CONFIG.M56_HAS_REGSLICE {0} \
   CONFIG.M56_ISSUANCE {0} \
   CONFIG.M56_SECURE {0} \
   CONFIG.M57_HAS_DATA_FIFO {0} \
   CONFIG.M57_HAS_REGSLICE {0} \
   CONFIG.M57_ISSUANCE {0} \
   CONFIG.M57_SECURE {0} \
   CONFIG.M58_HAS_DATA_FIFO {0} \
   CONFIG.M58_HAS_REGSLICE {0} \
   CONFIG.M58_ISSUANCE {0} \
   CONFIG.M58_SECURE {0} \
   CONFIG.M59_HAS_DATA_FIFO {0} \
   CONFIG.M59_HAS_REGSLICE {0} \
   CONFIG.M59_ISSUANCE {0} \
   CONFIG.M59_SECURE {0} \
   CONFIG.M60_HAS_DATA_FIFO {0} \
   CONFIG.M60_HAS_REGSLICE {0} \
   CONFIG.M60_ISSUANCE {0} \
   CONFIG.M60_SECURE {0} \
   CONFIG.M61_HAS_DATA_FIFO {0} \
   CONFIG.M61_HAS_REGSLICE {0} \
   CONFIG.M61_ISSUANCE {0} \
   CONFIG.M61_SECURE {0} \
   CONFIG.M62_HAS_DATA_FIFO {0} \
   CONFIG.M62_HAS_REGSLICE {0} \
   CONFIG.M62_ISSUANCE {0} \
   CONFIG.M62_SECURE {0} \
   CONFIG.M63_HAS_DATA_FIFO {0} \
   CONFIG.M63_HAS_REGSLICE {0} \
   CONFIG.M63_ISSUANCE {0} \
   CONFIG.M63_SECURE {0} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
   CONFIG.PCHK_MAX_RD_BURSTS {2} \
   CONFIG.PCHK_MAX_WR_BURSTS {2} \
   CONFIG.PCHK_WAITS {0} \
   CONFIG.S00_ARB_PRIORITY {0} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
   CONFIG.S01_ARB_PRIORITY {0} \
   CONFIG.S01_HAS_DATA_FIFO {0} \
   CONFIG.S01_HAS_REGSLICE {0} \
   CONFIG.S02_ARB_PRIORITY {0} \
   CONFIG.S02_HAS_DATA_FIFO {0} \
   CONFIG.S02_HAS_REGSLICE {0} \
   CONFIG.S03_ARB_PRIORITY {0} \
   CONFIG.S03_HAS_DATA_FIFO {0} \
   CONFIG.S03_HAS_REGSLICE {0} \
   CONFIG.S04_ARB_PRIORITY {0} \
   CONFIG.S04_HAS_DATA_FIFO {0} \
   CONFIG.S04_HAS_REGSLICE {0} \
   CONFIG.S05_ARB_PRIORITY {0} \
   CONFIG.S05_HAS_DATA_FIFO {0} \
   CONFIG.S05_HAS_REGSLICE {0} \
   CONFIG.S06_ARB_PRIORITY {0} \
   CONFIG.S06_HAS_DATA_FIFO {0} \
   CONFIG.S06_HAS_REGSLICE {0} \
   CONFIG.S07_ARB_PRIORITY {0} \
   CONFIG.S07_HAS_DATA_FIFO {0} \
   CONFIG.S07_HAS_REGSLICE {0} \
   CONFIG.S08_ARB_PRIORITY {0} \
   CONFIG.S08_HAS_DATA_FIFO {0} \
   CONFIG.S08_HAS_REGSLICE {0} \
   CONFIG.S09_ARB_PRIORITY {0} \
   CONFIG.S09_HAS_DATA_FIFO {0} \
   CONFIG.S09_HAS_REGSLICE {0} \
   CONFIG.S10_ARB_PRIORITY {0} \
   CONFIG.S10_HAS_DATA_FIFO {0} \
   CONFIG.S10_HAS_REGSLICE {0} \
   CONFIG.S11_ARB_PRIORITY {0} \
   CONFIG.S11_HAS_DATA_FIFO {0} \
   CONFIG.S11_HAS_REGSLICE {0} \
   CONFIG.S12_ARB_PRIORITY {0} \
   CONFIG.S12_HAS_DATA_FIFO {0} \
   CONFIG.S12_HAS_REGSLICE {0} \
   CONFIG.S13_ARB_PRIORITY {0} \
   CONFIG.S13_HAS_DATA_FIFO {0} \
   CONFIG.S13_HAS_REGSLICE {0} \
   CONFIG.S14_ARB_PRIORITY {0} \
   CONFIG.S14_HAS_DATA_FIFO {0} \
   CONFIG.S14_HAS_REGSLICE {0} \
   CONFIG.S15_ARB_PRIORITY {0} \
   CONFIG.S15_HAS_DATA_FIFO {0} \
   CONFIG.S15_HAS_REGSLICE {0} \
   CONFIG.STRATEGY {0} \
   CONFIG.SYNCHRONIZATION_STAGES {3} \
   CONFIG.XBAR_DATA_WIDTH {32} \
 ] $interconnect_axifull

  # Create instance: interconnect_axihpm0fpd, and set properties
  set interconnect_axihpm0fpd [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axihpm0fpd ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
   CONFIG.ENABLE_PROTOCOL_CHECKERS {0} \
   CONFIG.M00_HAS_DATA_FIFO {0} \
   CONFIG.M00_HAS_REGSLICE {0} \
   CONFIG.M00_ISSUANCE {0} \
   CONFIG.M00_SECURE {0} \
   CONFIG.M01_HAS_DATA_FIFO {0} \
   CONFIG.M01_HAS_REGSLICE {0} \
   CONFIG.M01_ISSUANCE {0} \
   CONFIG.M01_SECURE {0} \
   CONFIG.M02_HAS_DATA_FIFO {0} \
   CONFIG.M02_HAS_REGSLICE {0} \
   CONFIG.M02_ISSUANCE {0} \
   CONFIG.M02_SECURE {0} \
   CONFIG.M03_HAS_DATA_FIFO {0} \
   CONFIG.M03_HAS_REGSLICE {0} \
   CONFIG.M03_ISSUANCE {0} \
   CONFIG.M03_SECURE {0} \
   CONFIG.M04_HAS_DATA_FIFO {0} \
   CONFIG.M04_HAS_REGSLICE {0} \
   CONFIG.M04_ISSUANCE {0} \
   CONFIG.M04_SECURE {0} \
   CONFIG.M05_HAS_DATA_FIFO {0} \
   CONFIG.M05_HAS_REGSLICE {0} \
   CONFIG.M05_ISSUANCE {0} \
   CONFIG.M05_SECURE {0} \
   CONFIG.M06_HAS_DATA_FIFO {0} \
   CONFIG.M06_HAS_REGSLICE {0} \
   CONFIG.M06_ISSUANCE {0} \
   CONFIG.M06_SECURE {0} \
   CONFIG.M07_HAS_DATA_FIFO {0} \
   CONFIG.M07_HAS_REGSLICE {0} \
   CONFIG.M07_ISSUANCE {0} \
   CONFIG.M07_SECURE {0} \
   CONFIG.M08_HAS_DATA_FIFO {0} \
   CONFIG.M08_HAS_REGSLICE {0} \
   CONFIG.M08_ISSUANCE {0} \
   CONFIG.M08_SECURE {0} \
   CONFIG.M09_HAS_DATA_FIFO {0} \
   CONFIG.M09_HAS_REGSLICE {0} \
   CONFIG.M09_ISSUANCE {0} \
   CONFIG.M09_SECURE {0} \
   CONFIG.M10_HAS_DATA_FIFO {0} \
   CONFIG.M10_HAS_REGSLICE {0} \
   CONFIG.M10_ISSUANCE {0} \
   CONFIG.M10_SECURE {0} \
   CONFIG.M11_HAS_DATA_FIFO {0} \
   CONFIG.M11_HAS_REGSLICE {0} \
   CONFIG.M11_ISSUANCE {0} \
   CONFIG.M11_SECURE {0} \
   CONFIG.M12_HAS_DATA_FIFO {0} \
   CONFIG.M12_HAS_REGSLICE {0} \
   CONFIG.M12_ISSUANCE {0} \
   CONFIG.M12_SECURE {0} \
   CONFIG.M13_HAS_DATA_FIFO {0} \
   CONFIG.M13_HAS_REGSLICE {0} \
   CONFIG.M13_ISSUANCE {0} \
   CONFIG.M13_SECURE {0} \
   CONFIG.M14_HAS_DATA_FIFO {0} \
   CONFIG.M14_HAS_REGSLICE {0} \
   CONFIG.M14_ISSUANCE {0} \
   CONFIG.M14_SECURE {0} \
   CONFIG.M15_HAS_DATA_FIFO {0} \
   CONFIG.M15_HAS_REGSLICE {0} \
   CONFIG.M15_ISSUANCE {0} \
   CONFIG.M15_SECURE {0} \
   CONFIG.M16_HAS_DATA_FIFO {0} \
   CONFIG.M16_HAS_REGSLICE {0} \
   CONFIG.M16_ISSUANCE {0} \
   CONFIG.M16_SECURE {0} \
   CONFIG.M17_HAS_DATA_FIFO {0} \
   CONFIG.M17_HAS_REGSLICE {0} \
   CONFIG.M17_ISSUANCE {0} \
   CONFIG.M17_SECURE {0} \
   CONFIG.M18_HAS_DATA_FIFO {0} \
   CONFIG.M18_HAS_REGSLICE {0} \
   CONFIG.M18_ISSUANCE {0} \
   CONFIG.M18_SECURE {0} \
   CONFIG.M19_HAS_DATA_FIFO {0} \
   CONFIG.M19_HAS_REGSLICE {0} \
   CONFIG.M19_ISSUANCE {0} \
   CONFIG.M19_SECURE {0} \
   CONFIG.M20_HAS_DATA_FIFO {0} \
   CONFIG.M20_HAS_REGSLICE {0} \
   CONFIG.M20_ISSUANCE {0} \
   CONFIG.M20_SECURE {0} \
   CONFIG.M21_HAS_DATA_FIFO {0} \
   CONFIG.M21_HAS_REGSLICE {0} \
   CONFIG.M21_ISSUANCE {0} \
   CONFIG.M21_SECURE {0} \
   CONFIG.M22_HAS_DATA_FIFO {0} \
   CONFIG.M22_HAS_REGSLICE {0} \
   CONFIG.M22_ISSUANCE {0} \
   CONFIG.M22_SECURE {0} \
   CONFIG.M23_HAS_DATA_FIFO {0} \
   CONFIG.M23_HAS_REGSLICE {0} \
   CONFIG.M23_ISSUANCE {0} \
   CONFIG.M23_SECURE {0} \
   CONFIG.M24_HAS_DATA_FIFO {0} \
   CONFIG.M24_HAS_REGSLICE {0} \
   CONFIG.M24_ISSUANCE {0} \
   CONFIG.M24_SECURE {0} \
   CONFIG.M25_HAS_DATA_FIFO {0} \
   CONFIG.M25_HAS_REGSLICE {0} \
   CONFIG.M25_ISSUANCE {0} \
   CONFIG.M25_SECURE {0} \
   CONFIG.M26_HAS_DATA_FIFO {0} \
   CONFIG.M26_HAS_REGSLICE {0} \
   CONFIG.M26_ISSUANCE {0} \
   CONFIG.M26_SECURE {0} \
   CONFIG.M27_HAS_DATA_FIFO {0} \
   CONFIG.M27_HAS_REGSLICE {0} \
   CONFIG.M27_ISSUANCE {0} \
   CONFIG.M27_SECURE {0} \
   CONFIG.M28_HAS_DATA_FIFO {0} \
   CONFIG.M28_HAS_REGSLICE {0} \
   CONFIG.M28_ISSUANCE {0} \
   CONFIG.M28_SECURE {0} \
   CONFIG.M29_HAS_DATA_FIFO {0} \
   CONFIG.M29_HAS_REGSLICE {0} \
   CONFIG.M29_ISSUANCE {0} \
   CONFIG.M29_SECURE {0} \
   CONFIG.M30_HAS_DATA_FIFO {0} \
   CONFIG.M30_HAS_REGSLICE {0} \
   CONFIG.M30_ISSUANCE {0} \
   CONFIG.M30_SECURE {0} \
   CONFIG.M31_HAS_DATA_FIFO {0} \
   CONFIG.M31_HAS_REGSLICE {0} \
   CONFIG.M31_ISSUANCE {0} \
   CONFIG.M31_SECURE {0} \
   CONFIG.M32_HAS_DATA_FIFO {0} \
   CONFIG.M32_HAS_REGSLICE {0} \
   CONFIG.M32_ISSUANCE {0} \
   CONFIG.M32_SECURE {0} \
   CONFIG.M33_HAS_DATA_FIFO {0} \
   CONFIG.M33_HAS_REGSLICE {0} \
   CONFIG.M33_ISSUANCE {0} \
   CONFIG.M33_SECURE {0} \
   CONFIG.M34_HAS_DATA_FIFO {0} \
   CONFIG.M34_HAS_REGSLICE {0} \
   CONFIG.M34_ISSUANCE {0} \
   CONFIG.M34_SECURE {0} \
   CONFIG.M35_HAS_DATA_FIFO {0} \
   CONFIG.M35_HAS_REGSLICE {0} \
   CONFIG.M35_ISSUANCE {0} \
   CONFIG.M35_SECURE {0} \
   CONFIG.M36_HAS_DATA_FIFO {0} \
   CONFIG.M36_HAS_REGSLICE {0} \
   CONFIG.M36_ISSUANCE {0} \
   CONFIG.M36_SECURE {0} \
   CONFIG.M37_HAS_DATA_FIFO {0} \
   CONFIG.M37_HAS_REGSLICE {0} \
   CONFIG.M37_ISSUANCE {0} \
   CONFIG.M37_SECURE {0} \
   CONFIG.M38_HAS_DATA_FIFO {0} \
   CONFIG.M38_HAS_REGSLICE {0} \
   CONFIG.M38_ISSUANCE {0} \
   CONFIG.M38_SECURE {0} \
   CONFIG.M39_HAS_DATA_FIFO {0} \
   CONFIG.M39_HAS_REGSLICE {0} \
   CONFIG.M39_ISSUANCE {0} \
   CONFIG.M39_SECURE {0} \
   CONFIG.M40_HAS_DATA_FIFO {0} \
   CONFIG.M40_HAS_REGSLICE {0} \
   CONFIG.M40_ISSUANCE {0} \
   CONFIG.M40_SECURE {0} \
   CONFIG.M41_HAS_DATA_FIFO {0} \
   CONFIG.M41_HAS_REGSLICE {0} \
   CONFIG.M41_ISSUANCE {0} \
   CONFIG.M41_SECURE {0} \
   CONFIG.M42_HAS_DATA_FIFO {0} \
   CONFIG.M42_HAS_REGSLICE {0} \
   CONFIG.M42_ISSUANCE {0} \
   CONFIG.M42_SECURE {0} \
   CONFIG.M43_HAS_DATA_FIFO {0} \
   CONFIG.M43_HAS_REGSLICE {0} \
   CONFIG.M43_ISSUANCE {0} \
   CONFIG.M43_SECURE {0} \
   CONFIG.M44_HAS_DATA_FIFO {0} \
   CONFIG.M44_HAS_REGSLICE {0} \
   CONFIG.M44_ISSUANCE {0} \
   CONFIG.M44_SECURE {0} \
   CONFIG.M45_HAS_DATA_FIFO {0} \
   CONFIG.M45_HAS_REGSLICE {0} \
   CONFIG.M45_ISSUANCE {0} \
   CONFIG.M45_SECURE {0} \
   CONFIG.M46_HAS_DATA_FIFO {0} \
   CONFIG.M46_HAS_REGSLICE {0} \
   CONFIG.M46_ISSUANCE {0} \
   CONFIG.M46_SECURE {0} \
   CONFIG.M47_HAS_DATA_FIFO {0} \
   CONFIG.M47_HAS_REGSLICE {0} \
   CONFIG.M47_ISSUANCE {0} \
   CONFIG.M47_SECURE {0} \
   CONFIG.M48_HAS_DATA_FIFO {0} \
   CONFIG.M48_HAS_REGSLICE {0} \
   CONFIG.M48_ISSUANCE {0} \
   CONFIG.M48_SECURE {0} \
   CONFIG.M49_HAS_DATA_FIFO {0} \
   CONFIG.M49_HAS_REGSLICE {0} \
   CONFIG.M49_ISSUANCE {0} \
   CONFIG.M49_SECURE {0} \
   CONFIG.M50_HAS_DATA_FIFO {0} \
   CONFIG.M50_HAS_REGSLICE {0} \
   CONFIG.M50_ISSUANCE {0} \
   CONFIG.M50_SECURE {0} \
   CONFIG.M51_HAS_DATA_FIFO {0} \
   CONFIG.M51_HAS_REGSLICE {0} \
   CONFIG.M51_ISSUANCE {0} \
   CONFIG.M51_SECURE {0} \
   CONFIG.M52_HAS_DATA_FIFO {0} \
   CONFIG.M52_HAS_REGSLICE {0} \
   CONFIG.M52_ISSUANCE {0} \
   CONFIG.M52_SECURE {0} \
   CONFIG.M53_HAS_DATA_FIFO {0} \
   CONFIG.M53_HAS_REGSLICE {0} \
   CONFIG.M53_ISSUANCE {0} \
   CONFIG.M53_SECURE {0} \
   CONFIG.M54_HAS_DATA_FIFO {0} \
   CONFIG.M54_HAS_REGSLICE {0} \
   CONFIG.M54_ISSUANCE {0} \
   CONFIG.M54_SECURE {0} \
   CONFIG.M55_HAS_DATA_FIFO {0} \
   CONFIG.M55_HAS_REGSLICE {0} \
   CONFIG.M55_ISSUANCE {0} \
   CONFIG.M55_SECURE {0} \
   CONFIG.M56_HAS_DATA_FIFO {0} \
   CONFIG.M56_HAS_REGSLICE {0} \
   CONFIG.M56_ISSUANCE {0} \
   CONFIG.M56_SECURE {0} \
   CONFIG.M57_HAS_DATA_FIFO {0} \
   CONFIG.M57_HAS_REGSLICE {0} \
   CONFIG.M57_ISSUANCE {0} \
   CONFIG.M57_SECURE {0} \
   CONFIG.M58_HAS_DATA_FIFO {0} \
   CONFIG.M58_HAS_REGSLICE {0} \
   CONFIG.M58_ISSUANCE {0} \
   CONFIG.M58_SECURE {0} \
   CONFIG.M59_HAS_DATA_FIFO {0} \
   CONFIG.M59_HAS_REGSLICE {0} \
   CONFIG.M59_ISSUANCE {0} \
   CONFIG.M59_SECURE {0} \
   CONFIG.M60_HAS_DATA_FIFO {0} \
   CONFIG.M60_HAS_REGSLICE {0} \
   CONFIG.M60_ISSUANCE {0} \
   CONFIG.M60_SECURE {0} \
   CONFIG.M61_HAS_DATA_FIFO {0} \
   CONFIG.M61_HAS_REGSLICE {0} \
   CONFIG.M61_ISSUANCE {0} \
   CONFIG.M61_SECURE {0} \
   CONFIG.M62_HAS_DATA_FIFO {0} \
   CONFIG.M62_HAS_REGSLICE {0} \
   CONFIG.M62_ISSUANCE {0} \
   CONFIG.M62_SECURE {0} \
   CONFIG.M63_HAS_DATA_FIFO {0} \
   CONFIG.M63_HAS_REGSLICE {0} \
   CONFIG.M63_ISSUANCE {0} \
   CONFIG.M63_SECURE {0} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
   CONFIG.PCHK_MAX_RD_BURSTS {2} \
   CONFIG.PCHK_MAX_WR_BURSTS {2} \
   CONFIG.PCHK_WAITS {0} \
   CONFIG.S00_ARB_PRIORITY {0} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
   CONFIG.S01_ARB_PRIORITY {0} \
   CONFIG.S01_HAS_DATA_FIFO {0} \
   CONFIG.S01_HAS_REGSLICE {0} \
   CONFIG.S02_ARB_PRIORITY {0} \
   CONFIG.S02_HAS_DATA_FIFO {0} \
   CONFIG.S02_HAS_REGSLICE {0} \
   CONFIG.S03_ARB_PRIORITY {0} \
   CONFIG.S03_HAS_DATA_FIFO {0} \
   CONFIG.S03_HAS_REGSLICE {0} \
   CONFIG.S04_ARB_PRIORITY {0} \
   CONFIG.S04_HAS_DATA_FIFO {0} \
   CONFIG.S04_HAS_REGSLICE {0} \
   CONFIG.S05_ARB_PRIORITY {0} \
   CONFIG.S05_HAS_DATA_FIFO {0} \
   CONFIG.S05_HAS_REGSLICE {0} \
   CONFIG.S06_ARB_PRIORITY {0} \
   CONFIG.S06_HAS_DATA_FIFO {0} \
   CONFIG.S06_HAS_REGSLICE {0} \
   CONFIG.S07_ARB_PRIORITY {0} \
   CONFIG.S07_HAS_DATA_FIFO {0} \
   CONFIG.S07_HAS_REGSLICE {0} \
   CONFIG.S08_ARB_PRIORITY {0} \
   CONFIG.S08_HAS_DATA_FIFO {0} \
   CONFIG.S08_HAS_REGSLICE {0} \
   CONFIG.S09_ARB_PRIORITY {0} \
   CONFIG.S09_HAS_DATA_FIFO {0} \
   CONFIG.S09_HAS_REGSLICE {0} \
   CONFIG.S10_ARB_PRIORITY {0} \
   CONFIG.S10_HAS_DATA_FIFO {0} \
   CONFIG.S10_HAS_REGSLICE {0} \
   CONFIG.S11_ARB_PRIORITY {0} \
   CONFIG.S11_HAS_DATA_FIFO {0} \
   CONFIG.S11_HAS_REGSLICE {0} \
   CONFIG.S12_ARB_PRIORITY {0} \
   CONFIG.S12_HAS_DATA_FIFO {0} \
   CONFIG.S12_HAS_REGSLICE {0} \
   CONFIG.S13_ARB_PRIORITY {0} \
   CONFIG.S13_HAS_DATA_FIFO {0} \
   CONFIG.S13_HAS_REGSLICE {0} \
   CONFIG.S14_ARB_PRIORITY {0} \
   CONFIG.S14_HAS_DATA_FIFO {0} \
   CONFIG.S14_HAS_REGSLICE {0} \
   CONFIG.S15_ARB_PRIORITY {0} \
   CONFIG.S15_HAS_DATA_FIFO {0} \
   CONFIG.S15_HAS_REGSLICE {0} \
   CONFIG.STRATEGY {0} \
   CONFIG.SYNCHRONIZATION_STAGES {3} \
   CONFIG.XBAR_DATA_WIDTH {32} \
 ] $interconnect_axihpm0fpd

  # Create instance: interconnect_axilite, and set properties
  set interconnect_axilite [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axilite ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
   CONFIG.ENABLE_PROTOCOL_CHECKERS {0} \
   CONFIG.M00_HAS_DATA_FIFO {0} \
   CONFIG.M00_HAS_REGSLICE {0} \
   CONFIG.M00_ISSUANCE {0} \
   CONFIG.M00_SECURE {0} \
   CONFIG.M01_HAS_DATA_FIFO {0} \
   CONFIG.M01_HAS_REGSLICE {1} \
   CONFIG.M01_ISSUANCE {0} \
   CONFIG.M01_SECURE {0} \
   CONFIG.M02_HAS_DATA_FIFO {0} \
   CONFIG.M02_HAS_REGSLICE {0} \
   CONFIG.M02_ISSUANCE {0} \
   CONFIG.M02_SECURE {0} \
   CONFIG.M03_HAS_DATA_FIFO {0} \
   CONFIG.M03_HAS_REGSLICE {0} \
   CONFIG.M03_ISSUANCE {0} \
   CONFIG.M03_SECURE {0} \
   CONFIG.M04_HAS_DATA_FIFO {0} \
   CONFIG.M04_HAS_REGSLICE {0} \
   CONFIG.M04_ISSUANCE {0} \
   CONFIG.M04_SECURE {0} \
   CONFIG.M05_HAS_DATA_FIFO {0} \
   CONFIG.M05_HAS_REGSLICE {0} \
   CONFIG.M05_ISSUANCE {0} \
   CONFIG.M05_SECURE {0} \
   CONFIG.M06_HAS_DATA_FIFO {0} \
   CONFIG.M06_HAS_REGSLICE {0} \
   CONFIG.M06_ISSUANCE {0} \
   CONFIG.M06_SECURE {0} \
   CONFIG.M07_HAS_DATA_FIFO {0} \
   CONFIG.M07_HAS_REGSLICE {0} \
   CONFIG.M07_ISSUANCE {0} \
   CONFIG.M07_SECURE {0} \
   CONFIG.M08_HAS_DATA_FIFO {0} \
   CONFIG.M08_HAS_REGSLICE {0} \
   CONFIG.M08_ISSUANCE {0} \
   CONFIG.M08_SECURE {0} \
   CONFIG.M09_HAS_DATA_FIFO {0} \
   CONFIG.M09_HAS_REGSLICE {0} \
   CONFIG.M09_ISSUANCE {0} \
   CONFIG.M09_SECURE {0} \
   CONFIG.M10_HAS_DATA_FIFO {0} \
   CONFIG.M10_HAS_REGSLICE {0} \
   CONFIG.M10_ISSUANCE {0} \
   CONFIG.M10_SECURE {0} \
   CONFIG.M11_HAS_DATA_FIFO {0} \
   CONFIG.M11_HAS_REGSLICE {0} \
   CONFIG.M11_ISSUANCE {0} \
   CONFIG.M11_SECURE {0} \
   CONFIG.M12_HAS_DATA_FIFO {0} \
   CONFIG.M12_HAS_REGSLICE {0} \
   CONFIG.M12_ISSUANCE {0} \
   CONFIG.M12_SECURE {0} \
   CONFIG.M13_HAS_DATA_FIFO {0} \
   CONFIG.M13_HAS_REGSLICE {0} \
   CONFIG.M13_ISSUANCE {0} \
   CONFIG.M13_SECURE {0} \
   CONFIG.M14_HAS_DATA_FIFO {0} \
   CONFIG.M14_HAS_REGSLICE {0} \
   CONFIG.M14_ISSUANCE {0} \
   CONFIG.M14_SECURE {0} \
   CONFIG.M15_HAS_DATA_FIFO {0} \
   CONFIG.M15_HAS_REGSLICE {0} \
   CONFIG.M15_ISSUANCE {0} \
   CONFIG.M15_SECURE {0} \
   CONFIG.M16_HAS_DATA_FIFO {0} \
   CONFIG.M16_HAS_REGSLICE {0} \
   CONFIG.M16_ISSUANCE {0} \
   CONFIG.M16_SECURE {0} \
   CONFIG.M17_HAS_DATA_FIFO {0} \
   CONFIG.M17_HAS_REGSLICE {0} \
   CONFIG.M17_ISSUANCE {0} \
   CONFIG.M17_SECURE {0} \
   CONFIG.M18_HAS_DATA_FIFO {0} \
   CONFIG.M18_HAS_REGSLICE {0} \
   CONFIG.M18_ISSUANCE {0} \
   CONFIG.M18_SECURE {0} \
   CONFIG.M19_HAS_DATA_FIFO {0} \
   CONFIG.M19_HAS_REGSLICE {0} \
   CONFIG.M19_ISSUANCE {0} \
   CONFIG.M19_SECURE {0} \
   CONFIG.M20_HAS_DATA_FIFO {0} \
   CONFIG.M20_HAS_REGSLICE {0} \
   CONFIG.M20_ISSUANCE {0} \
   CONFIG.M20_SECURE {0} \
   CONFIG.M21_HAS_DATA_FIFO {0} \
   CONFIG.M21_HAS_REGSLICE {0} \
   CONFIG.M21_ISSUANCE {0} \
   CONFIG.M21_SECURE {0} \
   CONFIG.M22_HAS_DATA_FIFO {0} \
   CONFIG.M22_HAS_REGSLICE {0} \
   CONFIG.M22_ISSUANCE {0} \
   CONFIG.M22_SECURE {0} \
   CONFIG.M23_HAS_DATA_FIFO {0} \
   CONFIG.M23_HAS_REGSLICE {0} \
   CONFIG.M23_ISSUANCE {0} \
   CONFIG.M23_SECURE {0} \
   CONFIG.M24_HAS_DATA_FIFO {0} \
   CONFIG.M24_HAS_REGSLICE {0} \
   CONFIG.M24_ISSUANCE {0} \
   CONFIG.M24_SECURE {0} \
   CONFIG.M25_HAS_DATA_FIFO {0} \
   CONFIG.M25_HAS_REGSLICE {0} \
   CONFIG.M25_ISSUANCE {0} \
   CONFIG.M25_SECURE {0} \
   CONFIG.M26_HAS_DATA_FIFO {0} \
   CONFIG.M26_HAS_REGSLICE {0} \
   CONFIG.M26_ISSUANCE {0} \
   CONFIG.M26_SECURE {0} \
   CONFIG.M27_HAS_DATA_FIFO {0} \
   CONFIG.M27_HAS_REGSLICE {0} \
   CONFIG.M27_ISSUANCE {0} \
   CONFIG.M27_SECURE {0} \
   CONFIG.M28_HAS_DATA_FIFO {0} \
   CONFIG.M28_HAS_REGSLICE {0} \
   CONFIG.M28_ISSUANCE {0} \
   CONFIG.M28_SECURE {0} \
   CONFIG.M29_HAS_DATA_FIFO {0} \
   CONFIG.M29_HAS_REGSLICE {0} \
   CONFIG.M29_ISSUANCE {0} \
   CONFIG.M29_SECURE {0} \
   CONFIG.M30_HAS_DATA_FIFO {0} \
   CONFIG.M30_HAS_REGSLICE {0} \
   CONFIG.M30_ISSUANCE {0} \
   CONFIG.M30_SECURE {0} \
   CONFIG.M31_HAS_DATA_FIFO {0} \
   CONFIG.M31_HAS_REGSLICE {0} \
   CONFIG.M31_ISSUANCE {0} \
   CONFIG.M31_SECURE {0} \
   CONFIG.M32_HAS_DATA_FIFO {0} \
   CONFIG.M32_HAS_REGSLICE {0} \
   CONFIG.M32_ISSUANCE {0} \
   CONFIG.M32_SECURE {0} \
   CONFIG.M33_HAS_DATA_FIFO {0} \
   CONFIG.M33_HAS_REGSLICE {0} \
   CONFIG.M33_ISSUANCE {0} \
   CONFIG.M33_SECURE {0} \
   CONFIG.M34_HAS_DATA_FIFO {0} \
   CONFIG.M34_HAS_REGSLICE {0} \
   CONFIG.M34_ISSUANCE {0} \
   CONFIG.M34_SECURE {0} \
   CONFIG.M35_HAS_DATA_FIFO {0} \
   CONFIG.M35_HAS_REGSLICE {0} \
   CONFIG.M35_ISSUANCE {0} \
   CONFIG.M35_SECURE {0} \
   CONFIG.M36_HAS_DATA_FIFO {0} \
   CONFIG.M36_HAS_REGSLICE {0} \
   CONFIG.M36_ISSUANCE {0} \
   CONFIG.M36_SECURE {0} \
   CONFIG.M37_HAS_DATA_FIFO {0} \
   CONFIG.M37_HAS_REGSLICE {0} \
   CONFIG.M37_ISSUANCE {0} \
   CONFIG.M37_SECURE {0} \
   CONFIG.M38_HAS_DATA_FIFO {0} \
   CONFIG.M38_HAS_REGSLICE {0} \
   CONFIG.M38_ISSUANCE {0} \
   CONFIG.M38_SECURE {0} \
   CONFIG.M39_HAS_DATA_FIFO {0} \
   CONFIG.M39_HAS_REGSLICE {0} \
   CONFIG.M39_ISSUANCE {0} \
   CONFIG.M39_SECURE {0} \
   CONFIG.M40_HAS_DATA_FIFO {0} \
   CONFIG.M40_HAS_REGSLICE {0} \
   CONFIG.M40_ISSUANCE {0} \
   CONFIG.M40_SECURE {0} \
   CONFIG.M41_HAS_DATA_FIFO {0} \
   CONFIG.M41_HAS_REGSLICE {0} \
   CONFIG.M41_ISSUANCE {0} \
   CONFIG.M41_SECURE {0} \
   CONFIG.M42_HAS_DATA_FIFO {0} \
   CONFIG.M42_HAS_REGSLICE {0} \
   CONFIG.M42_ISSUANCE {0} \
   CONFIG.M42_SECURE {0} \
   CONFIG.M43_HAS_DATA_FIFO {0} \
   CONFIG.M43_HAS_REGSLICE {0} \
   CONFIG.M43_ISSUANCE {0} \
   CONFIG.M43_SECURE {0} \
   CONFIG.M44_HAS_DATA_FIFO {0} \
   CONFIG.M44_HAS_REGSLICE {0} \
   CONFIG.M44_ISSUANCE {0} \
   CONFIG.M44_SECURE {0} \
   CONFIG.M45_HAS_DATA_FIFO {0} \
   CONFIG.M45_HAS_REGSLICE {0} \
   CONFIG.M45_ISSUANCE {0} \
   CONFIG.M45_SECURE {0} \
   CONFIG.M46_HAS_DATA_FIFO {0} \
   CONFIG.M46_HAS_REGSLICE {0} \
   CONFIG.M46_ISSUANCE {0} \
   CONFIG.M46_SECURE {0} \
   CONFIG.M47_HAS_DATA_FIFO {0} \
   CONFIG.M47_HAS_REGSLICE {0} \
   CONFIG.M47_ISSUANCE {0} \
   CONFIG.M47_SECURE {0} \
   CONFIG.M48_HAS_DATA_FIFO {0} \
   CONFIG.M48_HAS_REGSLICE {0} \
   CONFIG.M48_ISSUANCE {0} \
   CONFIG.M48_SECURE {0} \
   CONFIG.M49_HAS_DATA_FIFO {0} \
   CONFIG.M49_HAS_REGSLICE {0} \
   CONFIG.M49_ISSUANCE {0} \
   CONFIG.M49_SECURE {0} \
   CONFIG.M50_HAS_DATA_FIFO {0} \
   CONFIG.M50_HAS_REGSLICE {0} \
   CONFIG.M50_ISSUANCE {0} \
   CONFIG.M50_SECURE {0} \
   CONFIG.M51_HAS_DATA_FIFO {0} \
   CONFIG.M51_HAS_REGSLICE {0} \
   CONFIG.M51_ISSUANCE {0} \
   CONFIG.M51_SECURE {0} \
   CONFIG.M52_HAS_DATA_FIFO {0} \
   CONFIG.M52_HAS_REGSLICE {0} \
   CONFIG.M52_ISSUANCE {0} \
   CONFIG.M52_SECURE {0} \
   CONFIG.M53_HAS_DATA_FIFO {0} \
   CONFIG.M53_HAS_REGSLICE {0} \
   CONFIG.M53_ISSUANCE {0} \
   CONFIG.M53_SECURE {0} \
   CONFIG.M54_HAS_DATA_FIFO {0} \
   CONFIG.M54_HAS_REGSLICE {0} \
   CONFIG.M54_ISSUANCE {0} \
   CONFIG.M54_SECURE {0} \
   CONFIG.M55_HAS_DATA_FIFO {0} \
   CONFIG.M55_HAS_REGSLICE {0} \
   CONFIG.M55_ISSUANCE {0} \
   CONFIG.M55_SECURE {0} \
   CONFIG.M56_HAS_DATA_FIFO {0} \
   CONFIG.M56_HAS_REGSLICE {0} \
   CONFIG.M56_ISSUANCE {0} \
   CONFIG.M56_SECURE {0} \
   CONFIG.M57_HAS_DATA_FIFO {0} \
   CONFIG.M57_HAS_REGSLICE {0} \
   CONFIG.M57_ISSUANCE {0} \
   CONFIG.M57_SECURE {0} \
   CONFIG.M58_HAS_DATA_FIFO {0} \
   CONFIG.M58_HAS_REGSLICE {0} \
   CONFIG.M58_ISSUANCE {0} \
   CONFIG.M58_SECURE {0} \
   CONFIG.M59_HAS_DATA_FIFO {0} \
   CONFIG.M59_HAS_REGSLICE {0} \
   CONFIG.M59_ISSUANCE {0} \
   CONFIG.M59_SECURE {0} \
   CONFIG.M60_HAS_DATA_FIFO {0} \
   CONFIG.M60_HAS_REGSLICE {0} \
   CONFIG.M60_ISSUANCE {0} \
   CONFIG.M60_SECURE {0} \
   CONFIG.M61_HAS_DATA_FIFO {0} \
   CONFIG.M61_HAS_REGSLICE {0} \
   CONFIG.M61_ISSUANCE {0} \
   CONFIG.M61_SECURE {0} \
   CONFIG.M62_HAS_DATA_FIFO {0} \
   CONFIG.M62_HAS_REGSLICE {0} \
   CONFIG.M62_ISSUANCE {0} \
   CONFIG.M62_SECURE {0} \
   CONFIG.M63_HAS_DATA_FIFO {0} \
   CONFIG.M63_HAS_REGSLICE {0} \
   CONFIG.M63_ISSUANCE {0} \
   CONFIG.M63_SECURE {0} \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
   CONFIG.PCHK_MAX_RD_BURSTS {2} \
   CONFIG.PCHK_MAX_WR_BURSTS {2} \
   CONFIG.PCHK_WAITS {0} \
   CONFIG.S00_ARB_PRIORITY {0} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
   CONFIG.S01_ARB_PRIORITY {0} \
   CONFIG.S01_HAS_DATA_FIFO {0} \
   CONFIG.S01_HAS_REGSLICE {0} \
   CONFIG.S02_ARB_PRIORITY {0} \
   CONFIG.S02_HAS_DATA_FIFO {0} \
   CONFIG.S02_HAS_REGSLICE {0} \
   CONFIG.S03_ARB_PRIORITY {0} \
   CONFIG.S03_HAS_DATA_FIFO {0} \
   CONFIG.S03_HAS_REGSLICE {0} \
   CONFIG.S04_ARB_PRIORITY {0} \
   CONFIG.S04_HAS_DATA_FIFO {0} \
   CONFIG.S04_HAS_REGSLICE {0} \
   CONFIG.S05_ARB_PRIORITY {0} \
   CONFIG.S05_HAS_DATA_FIFO {0} \
   CONFIG.S05_HAS_REGSLICE {0} \
   CONFIG.S06_ARB_PRIORITY {0} \
   CONFIG.S06_HAS_DATA_FIFO {0} \
   CONFIG.S06_HAS_REGSLICE {0} \
   CONFIG.S07_ARB_PRIORITY {0} \
   CONFIG.S07_HAS_DATA_FIFO {0} \
   CONFIG.S07_HAS_REGSLICE {0} \
   CONFIG.S08_ARB_PRIORITY {0} \
   CONFIG.S08_HAS_DATA_FIFO {0} \
   CONFIG.S08_HAS_REGSLICE {0} \
   CONFIG.S09_ARB_PRIORITY {0} \
   CONFIG.S09_HAS_DATA_FIFO {0} \
   CONFIG.S09_HAS_REGSLICE {0} \
   CONFIG.S10_ARB_PRIORITY {0} \
   CONFIG.S10_HAS_DATA_FIFO {0} \
   CONFIG.S10_HAS_REGSLICE {0} \
   CONFIG.S11_ARB_PRIORITY {0} \
   CONFIG.S11_HAS_DATA_FIFO {0} \
   CONFIG.S11_HAS_REGSLICE {0} \
   CONFIG.S12_ARB_PRIORITY {0} \
   CONFIG.S12_HAS_DATA_FIFO {0} \
   CONFIG.S12_HAS_REGSLICE {0} \
   CONFIG.S13_ARB_PRIORITY {0} \
   CONFIG.S13_HAS_DATA_FIFO {0} \
   CONFIG.S13_HAS_REGSLICE {0} \
   CONFIG.S14_ARB_PRIORITY {0} \
   CONFIG.S14_HAS_DATA_FIFO {0} \
   CONFIG.S14_HAS_REGSLICE {0} \
   CONFIG.S15_ARB_PRIORITY {0} \
   CONFIG.S15_HAS_DATA_FIFO {0} \
   CONFIG.S15_HAS_REGSLICE {0} \
   CONFIG.STRATEGY {0} \
   CONFIG.SYNCHRONIZATION_STAGES {3} \
   CONFIG.XBAR_DATA_WIDTH {32} \
 ] $interconnect_axilite

  # Create instance: irq_const_tieoff, and set properties
  set irq_const_tieoff [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 irq_const_tieoff ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {1} \
 ] $irq_const_tieoff

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
   CONFIG.C_AUX_RST_WIDTH {4} \
   CONFIG.C_EXT_RST_WIDTH {4} \
   CONFIG.C_NUM_BUS_RST {1} \
   CONFIG.C_NUM_INTERCONNECT_ARESETN {1} \
   CONFIG.C_NUM_PERP_ARESETN {1} \
   CONFIG.C_NUM_PERP_RST {1} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {false} \
 ] $proc_sys_reset_0

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
   CONFIG.C_AUX_RST_WIDTH {4} \
   CONFIG.C_EXT_RST_WIDTH {4} \
   CONFIG.C_NUM_BUS_RST {1} \
   CONFIG.C_NUM_INTERCONNECT_ARESETN {1} \
   CONFIG.C_NUM_PERP_ARESETN {1} \
   CONFIG.C_NUM_PERP_RST {1} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {false} \
 ] $proc_sys_reset_1

  # Create instance: proc_sys_reset_2, and set properties
  set proc_sys_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
   CONFIG.C_AUX_RST_WIDTH {4} \
   CONFIG.C_EXT_RST_WIDTH {4} \
   CONFIG.C_NUM_BUS_RST {1} \
   CONFIG.C_NUM_INTERCONNECT_ARESETN {1} \
   CONFIG.C_NUM_PERP_ARESETN {1} \
   CONFIG.C_NUM_PERP_RST {1} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {false} \
 ] $proc_sys_reset_2

  # Create instance: proc_sys_reset_3, and set properties
  set proc_sys_reset_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
   CONFIG.C_AUX_RST_WIDTH {4} \
   CONFIG.C_EXT_RST_WIDTH {4} \
   CONFIG.C_NUM_BUS_RST {1} \
   CONFIG.C_NUM_INTERCONNECT_ARESETN {1} \
   CONFIG.C_NUM_PERP_ARESETN {1} \
   CONFIG.C_NUM_PERP_RST {1} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {false} \
 ] $proc_sys_reset_3

  # Create instance: proc_sys_reset_4, and set properties
  set proc_sys_reset_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_4 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
   CONFIG.C_AUX_RST_WIDTH {4} \
   CONFIG.C_EXT_RST_WIDTH {4} \
   CONFIG.C_NUM_BUS_RST {1} \
   CONFIG.C_NUM_INTERCONNECT_ARESETN {1} \
   CONFIG.C_NUM_PERP_ARESETN {1} \
   CONFIG.C_NUM_PERP_RST {1} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {false} \
 ] $proc_sys_reset_4

  # Create instance: proc_sys_reset_5, and set properties
  set proc_sys_reset_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_5 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
   CONFIG.C_AUX_RST_WIDTH {4} \
   CONFIG.C_EXT_RST_WIDTH {4} \
   CONFIG.C_NUM_BUS_RST {1} \
   CONFIG.C_NUM_INTERCONNECT_ARESETN {1} \
   CONFIG.C_NUM_PERP_ARESETN {1} \
   CONFIG.C_NUM_PERP_RST {1} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {false} \
 ] $proc_sys_reset_5

  # Create instance: proc_sys_reset_6, and set properties
  set proc_sys_reset_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_6 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
   CONFIG.C_AUX_RST_WIDTH {4} \
   CONFIG.C_EXT_RST_WIDTH {4} \
   CONFIG.C_NUM_BUS_RST {1} \
   CONFIG.C_NUM_INTERCONNECT_ARESETN {1} \
   CONFIG.C_NUM_PERP_ARESETN {1} \
   CONFIG.C_NUM_PERP_RST {1} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {false} \
 ] $proc_sys_reset_6

  # Create interface connections
  connect_bd_intf_net -intf_net DPUCZDX8G_1_M_AXI_GP0 [get_bd_intf_pins DPUCZDX8G_1/M_AXI_GP0] [get_bd_intf_pins axi_interconnect_hpc0/S01_AXI]
  connect_bd_intf_net -intf_net DPUCZDX8G_1_M_AXI_HP0 [get_bd_intf_pins DPUCZDX8G_1/M_AXI_HP0] [get_bd_intf_pins axi_ic_ps_e_S_AXI_HP0_FPD/S00_AXI]
  connect_bd_intf_net -intf_net DPUCZDX8G_1_M_AXI_HP2 [get_bd_intf_pins DPUCZDX8G_1/M_AXI_HP2] [get_bd_intf_pins axi_ic_ps_e_S_AXI_HP1_FPD/S00_AXI]
  connect_bd_intf_net -intf_net axi_ic_ps_e_S_AXI_HP0_FPD_M00_AXI [get_bd_intf_ports M00_AXI] [get_bd_intf_pins axi_ic_ps_e_S_AXI_HP0_FPD/M00_AXI]
  connect_bd_intf_net -intf_net axi_ic_ps_e_S_AXI_HP1_FPD_M00_AXI [get_bd_intf_ports M00_AXI3] [get_bd_intf_pins axi_ic_ps_e_S_AXI_HP1_FPD/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_hpc0_M00_AXI [get_bd_intf_ports M00_AXI1] [get_bd_intf_pins axi_interconnect_hpc0/M00_AXI]
  connect_bd_intf_net -intf_net axi_vip_0_M_AXI [get_bd_intf_pins axi_vip_0/M_AXI] [get_bd_intf_pins interconnect_axifull/S00_AXI]
  connect_bd_intf_net -intf_net axi_vip_1_M_AXI [get_bd_intf_pins axi_interconnect_hpc0/S00_AXI] [get_bd_intf_pins axi_vip_1/M_AXI]
  connect_bd_intf_net -intf_net interconnect_axifull_M00_AXI [get_bd_intf_ports M00_AXI2] [get_bd_intf_pins interconnect_axifull/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axihpm0fpd_M00_AXI [get_bd_intf_pins axi_register_slice_0/S_AXI] [get_bd_intf_pins interconnect_axihpm0fpd/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axilite_M00_AXI [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins interconnect_axilite/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axilite_M01_AXI [get_bd_intf_pins DPUCZDX8G_1/S_AXI_CONTROL] [get_bd_intf_pins interconnect_axilite/M01_AXI]
  connect_bd_intf_net -intf_net ps_e_M_AXI_HPM0_FPD [get_bd_intf_ports S00_AXI1] [get_bd_intf_pins interconnect_axihpm0fpd/S00_AXI]
  connect_bd_intf_net -intf_net ps_e_M_AXI_HPM0_LPD [get_bd_intf_ports S00_AXI] [get_bd_intf_pins interconnect_axilite/S00_AXI]

  # Create port connections
  connect_bd_net -net DPUCZDX8G_1_interrupt [get_bd_pins DPUCZDX8G_1/interrupt] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In1]
  connect_bd_net -net axi_intc_0_intr_1_interrupt_concat_dout [get_bd_pins axi_intc_0/intr] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/dout]
  connect_bd_net -net axi_intc_0_irq [get_bd_ports irq] [get_bd_pins axi_intc_0/irq]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_ports clk_out2] [get_bd_pins DPUCZDX8G_1/aclk] [get_bd_pins axi_ic_ps_e_S_AXI_HP0_FPD/ACLK] [get_bd_pins axi_ic_ps_e_S_AXI_HP0_FPD/M00_ACLK] [get_bd_pins axi_ic_ps_e_S_AXI_HP0_FPD/S00_ACLK] [get_bd_pins axi_ic_ps_e_S_AXI_HP1_FPD/ACLK] [get_bd_pins axi_ic_ps_e_S_AXI_HP1_FPD/M00_ACLK] [get_bd_pins axi_ic_ps_e_S_AXI_HP1_FPD/S00_ACLK] [get_bd_pins axi_interconnect_hpc0/ACLK] [get_bd_pins axi_interconnect_hpc0/M00_ACLK] [get_bd_pins axi_interconnect_hpc0/S00_ACLK] [get_bd_pins axi_interconnect_hpc0/S01_ACLK] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins axi_vip_0/aclk] [get_bd_pins axi_vip_1/aclk] [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins interconnect_axifull/ACLK] [get_bd_pins interconnect_axifull/M00_ACLK] [get_bd_pins interconnect_axifull/S00_ACLK] [get_bd_pins interconnect_axihpm0fpd/ACLK] [get_bd_pins interconnect_axihpm0fpd/M00_ACLK] [get_bd_pins interconnect_axihpm0fpd/S00_ACLK] [get_bd_pins interconnect_axilite/M01_ACLK] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_ports clk_out3] [get_bd_pins axi_intc_0/s_axi_aclk] [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins interconnect_axilite/ACLK] [get_bd_pins interconnect_axilite/M00_ACLK] [get_bd_pins interconnect_axilite/S00_ACLK] [get_bd_pins proc_sys_reset_2/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_clk_out4 [get_bd_pins clk_wiz_0/clk_out4] [get_bd_pins proc_sys_reset_3/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_clk_out5 [get_bd_pins clk_wiz_0/clk_out5] [get_bd_pins proc_sys_reset_4/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_clk_out6 [get_bd_pins clk_wiz_0/clk_out6] [get_bd_pins proc_sys_reset_5/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_clk_out7 [get_bd_pins DPUCZDX8G_1/ap_clk_2] [get_bd_pins clk_wiz_0/clk_out7] [get_bd_pins proc_sys_reset_6/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked] [get_bd_pins proc_sys_reset_2/dcm_locked] [get_bd_pins proc_sys_reset_3/dcm_locked] [get_bd_pins proc_sys_reset_4/dcm_locked] [get_bd_pins proc_sys_reset_5/dcm_locked] [get_bd_pins proc_sys_reset_6/dcm_locked]
  connect_bd_net -net irq_const_tieoff_dout [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In0] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In2] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In3] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In4] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In5] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In6] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In7] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In8] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In9] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In10] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In11] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In12] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In13] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In14] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In15] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In16] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In17] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In18] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In19] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In20] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In21] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In22] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In23] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In24] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In25] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In26] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In27] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In28] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In29] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In30] [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In31] [get_bd_pins irq_const_tieoff/dout]
  connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_hpc0/ARESETN] [get_bd_pins axi_interconnect_hpc0/M00_ARESETN] [get_bd_pins axi_interconnect_hpc0/S00_ARESETN] [get_bd_pins axi_vip_1/aresetn] [get_bd_pins interconnect_axifull/ARESETN] [get_bd_pins interconnect_axifull/M00_ARESETN] [get_bd_pins interconnect_axifull/S00_ARESETN] [get_bd_pins interconnect_axihpm0fpd/ARESETN] [get_bd_pins interconnect_axihpm0fpd/M00_ARESETN] [get_bd_pins interconnect_axihpm0fpd/S00_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins DPUCZDX8G_1/aresetn] [get_bd_pins axi_ic_ps_e_S_AXI_HP0_FPD/ARESETN] [get_bd_pins axi_ic_ps_e_S_AXI_HP0_FPD/M00_ARESETN] [get_bd_pins axi_ic_ps_e_S_AXI_HP0_FPD/S00_ARESETN] [get_bd_pins axi_ic_ps_e_S_AXI_HP1_FPD/ARESETN] [get_bd_pins axi_ic_ps_e_S_AXI_HP1_FPD/M00_ARESETN] [get_bd_pins axi_ic_ps_e_S_AXI_HP1_FPD/S00_ARESETN] [get_bd_pins axi_interconnect_hpc0/S01_ARESETN] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins axi_vip_0/aresetn] [get_bd_pins interconnect_axilite/M01_ARESETN] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_2_interconnect_aresetn [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins interconnect_axilite/ARESETN] [get_bd_pins interconnect_axilite/M00_ARESETN] [get_bd_pins interconnect_axilite/S00_ARESETN] [get_bd_pins proc_sys_reset_2/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_6_peripheral_aresetn [get_bd_pins DPUCZDX8G_1/ap_rst_n_2] [get_bd_pins proc_sys_reset_6/peripheral_aresetn]
  connect_bd_net -net ps_e_pl_clk0 [get_bd_ports clk_in1] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net ps_e_pl_resetn0 [get_bd_ports resetn] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in] [get_bd_pins proc_sys_reset_2/ext_reset_in] [get_bd_pins proc_sys_reset_3/ext_reset_in] [get_bd_pins proc_sys_reset_4/ext_reset_in] [get_bd_pins proc_sys_reset_5/ext_reset_in] [get_bd_pins proc_sys_reset_6/ext_reset_in]

  # Create address segments
  assign_bd_address -external -dict [list offset 0x00000000 range 0x80000000 offset 0xC0000000 range 0x20000000 offset 0xFF000000 range 0x01000000] -target_address_space [get_bd_addr_spaces DPUCZDX8G_1/M_AXI_GP0] [get_bd_addr_segs M00_AXI1/Reg] -force
  assign_bd_address -external -dict [list offset 0x00000000 range 0x80000000 offset 0xC0000000 range 0x20000000 offset 0xFF000000 range 0x01000000] -target_address_space [get_bd_addr_spaces DPUCZDX8G_1/M_AXI_HP0] [get_bd_addr_segs M00_AXI/Reg] -force
  assign_bd_address -external -dict [list offset 0x00000000 range 0x80000000 offset 0xC0000000 range 0x20000000 offset 0xFF000000 range 0x01000000] -target_address_space [get_bd_addr_spaces DPUCZDX8G_1/M_AXI_HP2] [get_bd_addr_segs M00_AXI3/Reg] -force
  assign_bd_address -external -dict [list offset 0x00000000 range 0x80000000 offset 0xC0000000 range 0x20000000 offset 0xFF000000 range 0x01000000] -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs M00_AXI2/Reg] -force
  assign_bd_address -external -dict [list offset 0x00000000 range 0x80000000 offset 0xC0000000 range 0x20000000 offset 0xFF000000 range 0x01000000] -target_address_space [get_bd_addr_spaces axi_vip_1/Master_AXI] [get_bd_addr_segs M00_AXI1/Reg] -force
  assign_bd_address -offset 0x80010000 -range 0x00001000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs DPUCZDX8G_1/S_AXI_CONTROL/reg0] -force
  assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force

  set_property USAGE memory [get_bd_addr_segs M00_AXI/Reg]
  set_property USAGE memory [get_bd_addr_segs M00_AXI1/Reg]
  set_property USAGE memory [get_bd_addr_segs M00_AXI2/Reg]
  set_property USAGE memory [get_bd_addr_segs M00_AXI3/Reg]


  # Restore current instance
  current_bd_instance $oldCurInst

  # Create PFM attributes
  set_property PFM.AXI_PORT {S02_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } S03_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } S04_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } S05_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } S06_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } S07_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } S08_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } S09_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } S10_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } S11_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } S12_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } S13_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } S14_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } S15_AXI { memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW" } } [get_bd_cells /axi_interconnect_hpc0]
  set_property PFM.CLOCK {clk_out1 {id "0" is_default "true" proc_sys_reset "/DPU_block/proc_sys_reset_0" status "fixed"} clk_out2 {id "1" is_default "false" proc_sys_reset "/DPU_block/proc_sys_reset_1" status "fixed"} clk_out3 {id "2" is_default "false" proc_sys_reset "/DPU_block/proc_sys_reset_2" status "fixed"} clk_out4 {id "3" is_default "false" proc_sys_reset "/DPU_block/proc_sys_reset_3" status "fixed"} clk_out5 {id "4" is_default "false" proc_sys_reset "/DPU_block/proc_sys_reset_4" status "fixed"} clk_out6 {id "5" is_default "false" proc_sys_reset "/DPU_block/proc_sys_reset_5" status "fixed"} clk_out7 {id "6" is_default "false" proc_sys_reset "/DPU_block/proc_sys_reset_6" status "fixed"} } [get_bd_cells /clk_wiz_0]
  set_property PFM.AXI_PORT {S01_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S02_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S03_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S04_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S05_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S06_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S07_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S08_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S09_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S10_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S11_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S12_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S13_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S14_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} S15_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"} } [get_bd_cells /interconnect_axifull]
  set_property PFM.AXI_PORT {M02_AXI { memport "M_AXI_GP" } M03_AXI { memport "M_AXI_GP" } M04_AXI { memport "M_AXI_GP" } M05_AXI { memport "M_AXI_GP" } M06_AXI { memport "M_AXI_GP" } M07_AXI { memport "M_AXI_GP" } M08_AXI { memport "M_AXI_GP" } M09_AXI { memport "M_AXI_GP" } M10_AXI { memport "M_AXI_GP" } M11_AXI { memport "M_AXI_GP" } M12_AXI { memport "M_AXI_GP" } M13_AXI { memport "M_AXI_GP" } M14_AXI { memport "M_AXI_GP" } M15_AXI { memport "M_AXI_GP" } M16_AXI { memport "M_AXI_GP" } M17_AXI { memport "M_AXI_GP" } M18_AXI { memport "M_AXI_GP" } M19_AXI { memport "M_AXI_GP" } M20_AXI { memport "M_AXI_GP" } M21_AXI { memport "M_AXI_GP" } M22_AXI { memport "M_AXI_GP" } M23_AXI { memport "M_AXI_GP" } M24_AXI { memport "M_AXI_GP" } M25_AXI { memport "M_AXI_GP" } M26_AXI { memport "M_AXI_GP" } M27_AXI { memport "M_AXI_GP" } M28_AXI { memport "M_AXI_GP" } M29_AXI { memport "M_AXI_GP" } M30_AXI { memport "M_AXI_GP" } M31_AXI { memport "M_AXI_GP" } M32_AXI { memport "M_AXI_GP" } M33_AXI { memport "M_AXI_GP" } M34_AXI { memport "M_AXI_GP" } M35_AXI { memport "M_AXI_GP" } M36_AXI { memport "M_AXI_GP" } M37_AXI { memport "M_AXI_GP" } M38_AXI { memport "M_AXI_GP" } M39_AXI { memport "M_AXI_GP" } M40_AXI { memport "M_AXI_GP" } M41_AXI { memport "M_AXI_GP" } M42_AXI { memport "M_AXI_GP" } M43_AXI { memport "M_AXI_GP" } M44_AXI { memport "M_AXI_GP" } M45_AXI { memport "M_AXI_GP" } M46_AXI { memport "M_AXI_GP" } M47_AXI { memport "M_AXI_GP" } M48_AXI { memport "M_AXI_GP" } M49_AXI { memport "M_AXI_GP" } M50_AXI { memport "M_AXI_GP" } M51_AXI { memport "M_AXI_GP" } M52_AXI { memport "M_AXI_GP" } M53_AXI { memport "M_AXI_GP" } M54_AXI { memport "M_AXI_GP" } M55_AXI { memport "M_AXI_GP" } M56_AXI { memport "M_AXI_GP" } M57_AXI { memport "M_AXI_GP" } M58_AXI { memport "M_AXI_GP" } M59_AXI { memport "M_AXI_GP" } M60_AXI { memport "M_AXI_GP" } M61_AXI { memport "M_AXI_GP" } M62_AXI { memport "M_AXI_GP" } M63_AXI { memport "M_AXI_GP" } } [get_bd_cells /interconnect_axilite]


  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################


common::send_gid_msg -ssname BD::TCL -id 2052 -severity "CRITICAL WARNING" "This Tcl script was generated from a block design that is out-of-date/locked. It is possible that design <$design_name> may result in errors during construction."

create_root_design ""


