#!/bin/bash

# Build our code
cd /php-driver/ext
phpize
cd ../
mkdir -p build && cd build
../ext/configure
make

# Build our debian package
cd ../ext/packaging/
./build_deb.sh
