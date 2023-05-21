#!/bin/bash

dir=$(pwd)

for file in $dir/*.heic; do heif-convert $file ${file/%.heic/.jpg}; done
for file in $dir/*.HEIC; do heif-convert $file ${file/%.HEIC/.jpg}; done
