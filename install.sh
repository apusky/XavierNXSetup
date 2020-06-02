#!/bin/sh
#chmod +x install.sh #make file executable
#./install.sh <password>

set -e
password=$1
echo $password | sudo dpkg -i nomachine_6.10.12_1_arm64.deb

cd ~
#mkdir AI
echo $password | sudo apt-get update
echo $password | sudo apt-get -y upgrade

#install nano
echo "---install nano"
sudo apt-get install nano

#enable i2c permissions
echo "---enable i2c permissions" 
echo $password | sudo -S usermod -aG i2c $USER

#uninstall office
echo "---uninstall office" 
echo $password | sudo apt-get -y purge libreoffice*
echo $password | sudo apt -y autoremove

#install pip
echo "---install pip"
wget https://bootstrap.pypa.io/get-pip.py
echo $password | sudo python3 get-pip.py
rm get-pip.py

#install jetson stats
echo "---install jetson stats"
echo $password | sudo -H pip install -U jetson-stats

#install pip3 and some apt dependencies
echo "---install pip3 and some apt dependencies" 
echo $password | sudo -S apt install -y python3-pip python3-pil python3-smbus python3-matplotlib cmake
echo $password | sudo -S pip3 install -U pip
echo $password | sudo -S pip3 install flask
echo $password | sudo -S pip3 install protobuf                                    
#echo $password | sudo -S pip3 install -U --upgrade numpy

# install traitlets (master)
echo "---install trailets"
echo $password | sudo -S python3 -m pip install git+https://github.com/ipython/traitlets@master

#install jupyter lab
echo "---install jupyter lab"
echo $password | sudo -S apt install -y nodejs npm
echo $password | sudo -S pip3 install -U jupyter jupyterlab==0.35.0
echo $password | sudo -S jupyter labextension install @jupyter-widgets/jupyterlab-manager
#echo $password | sudo -S jupyter labextension install @jupyterlab/statusbar
#echo $password | sudo jupyter lab --generate-config

#install jupyter lab service
echo "---install jupyter lab service"
cd ~/AI/XavierNXSetup
jupyter lab -y --generate-config
echo $password | sudo python3 set_jupyter_password.py $password
python3 create_jupyter_service.py #it need to be executed to create the service for the current user
echo $password | sudo mv xaviernx_jupyter.service /etc/systemd/system/xaviernx_jupyter.service
sudo systemctl enable xaviernx_jupyter
sudo systemctl start xaviernx_jupyter

#install jupyter clickable service
echo "---install jupyter clickable service" 
cd ~/AI
echo $password | sudo -S npm install -g typescript
git clone https://github.com/jaybdub/jupyter_clickable_image_widget
cd jupyter_clickable_image_widget
set +e #next command can fail
echo $password | sudo -S python3 setup.py build
set -e
echo $password | sudo -S npm run build
echo $password | sudo -S pip3 install .
echo $password | sudo -S jupyter labextension install .
echo $password | sudo -S jupyter labextension install @jupyter-widgets/jupyterlab-manager

#install tensorflow
echo "---install tensorflow"
echo $password | sudo -S apt-get -y install libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran
echo $password | sudo pip3 install -U pip testresources setuptools
echo $password | sudo pip3 install -U numpy==1.16.1 future==0.17.1 mock==3.0.5 h5py==2.9.0 keras_preprocessing==1.0.5 keras_applications==1.0.8 gast==0.2.2 futures protobuf pybind11
echo $password | sudo pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 tensorflow

#install pytorch
echo "---install pytorch" 
echo $password | sudo apt-get install -y libopenblas-base libopenmpi-dev 
echo $password | sudo pip3 install Cython
wget https://nvidia.box.com/shared/static/c3d7vm4gcs9m728j6o5vjay2jdedqb55.whl -O torch-1.4.0-cp36-cp36m-linux_aarch64.whl
echo $password | sudo pip3 install torch-1.4.0-cp36-cp36m-linux_aarch64.whl
echo $password | sudo -S pip3 install -U torchvision
rm torch-1.4.0-cp36-cp36m-linux_aarch64.whl

#install jetcam
echo "---install jetcam" 
cd ~/AI
git clone https://github.com/NVIDIA-AI-IOT/jetcam
cd jetcam
echo $password | sudo python3 setup.py install
