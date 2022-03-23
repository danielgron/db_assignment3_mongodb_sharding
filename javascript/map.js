map = function()
{
 var names = distinctName(this);
 emit
 (
  {
   names: this.components.user.screen_name,
   followers_count: this.components.user.followers_count
  },{
   count: 1
  }
 );
}

