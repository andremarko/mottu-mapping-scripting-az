source ./config.sh

VM_IP=$(az vm show \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --show-details \
  --query publicIps \
  --output tsv)

scp -i $SSH_KEY ~/.ssh/id_ed25519.pub $USERNAME@$VM_IP:~/.ssh/
scp -i $SSH_KEY [0-9][0-9]-vm* $USERNAME@$VM_IP:/home/$USERNAME/

