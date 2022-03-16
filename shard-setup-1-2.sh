
docker exec mongors bash -c "echo 'use twitter' | mongo"
docker exec mongos1 bash -c "echo 'sh.enableSharding(\"twitter\")' | mongo "