#!/bin/bash

docker build -t converter . && docker run --rm \       
        -v $(pwd)/src:/app/src \
        -v $(pwd)/Subnets:/app/Subnets \
        -v $(pwd)/Russia:/app/Russia \
        -v $(pwd)/Ukraine:/app/Ukraine \
        -v $(pwd)/Categories:/app/Categories \
        -v $(pwd)/Services:/app/Services \
        -v $(pwd)/SRS:/app/SRS \
        -v $(pwd)/DAT:/app/DAT \
        converter
