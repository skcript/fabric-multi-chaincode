#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

source ${PWD}/scripts/.env
export PATH=$PATH:${PWD}/bin
export FABRIC_CFG_PATH=${PWD}


# remove previous crypto material and config transactions
rm -fr channel-artifacts/*
rm -fr crypto-config/*
mkdir -p crypto-config config


# generate crypto material
cryptogen generate --config=./crypto-config.yaml
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

# generate genesis block for orderer
configtxgen -profile OrdererGenesis -outputBlock ./channel-artifacts/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi

# generate channel configuration transaction
configtxgen -profile ${CHANNEL_MCU_PROFILE} -outputCreateChannelTx ./channel-artifacts/${CHANNEL_MCU_NAME}.tx -channelID $CHANNEL_MCU_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

# generate channel configuration transaction
configtxgen -profile ${CHANNEL_CH_PROFILE} -outputCreateChannelTx ./channel-artifacts/${CHANNEL_CH_NAME}.tx -channelID $CHANNEL_CH_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi



# generate anchor peer for public channel transaction 
configtxgen -profile ${CHANNEL_MCU_PROFILE} -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors_${CHANNEL_MCU_NAME}.tx -channelID $CHANNEL_MCU_NAME -asOrg Org1MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi


# generate anchor peer for public channel transaction 
configtxgen -profile ${CHANNEL_MCU_PROFILE} -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors_${CHANNEL_MCU_NAME}.tx -channelID $CHANNEL_MCU_NAME -asOrg Org2MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi


# generate anchor peer for private channel transaction 
configtxgen -profile ${CHANNEL_CH_PROFILE} -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors_${CHANNEL_CH_NAME}.tx -channelID $CHANNEL_CH_NAME -asOrg Org2MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org2MSP..."
  exit 1
fi