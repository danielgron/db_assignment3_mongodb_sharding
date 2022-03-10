map = function()
{
var names = distinctName(this);
emit({
 names: names,
followers: this.components.followers
},{
count: 1
});
}

