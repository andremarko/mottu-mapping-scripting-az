#!/bin/bash

# horario de desligamento

set -e
source ./config.sh

az group create --name $RESOURCE_GROUP --location $LOCATION

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
    --os-disk-size-gb 30

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
  --time 21:30 

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

NIC_NAME=$(az vm show \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --query 'networkProfile.networkInterfaces[0].id' \
  --output tsv | awk -F/ '{print $NF}')

az network nic update \
  --resource-group $RESOURCE_GROUP \
  --name $NIC_NAME \
  --network-security-group nsgr-${projectName}