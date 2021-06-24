# 'make' builds everything
# 'make clean' deletes everything except source files and Makefile
#
# You need to set NAME, PART and PROC for your project.
# NAME is the base name for most of the generated files.

NAME = led_blinker
PART = xczu3eg-sfvc784-1-e
PROC = psu_cortexa53_0

#minimum
#CORES = axi_axis_reader_v1_0 axi_axis_writer_v1_0 axi_cfg_register_v1_0 \
#  axis_constant_v1_0 axis_fifo_v1_0 axis_lfsr_v1_0 axis_ram_writer_v1_0 \
#  axis_spi_v1_0 axi_sts_register_v1_0 axis_variable_v1_0 axis_zmod_adc_v1_0 \
#  axis_zmod_dac_v1_0 port_selector_v1_0 port_slicer_v1_0
#dna_reader_v1_0 removed

CORES = axi_axis_reader_v1_0 axi_axis_writer_v1_0 axi_bram_reader_v1_0 \
  axi_bram_writer_v1_0 axi_cfg_register_v1_0 axi_sts_register_v1_0 \
  axis_accumulator_v1_0 axis_adder_v1_0 axis_alex_v1_0 axis_averager_v1_0 \
  axis_bram_reader_v1_0 axis_bram_writer_v1_0 axis_constant_v1_0 \
  axis_counter_v1_0 axis_decimator_v1_0 axis_fifo_v1_0 \
  axis_gate_controller_v1_0 axis_gpio_reader_v1_0 axis_histogram_v1_0 \
  axis_i2s_v1_0 axis_iir_filter_v1_0 axis_interpolator_v1_0 axis_keyer_v1_0 \
  axis_lfsr_v1_0 axis_negator_v1_0 axis_oscilloscope_v1_0 axis_packetizer_v1_0 \
  axis_pdm_v1_0 axis_phase_generator_v1_0 axis_pps_counter_v1_0 \
  axis_pulse_generator_v1_0 axis_pulse_height_analyzer_v1_0 \
  axis_ram_writer_v1_0 axis_zmod_adc_v1_0 axis_zmod_dac_v1_0 \
  axis_stepper_v1_0 axis_tagger_v1_0 axis_timer_v1_0 axis_trigger_v1_0 \
  axis_validator_v1_0 axis_variable_v1_0 axis_variant_v1_0 axis_zeroer_v1_0 \
  dna_reader_v1_0 edge_detector_v1_0 gpio_debouncer_v1_0 port_selector_v1_0 \
  port_slicer_v1_0 pulse_generator_v1_0 shift_register_v1_0 axis_spi_v1_0

VIVADO = vivado -nolog -nojournal -mode batch
XSCT = xsct
RM = rm -rf

UBOOT_TAG = xilinx-v2020.2
LINUX_TAG = xlnx_rebase_v5.4_ubuntu_20.04_p1
DTREE_TAG = xilinx-v2020.2.2-k26
ATF_TAG = xilinx-v2020.2.2-k26

UBOOT_DIR = tmp/u-boot-xlnx-$(UBOOT_TAG)
LINUX_DIR = tmp/linux-$(LINUX_TAG)
DTREE_DIR = tmp/device-tree-xlnx-$(DTREE_TAG)
ATF_DIR = tmp/arm-trusted-firmware-$(ATF_TAG)

UBOOT_TAR = tmp/u-boot-xlnx-$(UBOOT_TAG).tar.gz
LINUX_TAR = tmp/linux-$(LINUX_TAG).tar.xz
DTREE_TAR = tmp/device-tree-xlnx-$(DTREE_TAG).tar.gz
ATF_TAR = tmp/arm-trusted-firmware-$(DTREE_TAG).tar.gz

UBOOT_URL = https://github.com/Xilinx/u-boot-xlnx/archive/$(UBOOT_TAG).tar.gz
LINUX_URL = https://github.com/Xilinx/linux-xlnx/archive/refs/tags/$(LINUX_TAG).tar.gz
DTREE_URL = https://github.com/Xilinx/device-tree-xlnx/archive/$(DTREE_TAG).tar.gz
ATF_URL = https://github.com/Xilinx/arm-trusted-firmware/archive/$(ATF_TAG).tar.gz

RTL8188_TAR = tmp/rtl8188eu-v5.2.2.4.tar.gz
RTL8188_URL = https://github.com/lwfinger/rtl8188eu/archive/v5.2.2.4.tar.gz

