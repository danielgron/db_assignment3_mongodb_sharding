echo "config setup 1" >> /log
docker exec mongos1 bash -c "echo 'sh.addShard(\"mongors1/db-ass-mongo-shard1-1:27017\")' | mongosh --quiet" >> /log
docker exec mongos1 bash -c "echo 'sh.addShard(\"mongors2/db-ass-mongo-shard2-1:27017\")' | mongosh --quiet" >> /log

docker exec -it mongos1 bash -c "echo 'sh.status()' | mongosh --quiet" >> /log 

echo "**Setup Shards**\n" >> /log
docker exec mongos1 bash -c "echo 'sh.enableSharding(\"twitter\")' | mongosh --quiet " >> /log
docker exec mongos1 bash -c "echo 'sh.shardCollection(\"twitter.tweets\", {\"source\" : \"hashed\"})' | mongosh --quiet" >> /log


echo "**Import data**\n" >> /log
docker exec mongos1 bash -c "mongoimport --db twitter --collection tweets --type json /docker/data/twitter.json" >> /log