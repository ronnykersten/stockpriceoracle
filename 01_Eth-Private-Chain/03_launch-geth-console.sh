#!/bin/bash

# launch ethereum client in interactive mode (private chain)
geth --datadir "/app/01_Eth-Private-Chain/data" --networkid 15 --port 11111 --nodiscover console
