#!/bin/bash

# horario de desligamento

set -e
source ./config.sh

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
    --data-disk-sku $STORAGE_SKU_HDD \
    --data-disk-size-gb 10

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