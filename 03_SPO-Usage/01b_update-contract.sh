#!/bin/bash

# utilizes the contract (address) from previous scripts and updates it with current stock prices

# import values as bash variables
. ./persistent/contract-address.txt
echo "Ueberwachte Aktienliste:" $STOCKLIST 
echo "Adresse Smart Contract:" $ContractAddress 
echo ""

# separate the values in the stocklist variable and for each: get price from Rest-API and "post" it to our blockchain
# assumption: every stock name is 1 to 4 characters and separated with a hyphen
echo $STOCKLIST | grep -oE "[^-][A-Z]{1,4}" | while read -r line ; do
    echo "Abfrage Preis von Webservice fuer: $line"
    PREIS=$(curl -s "https://api.iextrading.com/1.0/stock/$line/price")
    echo "Antwort in USD: $PREIS"
    # convert usd-value to usd-cent-value (to have unsigned integer for the smart contract)
    PREIS=$(echo "$PREIS" | sed "s/\.//g")
    echo "Umgerechnet in USDct: $PREIS"
    echo -n "Neuer Wert auf Blockchain: "

    ./03_SPO-Usage/01c_create-temp-js.sh $ContractAddress $line $PREIS

    geth --verbosity "1" --datadir "/app/01_Eth-Private-Chain/data" --exec 'loadScript("/app/temp/temp_update-stock-price.js")' --networkid 15 --port 11111 --nodiscover console | sed "s/true/ /g"
  
done

