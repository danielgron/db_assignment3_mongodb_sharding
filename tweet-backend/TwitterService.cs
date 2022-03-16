using Microsoft.Extensions.Options;
using MongoDB.Driver;
using tweet_backend.Dto;

namespace tweet_backend
{
    public class TwitterService
{
    private readonly IMongoCollection<Tweet> _tweetCollection;

    public TwitterService(
        IOptions<DatabaseSettings> twitterDatabaseSettings)
    {
        var mongoClient = new MongoClient(
            twitterDatabaseSettings.Value.ConnectionString);

        var mongoDatabase = mongoClient.GetDatabase(
            twitterDatabaseSettings.Value.DatabaseName);

        _tweetCollection = mongoDatabase.GetCollection<Tweet>(
            twitterDatabaseSettings.Value.CollectionName);
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