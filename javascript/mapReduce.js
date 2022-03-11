results = db.runCommand
(
  { 
    mapReduce: ‘tweets’, 
    map: map, 
    reduce:reduce, 
    out: ‘users.follower_count’
  }
)
