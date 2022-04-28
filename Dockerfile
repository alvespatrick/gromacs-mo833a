FROM ubuntu:20.04 as build_stage

# Install Build Dependencies
RUN apt-get update && \
    apt-get install g++ cmake -y wget

WORKDIR /tmp/gromacs

# Copy source code
COPY . .

ARG flags="-DGMX_BUILD_OWN_FFTW=ON"

# Build
RUN mkdir build && cd build \
    && cmake .. ${flags}\
    && make -j 2 && make install

FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install cmake valgrind linux-tools-common linux-tools-generic linux-tools-`uname -r` -y

# Copy installed GROMACS from build stage
COPY --from=build_stage /usr/local/gromacs /usr/local/gromacs

ENV PATH=$PATH:/usr/local/gromacs/bin
