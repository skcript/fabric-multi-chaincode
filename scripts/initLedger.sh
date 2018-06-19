#!/bin/bash

# Exit on first error, print all commands.
set -ev
source ${PWD}/scripts/.env

# Init Ledger in First Channel
docker exec cli peer chaincode invoke -o orderer.example.com:7050  --tls --cafile $ORDERER_CA -C $CHANNEL_ONE_NAME -n $FIRST_CHAINCODE_NAME -c '{"Args":["initLedger"]}'

# Init Ledger in Second Channel
docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" cli peer chaincode invoke -o orderer.example.com:7050  --tls --cafile $ORDERER_CA -C $CHANNEL_TWO_NAME -n $SECOND_CHAINCODE_NAME -c '{"Args":["initLedger"]}'

    
