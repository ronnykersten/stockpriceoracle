# the build takes 5 minutes because the blockchain needs to generate a DAG (Directed Acyclic Graph) after its first start

# Ubuntu as base
FROM ubuntu:16.04

# Install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --yes software-properties-common
RUN add-apt-repository ppa:ethereum/ethereum
RUN apt-get update && apt-get install --yes geth solc curl procps vim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Create new private key with empty password and write it to CustomGenesis2.json
RUN /app/01_Eth-Private-Chain/01_create-new-eth-account.sh

# Init private ethereum chain
RUN /app/01_Eth-Private-Chain/02_create-private-chain.sh

# Compile, publish, initialize Smart Contract
RUN /app/02_StockPriceOracle/00_publish-contract-stand-alone.sh

# volume added to make private chain and smart contract persistent
VOLUME /app/01_Eth-Private-Chain/data
VOLUME /app/persistent/

# after volume creation no more changes in that directory during build possible

ENTRYPOINT bash

# alternative entry points:
# ENTRYPOINT bash "/app/01_Eth-Private-Chain/03_launch-geth-console.sh"
# ENTRYPOINT bash "/app/03_SPO-Usage/01_update-contract-regularly.sh"


## TODO for improvement: use a user instead of root, example:
# RUN adduser --disabled-login --gecos "" eth_user
# COPY eth_common /home/eth_user/eth_common
# RUN chown -R eth_user:eth_user /home/eth_user/eth_common
# USER eth_user
# WORKDIR /home/eth_user

## REMINDER
# RUN - for building the image
# CMD - line to execute at container run (only one possible); does nothing during build
# ADD - copy files from host to image at build time 
# COPY - similar to ADD, but ADD can also use URLs or archives as source
# ENTRYPOINT - overwrites CMD; the ENTRYPOINT can get arguments you append to the docker run command
# EXPOSE 80 - expose port 80 to host
# VOLUME /app - everything in the container at /app will be persistent and can be used from other containers
# WORKDIR /app - every follwing command will be executed relative to this path; folder will be created and command can be used several times in a Dockerfile
# USER - every command will be executed as this user, if not specified then root is default
