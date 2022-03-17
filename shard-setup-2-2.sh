docker exec mongors bash -c "echo 'use twitter' | mongosh --quiet" >> /log
docker exec mongos1 bash -c "echo 'sh.enableSharding(\"twitter\")' | mongo --quiet" >> /log
