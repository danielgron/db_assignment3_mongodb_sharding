map = function()
{
var names = distinctName(this);
emit({
 names: names,
follower_count: this.components.user.follower_count
},{
count: 1
});
}

