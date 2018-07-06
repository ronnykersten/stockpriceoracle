#!/bin/bash

## no production use with empty password recommended!

# remove existing keys
#rm /app/01_Eth-Private-Chain/data/keystore

# create account with geth (account = private/public key pair)
geth --datadir "/app/01_Eth-Private-Chain/data" account new --password <(echo "")

# get the public key from the created file
my_public_key="$(grep -r "address" /app/01_Eth-Private-Chain/data/keystore | sed 's/^.*{"address":"//g' | sed 's/","crypto.*$//g')"

# use the new public key in genesis block of the new blockchain to receive initial funds
cat ./01_Eth-Private-Chain/CustomGenesis.json | sed "s/baf2d5f91c54b0c5fc8ed52b9744a10b46e590a2/$my_public_key/g" > /app/01_Eth-Private-Chain/CustomGenesis2.json

