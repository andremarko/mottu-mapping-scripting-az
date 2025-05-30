source ./config.sh

VM_IP=$(az vm show \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --show-details \
  --query publicIps \
  --output tsv)

VM_IP=$(echo "$VM_IP" | tr -d '\r\n')
USERNAME=$(echo "$USERNAME" | tr -d '\r\n')

scp -v -i $SSH_KEY "$HOME/.ssh/id_ed25519" "$USERNAME@$VM_IP:/home/$USERNAME/.ssh/"
scp -v -i $SSH_KEY [0-9][0-9]-vm* "$USERNAME@$VM_IP:/home/$USERNAME/"

ssh -i $SSH_KEY $USERNAME@$VM_IP << EOF
  chmod +x /home/$USERNAME/[0-9][0-9]-vm*
  echo "Permissões ajustadas com sucesso."
EOF