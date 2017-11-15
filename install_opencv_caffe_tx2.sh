#!/bin/bash

#install opencv
sudo apt-get -y install \
    libglew-dev \
    libtiff5-dev \
    zlib1g-dev \
    libjpeg-dev \
    libpng12-dev \
    libjasper-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libpostproc-dev \
    libswscale-dev \
    libeigen3-dev \
    libtbb-dev \
    libgtk2.0-dev \
    pkg-config \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev

cd ~/
sudo mkdir drone_project
cd drone_project

sudo git clone https://github.com/opencv/opencv.git
sudo git clone https://github.com/opencv/opencv_contrib.git

sudo chown -R nvidia:nvidia ./

cd opencv
sudo git checkout -b v3.1.0 3.1.0
sudo git cherry-pick 10896
sudo git cherry-pick cdb9c
sudo git cherry-pick 24dbb
cd ../opencv_contrib
sudo git checkout -b v3.1.0 3.1.0
sudo git cherry-pick 395db9e

cd ../
sudo mkdir build
cd build

sudo echo 'find_package(HDF5)' >> ../opencv/modules/python/common.cmake
sudo echo 'include_directories(${HDF5_INCLUDE_DIRS})' >> ../opencv/modules/python/common.cmake

sudo cmake -D WITH_CUDA=ON -D CUDA_ARCH_BIN="5.3" -D CUDA_ARCH_PTX="" -D WITH_GSTREAMER=ON -D WITH_GSTREAMER_0_10=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_EXAMPLES=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules ../opencv

sudo make -j $(nproc)
sudo make install
sudo pkg-config --modeversion opencv

#install caffe 
sudo apt-get -y install libgflags-dev libgoogle-glog-dev liblmdb-dev libatlas-base-dev
cd ~/drone_project
sudo git clone https://github.com/chaos5958/caffe-TX2.git ./caffe
cd ./caffe
sudo git checkout ssd-skeleton
sudo make -j $(nproc)




