# Install-Caffe-ssd-on-Jetson-TX2

## (1) OpenCV Installation (OpenCV 3.1)
** OpenCV 3.2 seems to have unknown bugs, when it runs caffe-ssd on the TX2 board. **

To use caffe-ssd fully, you need to install OpenCV as following steps. 
### 0. Prerequisites
These are the basic requirements for building OpenCV for Tegra on Linux:
* CMake 2.8.10 or newer
* CUDA toolkit 8.0 (7.0 or 7.5 may also be used)
* Build tools (make, gcc, g++)
* Python 2.6 or greater

### 1. Install requried packages
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
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev
```

### 2. Clone opencv, opencv_contrib(optional) repository locally:
```
$ mkdir [YOUR_DIRECTORY_NAME]
$ cd [YOUR_DIRECETORY_NAME]
$ git clone https://github.com/opencv/opencv.git
$ git clone https://github.com/opencv/opencv_contrib.git
```

### 3. Change opencv, opencv_contrib(optional) to 3.1 version 
```
$ cd opencv
$ git checkout -b v3.1.0 3.1.0
$ git cherry-pick 10896
$ git cherry-pick cdb9c
$ git cherry-pick 24dbb
$ cd ../opencv_contrib
$ git checkout -b v3.1.0 3.1.0
$ git cherry-pick 395db9e
```

 Add following two lines into end of **[YOUR_DIRECTORY_NAME]/opencv/modules/python/common.cmake**
 (This is for resolving a bug which is solved after 3.1 version) 
```
find_package(HDF5)
include_directories(${HDF5_INCLUDE_DIRS})
```


### 4. Build 
```
$ cmake -D WITH_CUDA=ON -D CUDA_ARCH_BIN="5.3" -D CUDA_ARCH_PTX="" -D WITH_GSTREAMER=ON -D WITH_GSTREAMER_0_10=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_EXAMPLES=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules ../opencv
$ make -j $(nproc)
$ sudo make install
```
**You should set WITH_GSTREAMER=ON -D WITH_GSTREAMER_0_10=OFF for using recent version gstreamer**

### 5. Check openCV version
```
$pkg-config --modversion opencv
3.1.0
```
## (2) Caffe-SSD Installation 

### 0. Clone caffe-ssd repository locally:
```
git clone https://github.com/weiliu89/caffe.git caffe-ssd
cd caffe-ssd
git checkout ssd 
```

### 1. Editing `Makefile.config`: 
```
cp Makefile.config.example Makefile.config
```
* Uncomment `# USE_CUDNN := 1` to be `USE_CUDNN := 1` (optional)
* Uncomment `# OPENCV_VERSION := 3` to be `OPENCV_VERSION := 3` 
* Uncomment `# BLAS := atlas` to be `BLAS := atlas`
* Comment `BLAS := open` to be `#BLAS := open`
* Change `INCLUDE DIRS :=` to be `INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial`
* Change `LIBRARY_DIRS :=` to be `LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/aarch64-linux-gnu/hdf5/serial/`
* Add -gencode arch=compute_62,code=sm_62  and `-gencode arch=compute_62,code=compute_62` to `CUDA_ARCH:=`\


### 2. Make link files for build
```
cd /usr/lib/aarch64-linux-gnu/
sudo ln libhdf5_serial.so.10.1.0 libhdf5.so
sudo ln libhdf5_serial_hl.so.10.0.2 libhdf5_hl.so
sudo ldconfig
```

### 3. Build
```
make -j $(nproc)
```

### 4. Build Py(=python version Caffe-SSD) (optional) 
```
$ cd python 
$ for req in $(cat requirements.txt); do sudo pip install $req; done
(upgrade pip version might be needed)
$ make py-j $(nproc)
```

Add following three lines to `~/.bashrc` and restart a bash 
```
export CAFFE_ROOT=[root to caffe's parent directory]/caffe
export PYTHONPATH=$CAFFE_ROOT/python:$PYTHONPATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$CAFFE_ROOT/.build_release/lib:
$LD_LIBRARY_PATH
```


### 5. Check caffe-ssd could be imported to Python (optional)
```
$ python
Python 2.7.12 (default, Nov 19 2016, 06:48:10) 
[GCC 5.4.0 20160609] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import caffe
/usr/lib/python2.7/dist-packages/matplotlib/font_manager.py:273: UserWarning: Matplotlib is building the font cache using fc-list. This may take a moment.
  warnings.warn('Matplotlib is building the font cache using fc-list. This may take a moment.')
>>> 
```

## Reference
- http://docs.opencv.org/3.2.0/d6/d15/tutorial_building_tegra_cuda.html
- https://myurasov.github.io/2016/11/27/ssd-tx1.html
- https://github.com/hello072/Install-SSD-Caffe-on-Jetson-TX1

# ERROR RESOLVING SITES 
- KCF tracker: https://stackoverflow.com/questions/45232539/error-create-is-not-a-member-of-cvtracker
- caffe shared library: https://github.com/fyu/caffe-dilation/issues/4
- gstreamer: http://developer.ridgerun.com/wiki/index.php?title=Compile_gstreamer_on_tegra_X1_and_X2
- libopencv_tracker.so: add /usr/local/lib to LD_LIBRARY_PATH

### For drone_vip
**cation**  label_map_file: "/home/nvidia/drone_project/caffe/data/VOC0712/labelmap_voc.prototxt"