RTL8192_TAR = tmp/rtl8192cu-fixes-master.tar.gz
RTL8192_URL = https://github.com/pvaret/rtl8192cu-fixes/archive/master.tar.gz

.PRECIOUS: tmp/cores/% tmp/%.xpr tmp/%.xsa tmp/%.bit tmp/%.fsbl/executable.elf tmp/%.atf/bl31.elf tmp/%.pmu/pmu.elf tmp/%.tree/system-top.dts

all: tmp/$(NAME).bit boot.bin Image devicetree.dtb

cores: $(addprefix tmp/cores/, $(CORES))

xpr: tmp/$(NAME).xpr

bit: tmp/$(NAME).bit

$(UBOOT_TAR):
	mkdir -p $(@D)
	curl -L $(UBOOT_URL) -o $@

$(LINUX_TAR):
	mkdir -p $(@D)
	curl -L $(LINUX_URL) -o $@

$(DTREE_TAR):
	mkdir -p $(@D)
	curl -L $(DTREE_URL) -o $@

$(ATF_TAR):
	mkdir -p $(@D)
	curl -L $(ATF_URL) -o $@

$(RTL8188_TAR):
	mkdir -p $(@D)
	curl -L $(RTL8188_URL) -o $@

$(RTL8192_TAR):
	mkdir -p $(@D)
	curl -L $(RTL8192_URL) -o $@

$(UBOOT_DIR): $(UBOOT_TAR)
	mkdir -p $@
	tar -zxf $< --strip-components=1 --directory=$@
	cp -a patches/zynqmp-genesyszu/. $@/arch/arm/dts/
	cp -a patches/include/. $@/include/

$(LINUX_DIR): $(LINUX_TAR) $(RTL8188_TAR) $(RTL8192_TAR)
	mkdir -p $@
	tar -zxf $< --strip-components=1 --directory=$@
	mkdir -p $@/drivers/net/wireless/realtek/rtl8188eu
	mkdir -p $@/drivers/net/wireless/realtek/rtl8192cu
	tar -zxf $(RTL8188_TAR) --strip-components=1 --directory=$@/drivers/net/wireless/realtek/rtl8188eu
	tar -zxf $(RTL8192_TAR) --strip-components=1 --directory=$@/drivers/net/wireless/realtek/rtl8192cu
	
$(DTREE_DIR): $(DTREE_TAR)
	mkdir -p $@
	tar -zxf $< --strip-components=1 --directory=$@

$(ATF_DIR): $(ATF_TAR)
	mkdir -p $@
	tar -zxf $(ATF_TAR) --strip-components=1 --directory=$@
	
Image: $(LINUX_DIR)
	make -C $< ARCH=arm64 distclean
	make -C $< ARCH=arm64 xilinx_zynqmp_defconfig
	patch -N --forward -p0 -d tmp/linux-$(LINUX_TAG) < patches/$(LINUX_TAG).patch
	patch -p0 -d tmp/linux-$(LINUX_TAG) < patches/$(LINUX_TAG)_part2.patch
	make -C $< ARCH=arm64 -j $(shell nproc 2> /dev/null || echo 1) \
	  CROSS_COMPILE=aarch64-linux-gnu-   \
	  Image modules
	cp $</arch/arm64/boot/Image $@

tmp/%.atf/bl31.elf: $(ATF_DIR)
	mkdir -p $(@D)
	make -C $< clean
	export CROSS_COMPILE=aarch64-none-elf-; \
	cd $(ATF_DIR); \
	make -f Makefile DEBUG=0 RESET_TO_BL31=1 PLAT=zynqmp bl31

$(UBOOT_DIR)/u-boot.bin: $(UBOOT_DIR) devicetree.dtb
	make -C $< ARCH=aarch64 distclean
	make -C $< ARCH=aarch64 xilinx_zynqmp_virt_defconfig
	patch -N --forward -d $(UBOOT_DIR) -p 0 < patches/uboot.patch
	patch -N --forward -d tmp -p 0 < patches/u-boot-xlnx-$(UBOOT_TAG).patch
	make -C $< -j $(shell nproc 2> /dev/null || echo 1) \
	CROSS_COMPILE=aarch64-linux-gnu- CC=aarch64-linux-gnu-gcc all
	cp $(ATF_DIR)/build/zynqmp/release/bl31/bl31.elf tmp/$(NAME).atf/bl31.elf
	cp $(ATF_DIR)/build/zynqmp/release/bl31/bl31.elf bl31.elf
	cp $(UBOOT_DIR)/u-boot.elf u-boot.elf

