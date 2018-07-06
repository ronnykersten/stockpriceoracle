#!/bin/bash

rm -f ./temp/temp_create_entry.js
touch ./temp/temp_create_entry.js

. ./persistent/contract-address.txt
echo "Überwachte Aktienliste:" $STOCKLIST 
echo "Adresse Smart Contract:" $ContractAddress 
echo ""


echo -n 'primary = eth.accounts[0];
personal.unlockAccount(primary, "")

publishedContractAddr = "' >> ./temp/temp_create_entry.js

echo -n $ContractAddress >> ./temp/temp_create_entry.js
echo '"' >> ./temp/temp_create_entry.js

echo '
contractAbi = [{"constant":false,"inputs":[{"name":"_newStock","type":"string"}],"name":"createListEntry","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"stocks","outputs":[{"name":"name","type":"string"},{"name":"price","type":"uint256"},{"name":"updateTime","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_stockId","type":"uint256"},{"name":"_stockPrice","type":"uint256"}],"name":"updateValue","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"renounceOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"viewListedStocks","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_stockId","type":"uint256"}],"name":"priceOf","outputs":[{"name":"_stockName","type":"string"},{"name":"_price","type":"uint256"},{"name":"_timestamp","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_listedStocks","type":"string"}],"name":"setListedStocks","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_name","type":"string"}],"name":"nameToId","outputs":[{"name":"_id","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_listedStocks","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"stockId","type":"uint256"},{"indexed":false,"name":"name","type":"string"},{"indexed":false,"name":"price","type":"uint256"},{"indexed":false,"name":"updateTime","type":"uint256"}],"name":"StockUpdate","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"stockId","type":"uint256"},{"indexed":false,"name":"name","type":"string"}],"name":"NewStockAdded","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"}],"name":"OwnershipRenounced","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"},{"indexed":true,"name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"}]
contractInterface = eth.contract(contractAbi)
StockPriceOracle = contractInterface.at(publishedContractAddr)' >> ./temp/temp_create_entry.js


## einzeln die Werte aus Stocklist auslesen und Entrys erstellen
echo $STOCKLIST | grep -oE "[^-][A-Z]{1,4}" | while read -r line ; do
    echo 'StockPriceOracle.createListEntry("'$line'", {from: primary});' >> ./temp/temp_create_entry.js
done

echo 'miner.start(4); admin.sleepBlocks(1); miner.stop();' >> ./temp/temp_create_entry.js
