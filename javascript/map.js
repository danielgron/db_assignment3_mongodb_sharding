map = function()
{
 var names = distinctName(this);
 emit
 (
  {
   names: names,
   followers_count: this.components.tweets.user.followers_count
  },{
   count: 1
  }
 );
}

