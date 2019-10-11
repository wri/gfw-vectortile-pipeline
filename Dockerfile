# Use Ubuntu 18.08 LTS with Latest GDAL 2 version preinstalled
FROM geographica/gdal2:latest

# Update repos and install dependencies
RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get -y install build-essential libsqlite3-dev zlib1g-dev git curl jq python3-pip

# Install TippeCanoe
ENV TIPPECANOE_VERSION=1.34.3
RUN curl https://codeload.github.com/mapbox/tippecanoe/tar.gz/${TIPPECANOE_VERSION} | tar -xz
WORKDIR tippecanoe-${TIPPECANOE_VERSION}
RUN make && make install

# Install tileputty
RUN pip3 install tileputty

# Copy pipeline script
WORKDIR /usr/local/bin
COPY run_pipeline.sh .
RUN chmod +x run_pipeline.sh

CMD /bin/bash