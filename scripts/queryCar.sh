#!/bin/bash

# Exit on first error, print all commands.
set -ev
CHAINCODE_NAME="mycc"
CHAINCODE_SRC="github.com/chaincode"
CHAINCODE_VERSION="4.0"
CHANNEL_NAME="mychannel"
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

docker exec cli peer chaincode query -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["queryCar", "CAR12"]}'