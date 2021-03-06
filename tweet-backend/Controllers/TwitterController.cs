using Microsoft.AspNetCore.Mvc;
using tweet_backend.Dto;

namespace tweet_backend.Controllers;

[ApiController]
[Route("[controller]")]
public class TwitterController : ControllerBase
{

    private readonly ILogger<TwitterController> _logger;
    private readonly TwitterService _twitterService;

    public TwitterController(ILogger<TwitterController> logger, TwitterService twitterService)
    {
        _logger = logger;
        _twitterService = twitterService;
    }

    [HttpGet(Name = "GetTweets")]
    public async Task<IEnumerable<Tweet>> GetAsync()
    {
        return await _twitterService.GetAsync();
    }

    [HttpGet("FillTwitter")]
    public async Task<IEnumerable<Tweet>> FillAsync()
    {
        return await _twitterService.FillWithTwitter();
    }

    [HttpPost(Name = "PostTweet")]
    public async Task PostAsync(Tweet tweet)
    {
        await _twitterService.CreateAsync(tweet);
    }
}
