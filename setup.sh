GROUP='mongo'
VMSIZE='Standard_B1ls'
#IMG='Canonical:UbuntuServer:16_04_0-lts-gen2:16.04.202109280'
IMG='ubuntults'
LOCATION='northeurope'
NSG='mongo-nsg'


az group create --name $GROUP --location northeurope 

az network vnet create --name 'mongo-vnet' --resource-group $GROUP
az network nsg create -n $NSG -g $GROUP
az network nsg rule create -n 'mongo' -g $GROUP --nsg-name $NSG --priority 700   \
--direction Inbound --access Allow --protocol Tcp --description "Allow mongo traffic" --destination-port-ranges '27017'

az network nsg rule create -n 'ssh' -g $GROUP --nsg-name $NSG --priority 750   \
--direction Inbound --access Allow --protocol Tcp --description "Allow ssh traffic" --destination-port-ranges '22'

az vm create -g $GROUP -n mongo-config --image $IMG --size Standard_B1ms \
--location $LOCATION --public-ip-address db-ass-mongo-config --generate-ssh-keys --nsg $NSG

#az vm create -g $GROUP -n mongo-shard1 --image $IMG --size $VMSIZE \
#--location $LOCATION --public-ip-address db-ass-mongo-shard1 --generate-ssh-keys --nsg $NSG

#az vm create -g $GROUP -n mongo-shard2 --image $IMG --size $VMSIZE \
#--location $LOCATION --public-ip-address db-ass-mongo-shard2 --generate-ssh-keys --nsg $NSG

#az vm create -g $GROUP -n mongo-shard3 --image $IMG --size $VMSIZE \
#--location $LOCATION --public-ip-address db-ass-mongo-shard3 --generate-ssh-keys --nsg $NSG


az network public-ip update --resource-group $GROUP --name db-ass-mongo-config --dns-name db-ass-mongo-config
#az network public-ip update --resource-group $GROUP --name db-ass-mongo-shard1 --dns-name db-ass-mongo-shard1
#az network public-ip update --resource-group $GROUP --name db-ass-mongo-shard2 --dns-name db-ass-mongo-shard2
#az network public-ip update --resource-group $GROUP --name db-ass-mongo-shard3 --dns-name db-ass-mongo-shard3


az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
--scripts "curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh && groupadd docker && usermod -aG docker \$USER && newgrp docker"

az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
--scripts "fallocate -l 2G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && echo \"\n/swapfile swap swap defaults 0 0\" >> /etc/fstab"


#--scripts "wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add - && echo \"deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list && apt-get update && sudo apt-get install -y mongodb-org"

#az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
#--scripts "docker run -d --name mongocfg1 --memory=100m --memory-swap=700m --volume \"/mongo_cluster/config1:/data/db\" mongo:5.0.6  mongod --configsvr --replSet mongors1conf --dbpath /data/db --port 27017"

#az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
#--scripts "docker run -d --name mongocfg2 --memory=100m --memory-swap=700m --volume \"/mongo_cluster/config2:/data/db\" mongo:5.0.6  mongod --configsvr --replSet mongors1conf --dbpath /data/db --port 27017"

#az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
#--scripts "docker run -d --name mongocfg3 --memory=100m --memory-swap=700m --volume \"/mongo_cluster/config3:/data/db\" mongo:5.0.6  mongod --configsvr --replSet mongors1conf --dbpath /data/db --port 27017"
echo "Install docker-compose"
az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
--scripts "mkdir /docker && chmod 777 /docker && curl https://raw.githubusercontent.com/danielgron/db_assignment3_mongodb_sharding/main/docker-compose.yml -o /docker/docker-compose.yml"

az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
--scripts "curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64\" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose"

echo "Start docker containers"
az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
--scripts "docker-compose -f /docker/docker-compose.yml up -d"


echo "Start configuration"

az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
--scripts "curl https://raw.githubusercontent.com/danielgron/db_assignment3_mongodb_sharding/main/config-setup.sh -o /docker/config-setup.sh && chmod 777 /docker/config-setup.sh && ./docker/config-setup.sh"

#az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
#--scripts "docker exec -it mongocfg1 bash -c \"echo 'rs.initiate({_id: \\\"mongors1conf\\\",configsvr: true, members: [{ _id : 0, host : \\\"mongocfg1\\\" },{ _id : 1, host : \\\"mongocfg2\\\" }, { _id : 2, host : \\\"mongocfg3\\\" }]})' | mongo\""

# docker exec -it mongocfg1 bash -c "echo 'rs.initiate({_id: \"mongors1conf\",configsvr: true, members: [{ _id : 0, host : \"mongocfg1\" }, { _id : 1, host : \"mongocfg2\" }]})' | mongo"

#az vm run-command invoke -g $GROUP -n mongo-config --command-id RunShellScript \
#--scripts "docker run -d --name mongos --memory=100m --memory-swap=600m -p \"27017:27017\" mongo:5.0.6  mongos --configdb mongors1conf/mongocfg1:27017,mongocfg2:27017,mongocfg3:27017 --port 27017"



#az vm run-command invoke -g $GROUP -n mongo-shard1 --command-id RunShellScript \
#--scripts "curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh && groupadd docker && usermod -aG docker \$USER && newgrp docker"

#az vm run-command invoke -g $GROUP -n mongo-shard2 --command-id RunShellScript \
#--scripts "curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh && groupadd docker && usermod -aG docker \$USER && newgrp docker"

#az vm run-command invoke -g $GROUP -n mongo-shard3 --command-id RunShellScript \
#--scripts "curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh && groupadd docker && usermod -aG docker \$USER && newgrp docker"
