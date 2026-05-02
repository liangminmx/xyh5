#!/bin/bash
export LD_LIBRARY_PATH=`$pwd`:$LD_LIBRARY_PATH
if [ ! -e "libssl.so" ]; then
        ln -s ./libssl.so.10 ./libssl.so
fi

if [ ! -e "libcrypto.so" ]; then
        ln -s ./libcrypto.so.10 ./libcrypto.so
fi

`pwd`/operationanalysisserver
