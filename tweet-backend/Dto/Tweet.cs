using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace tweet_backend.Dto
{
    
[BsonIgnoreExtraElements]
    public class Url
    {
        public string display_url { get; set; }
        public List<int> indices { get; set; }
        public string url { get; set; }
        public string expanded_url { get; set; }
    }
[BsonIgnoreExtraElements]
    public class UrlCollection
    {
        public List<Url> urls { get; set; }
    }

[BsonIgnoreExtraElements]
    public class Description
    {
        public List<object> urls { get; set; }
    }
    

[BsonIgnoreExtraElements]
    public class Tweet
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string? Id { get; set; }
        public string? created_at { get; set; }
        public string text { get; set; }
        public string source { get; set; }
        public bool? truncated { get; set; }
        public object? in_reply_to_status_id { get; set; }
        public object? in_reply_to_status_id_str { get; set; }
        public object? in_reply_to_user_id { get; set; }
        public object? in_reply_to_user_id_str { get; set; }
        public object? in_reply_to_screen_name { get; set; }
        public User? user { get; set; }
        public object? geo { get; set; }
        public object? coordinates { get; set; }
        public object? place { get; set; }
        public object? contributors { get; set; }
        public int? retweet_count { get; set; }
        public int? favorite_count { get; set; }
        public Entities? entities { get; set; }
        public bool? favorited { get; set; }
        public bool? retweeted { get; set; }
        public bool? possibly_sensitive { get; set; }
        public bool? possibly_sensitive_appealable { get; set; }
        public string? lang { get; set; }
    }
}