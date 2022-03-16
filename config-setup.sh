#curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64\" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

docker exec -it mongocfg1 bash -c "echo 'rs.initiate({_id: \"mongors1conf\",configsvr: true, members: [{ _id : 0, host : \"mongocfg1\" },{ _id : 1, host : \"mongocfg2\" }, { _id : 2, host : \"mongocfg3\" }]})' | mongo"