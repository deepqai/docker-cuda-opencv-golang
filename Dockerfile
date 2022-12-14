FROM nvidia/cuda:10.1-devel-ubuntu16.04
# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        cmake \
        build-essential \
        git \
        pkg-config \
        libatlas-base-dev \
        libatlas-dev \
        libjpeg8-dev \
        libpng12-dev \
	wget && \
    rm -rf /var/lib/apt/lists/*

# Install OpenCV
RUN git clone --depth 1 -b 3.4.6 https://github.com/opencv/opencv.git /opencv && \
    git clone --depth 1 -b 3.4.6 https://github.com/opencv/opencv_contrib.git /opencv_contrib && \
    mkdir /opencv/build && cd /opencv/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D WITH_CUDA=ON -D WITH_TBB=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -D WITH_CUBLAS=1 -D WITH_QT=OFF .. && \
    make -j"$(nproc)" install && \
    ldconfig && \
    rm -rf /opencv /opencv_contrib

# Install golang
ENV GOLANG_VERSION 1.19
RUN wget -nv -O - https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz \
    | tar -C /usr/local -xz
ENV PATH /usr/local/go/bin:$PATH
