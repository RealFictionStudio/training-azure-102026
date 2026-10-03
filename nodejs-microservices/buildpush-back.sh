#!/bin/bash

RESGROUP="fishy-group"
ACRNAME="aquariumkc"
APPNAME="akwarium-szkoleniowe"

TAG=$(date +%Y%m%d-%H%M%S)
ACR="aquariumkc-h5hqd7gsfwdnf4c5.azurecr.io"

push-container() {
  CNAME=$1
  CPATH=$2
  echo -e "\e[1;94m [*] Pushing $CNAME container \e[0m"
  docker build -t $ACR/$CNAME:$TAG -f $CPATH .
  docker push $ACR/$CNAME:$TAG
}

update-containerapp() {
  CNAME=$1
  APPNAME=$2
  echo -e "\e[1;94m [*] Updating $APPNAME containerapp \e[0m"
  az containerapp update \
    --name $APPNAME\
    --resource-group $RESGROUP \
    --image $ACR/$CNAME:$TAG
}

az acr login --name $ACRNAME

push-container gateway-api ./packages/gateway-api/Dockerfile
update-containerapp gateway-api ryba-gateway
push-container dice-api ./packages/dice-api/Dockerfile
update-containerapp dice-api ryba-dice
push-container settings-api ./packages/settings-api/Dockerfile
update-containerapp settings-api ryba-settings
