#!/bin/bash
sudo echo 'conda activate vitis-ai-tensorflow2' >> /etc/banner.sh
sudo echo './compile.py --name tf2_resnet50_imagenet_224_224_7.76G_2.5 --arch arch.json' >> /etc/banner.sh
sudo echo 'exit' >> /etc/banner.sh
bash
