# Heavily inspired by: https://medium.com/the-glitcher/mongodb-sharding-9c5357a95ec1


GROUP='mongo'
VMSIZE='Standard_B1ls'
#IMG='Canonical:UbuntuServer:16_04_0-lts-gen2:16.04.202109280'
IMG='ubuntults'
LOCATION='northeurope'
NSG='mongo-nsg'
USER=$USERNAME



az group create --name $GROUP --location northeurope 

az network vnet create --name 'mongo-vnet' --resource-group $GROUP
az network nsg create -n $NSG -g $GROUP
az network nsg rule create -n 'mongo' -g $GROUP --nsg-name $NSG --priority 700   \
--direction Inbound --access Allow --protocol Tcp --description "Allow mongo traffic" --destination-port-ranges '27017'

az network nsg rule create -n 'ssh' -g $GROUP --nsg-name $NSG --priority 750   \
--direction Inbound --access Allow --protocol Tcp --description "Allow ssh traffic" --destination-port-ranges '22'

az vm create -g $GROUP -n mongo-config --image $IMG --size Standard_B1ms \
--location $LOCATION --public-ip-address db-ass-mongo-config --generate-ssh-keys --nsg $NSG --public-ip-sku Basic

az vm create -g $GROUP -n mongo-shard1-1 --image $IMG --size $VMSIZE \
--location $LOCATION --public-ip-address db-ass-mongo-shard1-1 --generate-ssh-keys --nsg $NSG --public-ip-sku Basic

az vm create -g $GROUP -n mongo-shard1-2 --image $IMG --size $VMSIZE \
--location $LOCATION --public-ip-address db-ass-mongo-shard1-2 --generate-ssh-keys --nsg $NSG --public-ip-sku Basic

az vm create -g $GROUP -n mongo-shard2-1 --image $IMG --size $VMSIZE \
--location $LOCATION --public-ip-address db-ass-mongo-shard2-1 --generate-ssh-keys --nsg $NSG --public-ip-sku Basic

az vm create -g $GROUP -n mongo-shard2-2 --image $IMG --size $VMSIZE \
--location $LOCATION --public-ip-address db-ass-mongo-shard2-2 --generate-ssh-keys --nsg $NSG --public-ip-sku Basic


az network public-ip update --resource-group $GROUP --name db-ass-mongo-config --dns-name db-ass-mongo-config
az network public-ip update --resource-group $GROUP --name db-ass-mongo-shard1-1 --dns-name db-ass-mongo-shard1-1
az network public-ip update --resource-group $GROUP --name db-ass-mongo-shard1-2 --dns-name db-ass-mongo-shard1-2
az network public-ip update --resource-group $GROUP --name db-ass-mongo-shard2-1 --dns-name db-ass-mongo-shard2-1
az network public-ip update --resource-group $GROUP --name db-ass-mongo-shard2-2 --dns-name db-ass-mongo-shard2-2

################# Setup config server ############

az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
--scripts "curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh && groupadd docker && usermod -aG docker \$USER && newgrp docker"

az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
--scripts "fallocate -l 2G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && echo \"\n/swapfile swap swap defaults 0 0\" >> /etc/fstab"


az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
--scripts "mkdir /docker && mkdir /docker/data && chmod 777 /docker && chmod 777 /docker/data && curl https://raw.githubusercontent.com/danielgron/db_assignment3_mongodb_sharding/main/docker-compose.config.yml -o /docker/docker-compose.yml && curl https://raw.githubusercontent.com/danielgron/db_assignment3_mongodb_sharding/main/twitter.json -o /docker/data/twitter.json && curl https://raw.githubusercontent.com/danielgron/db_assignment3_mongodb_sharding/main/tweets.bson -o /docker/data/twitter.bson"

az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
--scripts "curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64\" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose"

az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
--scripts "runuser -l $USERNAME -c 'sudo usermod -aG docker $USER && newgrp docker && sudo chgrp docker /usr/local/bin/docker-compose' && docker-compose -f /docker/docker-compose.yml up -d"

echo "Start configuration"

az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
--scripts "@config-setup-1.sh"


################### Setup shards ##################

echo "Setup shard 1"
### Shard 1 ###

az vm run-command invoke -g $GROUP -n mongo-shard1-1 --command-id RunShellScript \
--scripts "@shard-setup-base.sh" --parameters $USER mongors1

az vm run-command invoke -g $GROUP -n mongo-shard1-2 --command-id RunShellScript \
--scripts "@shard-setup-base.sh" --parameters $USER mongors1

echo "Setup shard 1-1"
az vm run-command invoke -g $GROUP -n mongo-shard1-1 --command-id RunShellScript \
--scripts "@shard-setup-1-1.sh"

echo "Setup shard 2"
### Shard 2 ###

az vm run-command invoke -g $GROUP -n mongo-shard2-1 --command-id RunShellScript \
--scripts "@shard-setup-base.sh" --parameters $USER mongors2

az vm run-command invoke -g $GROUP -n mongo-shard2-2 --command-id RunShellScript \
--scripts "@shard-setup-base.sh" --parameters $USER mongors2

echo "Setup shard 2-1"
az vm run-command invoke -g $GROUP -n mongo-shard2-1 --command-id RunShellScript \
--scripts "@shard-setup-2-1.sh"

##### Post config ###

echo "Start configuration pt2"
az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
--scripts "@config-setup-2.sh"


#db.setSecondary(ok) -> usereadpref