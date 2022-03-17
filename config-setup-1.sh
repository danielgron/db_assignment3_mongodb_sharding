echo "config setup 1" >> /log
docker exec mongocfg1 bash -c "echo 'rs.initiate({_id: \"mongors1conf\",configsvr: true, members: [{ _id : 0, host : \"mongocfg1\" },{ _id : 1, host : \"mongocfg2\" }, { _id : 2, host : \"mongocfg3\" }]})' | mongosh --quiet" >> /log
docker exec -it mongocfg1 bash -c "echo 'rs.status()' | mongo" >> /log




