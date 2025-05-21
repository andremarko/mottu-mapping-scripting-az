source ./config.sh

VM_IP=$(az vm show \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --show-details \
  --query publicIps \
  --output tsv)

scp -i $SSH_KEY [0-9][0-9]-vm* $USERNAME@$VM_IP:/home/$USERNAME/
