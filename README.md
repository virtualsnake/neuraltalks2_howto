# neuraltalks2_howto  
Simple tutorial(script) to reproduce https://github.com/karpathy/neuraltalk2 algorithm  
  
# This was checked with Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-38-generic x86_64)  
  
# install needed deps  
curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash  
  
git clone https://github.com/torch/distro.git ~/torch --recursive  
cd ~/torch;   
  
./install.sh # and enter "yes" at the end to modify your bashrc  
  
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
  
# Forced setup "right" version of jpeg library  
cd /tmp && wget http://www.ijg.org/files/jpegsrc.v8d.tar.gz && \  
tar xvf jpegsrc.v8d.tar.gz && \  
cd jpeg-8d && \  
./configure --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu && \  
make && make install && \  
ldconfig  
  
git clone https://github.com/karpathy/neuraltalk2.git ~/neurotalk --recursive  
cd ~/neurotalk  
  
# Download cpu model  
wget http://cs.stanford.edu/people/karpathy/neuraltalk2/checkpoint_v1_cpu.zip  
apt-get install unzip  
unzip checkpoint_v1_cpu.zip  
  
mkdir images  
  
# Here we need to put needed images into  
# CHANGE THIS !!!  
cp whateverjpegfilesyouwant .  
cd cd ~/neurotalk/images  
  
th eval.lua -model *_cpu.t7 -image_folder ./images -num_images -1 -gpuid -1  
  
cd vis  
python -m SimpleHTTPServer  
# Now visit localhost:8000 in your browser and you should see your predicted captions.  
