#!/bin/bash

rm -f ./temp/publish-contract.js
touch ./temp/publish-contract.js


echo 'primary = eth.accounts[0];
personal.unlockAccount(primary, "")

var publishTx = contractInterface.new(
	"STOCKLIST=AAPL-TSLA-GOOGL",
  {
    from: eth.accounts[0],
    data: contractHex,
    gas: 20000000
  }
)
miner.start(4); admin.sleepBlocks(1); miner.stop();

contractTxHash = publishTx.transactionHash
eth.getTransactionReceipt(contractTxHash)
publishedContractAddr = eth.getTransactionReceipt(contractTxHash).contractAddress
console.log("ContractAddress=" + publishedContractAddr)
StockPriceOracle = contractInterface.at(publishedContractAddr)
personal.unlockAccount(primary, "")
StockPriceOracle.setListedStocks("STOCKLIST=AAPL-TSLA-GOOGL-IBM", {from: primary});
miner.start(4); admin.sleepBlocks(1); miner.stop();
console.log(StockPriceOracle.viewListedStocks());
' >> ./temp/publish-contract.js
