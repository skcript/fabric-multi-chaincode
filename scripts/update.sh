#!/bin/bash

# Exit on first error, print all commands.
set -ev
CHAINCODE_NAME="mycc"
CHAINCODE_SRC="github.com/chaincode"
CHAINCODE_VERSION="9.0"
CHANNEL_NAME="mychannel"
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

docker exec cli peer chaincode install -n $CHAINCODE_NAME -p $CHAINCODE_SRC -v $CHAINCODE_VERSION

docker exec cli peer chaincode upgrade -o orderer.example.com:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -c '{"Args":[]}' -n $CHAINCODE_NAME -v $CHAINCODE_VERSION -P "OR('Org1MSP.member', 'Org2MSP.member', 'Org11MSP.member')"

docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" cli peer chaincode install -n $CHAINCODE_NAME -p $CHAINCODE_SRC -v $CHAINCODE_VERSION

docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" cli peer chaincode upgrade -o orderer.example.com:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -c '{"Args":["init","a","100"]}' -n $CHAINCODE_NAME -v $CHAINCODE_VERSION -P "OR ('Org1MSP.member', 'Org2MSP.member', 'Org11MSP.member')"