docker exec mongos1 bash -c "echo 'sh.addShard(\"mongors1/db-ass-mongo-shard1-1\")' | mongo"
docker exec mongos1 bash -c "echo 'sh.addShard(\"mongors2/db-ass-mongo-shard2-1\")' | mongo"

docker exec mongos bash -c "echo 'sh.enableSharding(\"twitter\")' | mongo "
docker exec mongos bash -c "echo 'sh.shardCollection(\"twitter.tweets\", {\"source\" : \"hashed\"})' | mongo "



docker exec mongos bash -c "mongoimport --db twitter --collection tweets --type json /docker/data/twitter.json"