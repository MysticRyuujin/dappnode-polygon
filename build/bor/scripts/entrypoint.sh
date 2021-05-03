#!/bin/bash

# exit script on any error
set -e
echo "setting up initial configurations"

BOR_HOME=/datadir

if [ ! -f "$BOR_HOME/genesis.json" ];
then
    cd $BOR_HOME

    echo "downloading launch genesis file"
    wget https://raw.githubusercontent.com/maticnetwork/launch/master/mainnet-v1/without-sentry/bor/genesis.json

    echo "initializing bor with genesis file"
    bor --datadir /datadir init /datadir/genesis.json
fi
