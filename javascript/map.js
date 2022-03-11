map = function()
{
 var names = distinctName(this);
 emit
 (
  {
   names: names,
   follower_count: this.components.users.follower_count
  },{
   count: 1
  }
 );
}

