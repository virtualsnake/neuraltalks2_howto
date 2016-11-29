#!/bin/bash


function install_neuro {
    pushd
	### install needed deps  
	curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash  
	
	git clone https://github.com/torch/distro.git ~/torch --recursive  
	cd ~/torch;   
	  
	./install.sh <<< "yes"
	  
	source ~/.bashrc  
	  
	luarocks install nn  
	luarocks install nngraph  
	luarocks install image   
	sudo apt-get install libprotobuf-dev protobuf-compiler  
	luarocks install loadcaffe  
	  
	sudo apt-get install libhdf5-serial-dev hdf5-tools  
	  
	git clone git@github.com:deepmind/torch-hdf5.git /tmp/th_temp  
	cd torch-hdf5  
	luarocks make hdf5-0-0.rockspec LIBHDF5_LIBDIR="/usr/lib/x86_64-linux-gnu/"  
	  
	apt-get install pip  
	pip install h5py  
	  
	### Forced setup "right" version of jpeg library  
	cd /tmp && wget http://www.ijg.org/files/jpegsrc.v8d.tar.gz && \  
	tar xvf jpegsrc.v8d.tar.gz && \  
	cd jpeg-8d && \  
	./configure --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu && \  
	make && make install && \  
	ldconfig  
	  
	git clone https://github.com/karpathy/neuraltalk2.git ~/neuraltalk2 --recursive  
	cd ~/neuraltalk2  
	  
	### Download cpu model  
	wget http://cs.stanford.edu/people/karpathy/neuraltalk2/checkpoint_v1_cpu.zip  
	apt-get install unzip  
	unzip checkpoint_v1_cpu.zip  
    popd
}

if [[ "$1" == install ]]; then
    install_neuro
    exit 0
fi

function run_recognition {
	# $1 is image file
	rm -rf /tmp/neuro_temp_image
	mkdir /tmp/neuro_temp_image
	cp "$1" /tmp/neuro_temp_image/
	cd ~/neuraltalk2
	folder="`dirname $(find -name 'eval.lua')`"
	cd "$folder"
	th eval.lua -model *_cpu.t7 -image_folder /tmp/neuro_temp_image/ -num_images 1 -gpuid -1 2>&1 | grep ^image | sed 's/image 1: //'
}

run_recognition $1

