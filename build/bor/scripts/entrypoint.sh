#!/bin/sh

# exit script on any error
set -e

# Set Bor Home Directory
BOR_HOME=/datadir

# Check for genesis file and download or update it if needed
if [ ! -f "${BOR_HOME}/genesis.json" ];
then
    echo "setting up initial configurations"
    cd ${BOR_HOME}
    echo "downloading launch genesis file"
    wget https://raw.githubusercontent.com/maticnetwork/launch/master/mainnet-v1/sentry/sentry/bor/genesis.json
    echo "initializing bor with genesis file"
    bor --datadir ${BOR_HOME} init ${BOR_HOME}/genesis.json
else
    # Check if genesis file needs updating
    cd ${BOR_HOME}
    GREPSTRING=$(grep londonBlock genesis.json | wc -l) # v0-2-13 Update
    if [ ${GREPSTRING} == 0 ];
    then
        echo "Updating Genesis File"
        wget https://raw.githubusercontent.com/maticnetwork/launch/master/mainnet-v1/sentry/sentry/bor/genesis.json
        bor --datadir ${BOR_HOME} init ${BOR_HOME}/genesis.json
    fi
fi

if [ "${BOOTSTRAP}" == 1 ] && [ -n "${SNAPSHOT_URL}" ] && [ ! -f "${BOR_HOME}/bootstrapped" ];
then
  echo "downloading snapshot from ${SNAPSHOT_URL}"
  mkdir -p ${BOR_HOME}/bor/chaindata
  wget -c "${SNAPSHOT_URL}" -O - | tar -xz -C ${BOR_HOME}/bor/chaindata && touch ${BOR_HOME}/bootstrapped
fi


READY=$(curl -s http://heimdalld:26657/status | jq '.result.sync_info.catching_up')
while [[ "${READY}" != "false" ]];
do
    echo "Waiting for heimdalld to catch up."
    sleep 30
    READY=$(curl -s heimdalld:26657/status | jq '.result.sync_info.catching_up')
done

exec bor --port=40303 --maxpeers=${MAXPEERS:-200} --datadir=/datadir  --networkid=137 --syncmode=full \
    --ipcpath ${BOR_HOME}/bor.ipc --bor.heimdall=http://heimdallr:1317 \
    --txpool.accountslots=16 --txpool.globalslots=131072 --txpool.accountqueue=64 --txpool.globalqueue=131072 \
    --txpool.lifetime='1h30m0s' --miner.gaslimit=200000000  --miner.gastarget=20000000 --miner.gasprice '30000000000' \
    --http --http.addr=0.0.0.0 --http.port=8545 --http.api=eth,net,web3,txpool,bor --http.corsdomain="*" --http.vhosts="*" \
    --ws --ws.addr=0.0.0.0 --ws.port=8545 --ws.api=eth,net,web3,txpool,bor --ws.origins="*"
