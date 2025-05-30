#!/bin/bash

set -e
source ./config.sh

az group create --name $RESOURCE_GROUP --location $LOCATION

az network nsg create \
  --resource-group $RESOURCE_GROUP \
  --name nsgr-${projectName} \
  --location $LOCATION

az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name nsgr-${projectName} \
    --name port_8080 \
    --protocol tcp \
    --priority 1010 \
    --destination-port-range 8080 \
    --access Allow \
    --direction Inbound \
    --source-address-prefixes '*' \
    --destination-address-prefixes '*'

az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name nsgr-${projectName} \
  --name Allow-SSH \
  --protocol tcp \
  --priority 1000 \
  --destination-port-range 22 \
  --access Allow \
  --direction Inbound \
  --source-address-prefixes '*' \
  --destination-address-prefixes '*'

az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --image $IMAGE \
  --size $SIZE \
  --location $LOCATION \
  --admin-username $USERNAME \
  --authentication-type ssh \
  --generate-ssh-keys \
  --storage-sku $STORAGE_SKU_OS \
  --os-disk-size-gb 30 \
  --nsg-rule NONE \
  --nsg nsgr-${projectName}

cp /mnt/c/Users/andre/.ssh/id_rsa ~/.ssh/
chmod 600 ~/.ssh/id_rsa

az disk create \
    --resource-group $RESOURCE_GROUP \
    --name ${VM_NAME}_data_disk1 \
    --size-gb 10 \
    --sku $STORAGE_SKU_HDD

az vm disk attach \
    --resource-group $RESOURCE_GROUP \
    --vm-name $VM_NAME \
    --name ${VM_NAME}_data_disk1

az vm auto-shutdown \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --time 0030 \
