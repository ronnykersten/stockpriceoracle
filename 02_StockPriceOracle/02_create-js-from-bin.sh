#!/bin/bash


rm -f ./temp/contract-as-javascript.js
touch ./temp/contract-as-javascript.js

echo -n 'contractHex = "0x' >> ./temp/contract-as-javascript.js
cat ./02_StockPriceOracle/out/StockPriceOracle.bin >> ./temp/contract-as-javascript.js
echo '"' >> ./temp/contract-as-javascript.js

echo -n 'contractAbi = ' >> ./temp/contract-as-javascript.js
cat ./02_StockPriceOracle/out/StockPriceOracle.abi >> ./temp/contract-as-javascript.js

echo "" >> ./temp/contract-as-javascript.js
echo 'contractInterface = eth.contract(contractAbi)' >> ./temp/contract-as-javascript.js
