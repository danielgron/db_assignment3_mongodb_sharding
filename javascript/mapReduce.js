results = db.runCommand
(
  { 
    mapReduce: ‘tweets’, 
    map: map, 
    reduce:reduce, 
    out: ‘user.follower_count’
  }
)
