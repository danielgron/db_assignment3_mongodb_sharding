db.system.js.save({
 _id: 'mostFollowers'
value: function(collection)
{
return collection.find({}).sort({'tweets.user.followers_count':1}).limit(10)[0];
}
})


//Next command

use tweets

// Next command

db.loadServerScripts()

// Next command

mostFollowers(db.tweets).display

