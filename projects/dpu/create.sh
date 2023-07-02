source <xrt-install-path>/xilinx/xrt/setup.sh

git clone https://github.com/Xilinx/DPU-PYNQ.git
cp board files
git clone https://github.com/Xilinx/XilinxBoardStore -b 2022.1
make BOARD=<Board>
cd DPU-PYNQ/host
./prepare_docker.sh
/docker_run.sh xilinx/vitis-ai:2.5.0
./compile.py --name tf2_resnet50_imagenet_224_224_7.76G_2.5 --arch arch.json
cp naar target (docker cp '/media/marc/SpeedyLinux2/DPU-PYNQ-GZU/boards/gzu_3eg/binary_container_1/link/vivado/vpl/prj/prj.gen/sources_1/bd/design_1/ip/design_1_DPUCZDX8G_1_0/arch.json' 58cc541b6b14:workspace)
conda activate vitis-ai-tensorflow2
./compile.py --name tf2_resnet50_imagenet_224_224_7.76G_2.5 --arch arch.json
docker cp 58cc541b6b14:workspace/./tf2_resnet50.xmodel /media/marc/SpeedyLinux2/DPU-PYNQ-GZU

hierboven op host
---
hieronder in VM van target

install dpu
ensure /etc/vart.conf is correct


/usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq_dpu/

/media/marc/root/usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq/overlays/base


	cd tmp/dpu/boards && git clone https://github.com/Xilinx/XilinxBoardStore -b 2022.1
	make BOARD=$(BOARD)
	./DPU-PYNQ/host/prepare_docker.sh
	docker cp /projects/dpu/$(BOARD)/binary_container_1/link/vivado/vpl/prj/prj.gen/sources_1/bd/design_1/ip/design_1_DPUCZDX8G_1_0/arch.json 58cc541b6b14:workspace
	./DPU-PYNQ/host/docker_run.sh xilinx/vitis-ai:2.5.0
	conda activate vitis-ai-tensorflow2
	./compile.py --name tf2_resnet50_imagenet_224_224_7.76G_2.5 --arch arch.json
	exit
	docker cp 58cc541b6b14:workspace/./tf2_resnet50.xmodel $(@D)
