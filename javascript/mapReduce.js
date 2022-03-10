results = db.runCommand({ mapReduce: ‘tweets’, map: map, reduce:reduce, out: ‘tweets.followers’})
