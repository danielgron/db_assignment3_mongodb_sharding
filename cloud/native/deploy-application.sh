USER=$1
TWITTER=$2

su $USER

sudo rm -r /repo
sudo mkdir /repo && sudo chgrp docker /repo
git clone https://github.com/danielgron/db_assignment3_mongodb_sharding.git /repo/
docker-compose -f /repo/docker-compose.application.yml down
TWITTER=$TWITTER docker-compose -f /repo/docker-compose.application.yml up -d --build