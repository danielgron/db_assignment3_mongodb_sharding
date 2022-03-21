using Microsoft.Extensions.Options;
using MongoDB.Driver;
using RestSharp;
using RestSharp.Authenticators;
using tweet_backend.Dto;

namespace tweet_backend
{
    public class TwitterService
    {
        private readonly IMongoCollection<Tweet> _tweetCollection;
        private string apiKey;

        public TwitterService(IOptions<DatabaseSettings> twitterDatabaseSettings, IConfiguration configuration)
        {
            apiKey = configuration["TWITTER"];

            var mongoClient = new MongoClient(
                twitterDatabaseSettings.Value.ConnectionString);

            var mongoDatabase = mongoClient.GetDatabase(
                twitterDatabaseSettings.Value.DatabaseName);

            _tweetCollection = mongoDatabase.GetCollection<Tweet>(
                twitterDatabaseSettings.Value.CollectionName);
        }

        public async Task<List<Tweet>> FillWithTwitter()
        {
            var client = new RestClient("https://api.twitter.com/2/")
            {
                Authenticator = new JwtAuthenticator(apiKey)
            };
            var request = new RestRequest("tweets/search/recent?query=banana&max_results=100&tweet.fields=id,created_at,text,source,lang&user.fields=id,name,username");
            var response = await client.GetAsync<TweetList>(request, new CancellationToken());

            foreach (var item in response!.Data!)
            {
                item.Id = null;
                await CreateAsync(item);
            }

            return response!.Data!;
        }

        public async Task<List<Tweet>> GetAsync() =>
            await _tweetCollection.Find(_ => true).Limit(10).ToListAsync();

        public async Task<Tweet?> GetAsync(string id) =>
            await _tweetCollection.Find(x => x.Id == id).FirstOrDefaultAsync();

        public async Task CreateAsync(Tweet newTweet) =>
            await _tweetCollection.InsertOneAsync(newTweet);

        public async Task UpdateAsync(string id, Tweet updatedTweet) =>
            await _tweetCollection.ReplaceOneAsync(x => x.Id == id, updatedTweet);

        public async Task RemoveAsync(string id) =>
            await _tweetCollection.DeleteOneAsync(x => x.Id == id);
    }
}