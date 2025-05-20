#!/bin/bash

set -e
source ./config.sh

VM_IP=$(az vm show \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --show-details \
  --query publicIps \
  --output tsv)

scp -i $SSH_KEY ./setup-vm.sh ./Dockerfile ./deploy_backend.sh ./env.properties $USERNAME@$VM_IP:/home/$USERNAME/