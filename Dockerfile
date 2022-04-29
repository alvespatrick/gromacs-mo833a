FROM ubuntu:20.04

# Install Build Dependencies
RUN apt-get update && \
    apt-get install g++ cmake -y wget && \
    apt-get install cmake valgrind linux-tools-common linux-tools-generic linux-tools-`uname -r` -y

    
WORKDIR /tmp/gromacs

# Copy source code
COPY . .

ARG flags="Release"

# Build
RUN mkdir build && cd build \
    && cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DCMAKE_BUILD_TYPE=${flags} \
    && make -j 2 && make install

ENV PATH=$PATH:/usr/local/gromacs/bin
