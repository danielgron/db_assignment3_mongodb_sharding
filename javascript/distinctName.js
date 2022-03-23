distinctName = function(tweets)
{
var number = tweets.components.user.screen_name + '',
   seen = []
   result = []
   i = number.length;

while(i -- )
{
seen[+number[i]]=1;
}

for(var i = 0; i<10; i++)
{
if(seen[i])
{
result[result.length]=i;
}
}
return result;
}
