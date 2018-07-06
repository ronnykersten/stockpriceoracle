#!/bin/bash

# build js-commands to update stock prices on the blockchain


rm -f ./temp/temp_update-stock-price.js
touch ./temp/temp_update-stock-price.js

# arguments handed over from command line
APPADRESSE=$1
AKTIENNAME=$2
AKTIENPREIS=$3

echo -n 'primary = eth.accounts[0];
personal.unlockAccount(primary, "")

publishedContractAddr = "' >> ./temp/temp_update-stock-price.js

echo -n $APPADRESSE >> ./temp/temp_update-stock-price.js
echo '"' >> ./temp/temp_update-stock-price.js

# TODO: replace hard coded ABI-string with the one from the .abi-file (otherwise: script could break if smart contract is changed enough)
echo -n '
contractAbi = [{"constant":false,"inputs":[{"name":"_newStock","type":"string"}],"name":"createListEntry","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"stocks","outputs":[{"name":"name","type":"string"},{"name":"price","type":"uint256"},{"name":"updateTime","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_stockId","type":"uint256"},{"name":"_stockPrice","type":"uint256"}],"name":"updateValue","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"renounceOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"viewListedStocks","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_stockId","type":"uint256"}],"name":"priceOf","outputs":[{"name":"_stockName","type":"string"},{"name":"_price","type":"uint256"},{"name":"_timestamp","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_listedStocks","type":"string"}],"name":"setListedStocks","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_name","type":"string"}],"name":"nameToId","outputs":[{"name":"_id","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_listedStocks","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"stockId","type":"uint256"},{"indexed":false,"name":"name","type":"string"},{"indexed":false,"name":"price","type":"uint256"},{"indexed":false,"name":"updateTime","type":"uint256"}],"name":"StockUpdate","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"stockId","type":"uint256"},{"indexed":false,"name":"name","type":"string"}],"name":"NewStockAdded","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"}],"name":"OwnershipRenounced","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"},{"indexed":true,"name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"}]
contractInterface = eth.contract(contractAbi)
StockPriceOracle = contractInterface.at(publishedContractAddr)
StockId = StockPriceOracle.nameToId("' >> ./temp/temp_update-stock-price.js

echo -n "$AKTIENNAME">> ./temp/temp_update-stock-price.js

echo -n '", {from: primary});
StockPrice = ' >> ./temp/temp_update-stock-price.js

echo "$AKTIENPREIS" >> ./temp/temp_update-stock-price.js

echo '
StockPriceOracle.updateValue(StockId, StockPrice, {from: primary});
miner.start(4); admin.sleepBlocks(1); miner.stop();
console.log(StockPriceOracle.priceOf(StockId));
' >> ./temp/temp_update-stock-price.js
