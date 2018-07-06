#!/bin/bash

# this script executes all helper scripts to compile the smart contract, publish it to our new blockchain and then initialize it


rm -f ./persistent/contract-address.txt
touch ./persistent/contract-address.txt

rm -f ./temp/temp.js
touch ./temp/temp.js


# compile smart contract
./02_StockPriceOracle/01_compile-with-solc.sh
# create js: write smart contract binary in a javascript variable
./02_StockPriceOracle/02_create-js-from-bin.sh
# create js: publish smart contract to blockchain
./02_StockPriceOracle/03_create-js-to-publish.sh

# concatenate js
cat ./temp/contract-as-javascript.js >> ./temp/temp.js
cat ./temp/publish-contract.js >> ./temp/temp.js

# execute the js-commands with ethereum client and save the address of the smart contract
geth --datadir "/app/01_Eth-Private-Chain/data" --exec 'loadScript("/app/temp/temp.js")' --networkid 15 --port 11111 --nodiscover console >> ./persistent/contract-address.txt

# clean up file for use as bash variable declaration 
cat ./persistent/contract-address.txt | sed "s/true/ /g" > ./persistent/contract-address.txt

# create js: populate empty StockArray of smart contract 
./02_StockPriceOracle/04_init_entrys.sh

# execute the created js
#geth --exec 'loadScript("/app/temp/temp_create_entry.js")' attach ipc:/app/01_Eth-Private-Chain/data/geth.ipc
geth --datadir "/app/01_Eth-Private-Chain/data" --exec 'loadScript("/app/temp/temp_create_entry.js")' --networkid 15 --port 11111 --nodiscover console 