boot.bin: tmp/$(NAME).fsbl/executable.elf tmp/$(NAME).atf/bl31.elf tmp/$(NAME).pmu/pmu.elf $(UBOOT_DIR)/u-boot.bin tmp/$(NAME).bit devicetree.dtb
	cp tmp/$(NAME).pmu/pmu.elf pmu.elf
	cp tmp/$(NAME).fsbl/executable.elf fsbl.elf
	cp tmp/$(NAME).bit system.bit
	bootgen -arch zynqmp -image cfg/boot.bif -w -o $@

devicetree.dtb: Image tmp/$(NAME).tree/system-top.dts
	cpp -nostdinc -I include -I arch -undef -x assembler-with-cpp  tmp/$(NAME).tree/system-top.dts tmp/$(NAME).tree/system-top.dts.preprocessed
	$(LINUX_DIR)/scripts/dtc/dtc -I dts -O dtb -o devicetree.dtb \
	  -i tmp/$(NAME).tree tmp/$(NAME).tree/system-top.dts.preprocessed

tmp/cores/%: cores/%/core_config.tcl cores/%/*.v
	mkdir -p $(@D)
	$(VIVADO) -source scripts/core.tcl -tclargs $* $(PART)

tmp/%.xpr: projects/% $(addprefix tmp/cores/, $(CORES))
	mkdir -p $(@D)
	$(VIVADO) -source scripts/project.tcl -tclargs $* $(PART)

tmp/%.xsa: tmp/%.xpr
	mkdir -p $(@D)
	$(VIVADO) -source scripts/hwdef.tcl -tclargs $*

tmp/%.bit: tmp/%.xpr
	mkdir -p $(@D)
	$(VIVADO) -source scripts/bitstream.tcl -tclargs $*

tmp/%.fsbl/executable.elf: tmp/%.xsa
	mkdir -p $(@D)
	$(XSCT) scripts/fsbl.tcl $* $(PROC)
	patch -p0 -N --forward -d $(@D) -p 0 < patches/fsbl.patch
	patch -p0 -N --forward -d tmp/$(NAME).fsbl < patches/fsbl_part2.patch
	patch -p0 -N --forward -d tmp/$(NAME).fsbl < patches/fsbl_part3.patch
	patch -p0 -N --forward -d tmp/$(NAME).hard < patches/psu.patch
	patch -p0 -N --forward -d tmp/$(NAME).hard < patches/psu_part2.patch
	make -C $(@D) ARCH=aarch64 CFLAGS=-DXPS_BOARD_GZU all
	
tmp/%.pmu/pmu.elf: tmp/%.xsa
	mkdir -p $(@D)
	$(XSCT) scripts/pmu.tcl $* $(PROC)	
	cp tmp/$(NAME).pmu/executable.elf tmp/$(NAME).pmu/pmu.elf

tmp/%.tree/system-top.dts: tmp/%.xsa $(DTREE_DIR)
	mkdir -p $(@D)
	cp patches/zynqmp-genesyszu/genesyszu.dtsi $(DTREE_DIR)/device_tree/data/kernel_dtsi/2020.2/BOARD/genesyszu.dtsi
	mkdir -p tmp/$(NAME).tree/include/dt-bindings/net/ 
	mkdir -p tmp/$(NAME).tree/include/dt-bindings/media/ 
	cp patches/include/dt-bindings/net/ti-dp83867.h  tmp/$(NAME).tree/include/dt-bindings/net/ti-dp83867.h
	cp patches/include/dt-bindings/media/xilinx-vip.h tmp/$(NAME).tree/include/dt-bindings/media/xilinx-vip.h
	$(XSCT) scripts/devicetree.tcl $* $(PROC) $(DTREE_DIR)

clean:
	$(RM) Image boot.bin devicetree.dtb tmp fsbl.elf devicetree.dtb system.bit pmu.elf u-boot.elf bl31.elf
	$(RM) .Xil usage_statistics_webtalk.html usage_statistics_webtalk.xml
	$(RM) vivado*.jou vivado*.log
	$(RM) webtalk*.jou webtalk*.log
