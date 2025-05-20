user=$(whoami)
projectName="mottu-mapping"
RESOURCE_GROUP="rg-${projectName}"
VM_NAME="vm-${projectName}"
LOCATION="brazilsouth"
USERNAME="mappingadmin"
IMAGE="Oracle:Oracle-Linux:ol810-lvm-gen2:8.10.1"
STORAGE_SKU_OS="Standard_LRS"
STORAGE_SKU_HDD="Standard_LRS"
#PASSWORD="Mottumapping2025!#"
#SSH_KEY="$HOME/.ssh/id_rsa"
SIZE="Standard_D2ls_v5"
SSH_KEY="/.ssh/-.pub"

az vm create \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME \
    --image $IMAGE \
    --size $SIZE \
    --location $LOCATION \
    --public-ip-address \
    --admin-username $USERNAME \
    --authentication-type ssh \
    --generate-ssh-keys \
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

VM_IP=$(az vm show \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --show-details \
  --query publicIps \
  --output tsv)

scp -i $SSH_KEY "/home/$user/Dockerfile" $USERNAME@$VM_IP:/home/$USERNAME/

ssh -i $SSH_KEY $USERNAME@$VM_IP << EOF 
    projectName="mottu-mapping"
    USERNAME="mappingadmin"

    sudo yum update -y
    sudo yum upgrade -y

    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
    sudo yum install -y docker-ce docker-ce-cli containerd.io 

    sudo systemctl enable docker
    sudo systemctl start docker

    sudo groupadd docker
    sudo usermod -aG docker $USERNAME

    sudo yum install -y java-21-openjdk
    sudo yum install -y maven 
 
    mkdir /home/$USERNAME/app

    cd /home/$USERNAME/app

    git clone https://github.com/andremarko/mottu-mapping-api-java.git 
    
    cd mottu-mapping-api-java

    mvn clean package 

    mv /home/$USERNAME/Dockerfile /home/$USERNAME/app/mottu-mapping-api-java/target

    cd target



    docker build -t $projectName-backend-image .

    docker image ls

    if sudo docker images -q $projectName-backend-image; then
        echo "IMAGE CREATED"        
    else
        echo "IMAGE DOES NOT EXIST"
        exit 1
    fi
    
    # CONFERIR COMANDOS DE ENTRYPOINT
    sudo docker run -d --name $projectName-backend -p 8080:80 $projectName-backend-image
EOF
