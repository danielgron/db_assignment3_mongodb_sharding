
docker exec mongors bash -c "echo 'rs.initiate({_id : \"mongors2\", members: [{ _id : 0, host : \"db-ass-mongo-shard2-1\" },{ _id : 1, host : \"db-ass-mongo-shard2-2\" }]})' | mongo"