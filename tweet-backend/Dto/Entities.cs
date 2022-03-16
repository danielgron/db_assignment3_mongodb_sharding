using MongoDB.Bson.Serialization.Attributes;

namespace tweet_backend.Dto
{
    [BsonIgnoreExtraElements]
    public class Entities
    {
        public Url url { get; set; }
        public Description description { get; set; }
        public List<object> hashtags { get; set; }
        public List<object> symbols { get; set; }
        public List<object> user_mentions { get; set; }
        public List<Url> urls { get; set; }
    }
}