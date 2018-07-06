#!/bin/bash

waittime=60

./03_SPO-Usage/01b_update-contract.sh

echo "Die Aktienpreise werden nun alle $waittime Sekunden von der Web-Rest-API abgefragt und durch den Smart Contract auf die Blockchain geschrieben. Änderungen an den Werten werden hervorgehoben."

# use watch command to start the update script every 60 seconds
watch -n $waittime -d "./03_SPO-Usage/01b_update-contract.sh"
