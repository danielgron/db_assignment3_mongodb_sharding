docker exec mongos1 bash -c "echo 'sh.addShard(\"mongors1/db-ass-mongo-shard1-1\")' | mongosh --quiet"
docker exec mongos1 bash -c "echo 'sh.addShard(\"mongors2/db-ass-mongo-shard2-1\")' | mongosh --quiet"

echo "Setup Shards"
docker exec mongos1 bash -c "echo 'sh.enableSharding(\"twitter\")' | mongosh --quiet "
docker exec mongos1 bash -c "echo 'sh.shardCollection(\"twitter.tweets\", {\"source\" : \"hashed\"})' | mongosh --quiet"

echo "Import data"
docker exec mongos1 bash -c "mongoimport --db twitter --collection tweets --type json /docker/data/twitter.json"