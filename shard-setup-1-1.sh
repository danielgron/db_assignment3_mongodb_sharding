docker exec mongors bash -c "echo 'rs.initiate({_id : \"mongors1\", members: [{ _id : 0, host : \"mongo-shard1-1\" },{ _id : 1, host : \"mongo-shard1-2\" }]})' | mongosh --quiet"
docker exec -it mongors bash -c "echo 'rs.status()' | mongosh --quiet"
docker exec mongors bash -c "echo 'rs.secondaryOk()' | mongosh --quiet"
# Alternatively rs.initiate() -> rs.add(HOST:PORT)