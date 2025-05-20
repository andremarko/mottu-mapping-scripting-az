#!/bin/bash
set -e
source ./config.sh

echo "Deletando o resource group $RESOURCE_GROUP e todos os recursos dentro..."

az group delete --name $RESOURCE_GROUP --yes --no-wait

echo "Pedido de exclusão enviado. O Azure está removendo todos os recursos do grupo."
