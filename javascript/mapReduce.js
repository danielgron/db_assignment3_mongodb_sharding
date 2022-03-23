results = db.runCommand
(
  { 
    mapReduce: 'tweets', 
    map: map, 
    reduce:reduce, 
    out: 'user.followers_count'
  }
)
