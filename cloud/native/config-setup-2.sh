USER=$1
su $USER
echo "config setup 2"
echo 'sh.addShard("mongors1/mongo-shard1-1:27018")' | mongosh --quiet
echo 'sh.addShard("mongors2/mongo-shard2-1:27018")' | mongosh --quiet

echo "sh.status()" | mongosh --quiet

echo "**Setup Shards**"
echo 'sh.enableSharding("twitter")' | mongosh --quiet
echo 'sh.shardCollection("twitter.tweets", {"source" : "hashed"})' | mongosh --quiet


echo "**Import data**"
mongoimport --db twitter --collection tweets --type json /data/twitter.json