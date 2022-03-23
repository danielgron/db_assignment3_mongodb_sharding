db.tweets.find().sort({'user.followers_count':-1},{followers_count:1}).limit(10)
