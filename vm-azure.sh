if [ ! -f $HOME/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/id_rsa -N ""
else
    echo "Chave SSH já existe, não será criada uma nova."
fi

user=$(whoami)
projectName="mottuVision"
RESOURCE_GROUP="rg-${projectName}"
VM_NAME="vm-${projectName}"
LOCATION="brazilsouth"
USERNAME="admmottuvision"
IMAGE="Oracle:Oracle-Linux:ol810-lvm-gen2:8.10.1"
STORAGE_SKU_OS="Standard_LRS"
STORAGE_SKU_HDD="Standard_LRS"
SSH_KEY="$HOME/.ssh/id_rsa"
SIZE="Standard_D2ls_v5"

# maquina atual
sudo yum -y update
sudo yum -y upgrade
sudo yum install maven -y
sudo yum install java-21-openjdk -y

# criando máquina virtual
# capacidade de 30gb em SSD
# capacidade de 10gb (HDD extra)
az vm create \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME \
    --image $IMAGE \
    --size $SIZE \
    --location $LOCATION \
    --public-ip-address \
    --admin-username $USERNAME \
    --authentication-type ssh \
    --ssh-key-values $SSH_KEY \
    --storage-sku $STORAGE_SKU_OS \
    --os-disk-size-gb 30 \
    --data-disk-sku $STORAGE_SKU_HDD \
    --data-disk-size-gb 10 \

az network nsg rule create \
    --resource-group rg-${projectName} \
    --nsg-name nsgr-${projectName} \
    --name port_8080 \
    --protocol tcp \
    --priority 1010 \
    --destination-port-range 8080 \
    --access Allow \
    --direction Inbound \
    --source-address-prefixes '*' \
    --destination-address-prefixes '*'

## capturando IP da máquina criada
VM_IP=$(az vm show \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --show-details \
  --query publicIps \
  --output tsv)

# maquina atual
cd /home/${projectName}-backend/ && mvn clean package

# copiando o .jar e o dockerFile para /app da maquina remota
scp -i $SSH_KEY "/home/${user}/${projectName}-backend/target/*-1.0-SNAPSHOT.jar" $USERNAME@$VM_IP:/home/$USERNAME/app/
scp -i $SSH_KEY /home/${user}/scripts/Dockerfile $USERNAME@$VM_IP:/home/$USERNAME/app/

# acessando maquina criada
ssh -i $SSH_KEY $USERNAME@$VM_IP << EOF 
    projectName="mottuVision"
    USERNAME="admmottuvision"

    sudo yum update -y
    sudo yum upgrade -y

    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
    sudo yum install docker-ce docker-ce-cli containerd.io 

    sudo systemctl enable docker
    sudo systemctl start docker
 
    cd /home/$USERNAME/app

    sudo docker build -t $projectName-backend-image .

    sudo docker image ls

    if sudo docker images -q $projectName-backend-image; then
        echo "IMAGE CREATED"        
    else
        echo "IMAGE DOES NOT EXIST"
        exit 1
    fi
    
    sudo docker run -d --name $projectName-backend -p 8080:80 $projectName-backend-image
EOF