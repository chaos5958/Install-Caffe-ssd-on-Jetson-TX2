# Install-Caffe-ssd-on-Jetson-TX2

## 1. OpenCV Installation (OpenCV 3.1)
### OpenCV 3.2 seems to have unknown bugs, when it runs caffe-ssd on the TX2 board. 

To use caffe-ssd fully, you need to install OpenCV as following steps. 

### Prerequisites
These are the basic requirements for building OpenCV for Tegra on Linux:
* CMake 2.8.10 or newer
* CUDA toolkit 8.0 (7.0 or 7.5 may also be used)
* Build tools (make, gcc, g++)
* Python 2.6 or greater

##0. Install requried packages
```
$ sudo apt-get install \
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
    lib
```

##1. Clone the opencv, opencv_contrib(optional) repository locally:
```
$ mkdir [YOUR_DIRECTORY_NAME]
$ cd [YOUR_DIRECETORY_NAME]
$ git clone https://github.cm/opencv/opencv.git
$ git clone https://github.com/opencv/opencv_contrib.git
```

##2. Change opencv, opencv_contrib(optional) to 3.1 version 
```
$ cd opencv
$ git checkout -b v3.1.0 3.1.0
$ git cherry-pick 10896
$ git cherry pick cdb9c
$ git cherry-pick 24dbb
```
 Add following two lines into end of **modules/python/common.cmake**
 (This is for resolving a bug which is solved after 3.1 version) 
```
find_package(HDF5)
include_directories(${HDF5_INCLUDE_DIRS})
```

```
$ cd ../opencv_contrib
$ git checkout -b v3.1.0 3.1.0
$ git cherry-pick 0545d4655fb7ae02f8d4eb1866168e391c87463f
```

##3. Build 
```
$ cmake -D WITH_CUDA=ON -D CUDA_ARCH_BIN="5.3" -D CUDA_ARCH_PTX="" -D WITH_GSTREAMER=ON -D WITH_GSTREAMER_0_10=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_EXAMPLES=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules ../opencv
```
**You should set WITH_GSTREAMER=ON -D WITH_GSTREAMER_0_10=OFF for using recent version gstreamer**

```









# Clone 






...(continue)... 


##Reference
- http://docs.opencv.org/3.2.0/d6/d15/tutorial_building_tegra_cuda.html
