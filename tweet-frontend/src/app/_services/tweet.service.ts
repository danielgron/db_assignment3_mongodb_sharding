import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../environments/environment';
import { Tweet } from '../tweet';

@Injectable({
  providedIn: 'root'
})
export class TweetService {
  addTweetsFromTwitter() {
    return this.http.get<Tweet[]>('/Twitter/FillTwitter');
  }

  constructor(private http: HttpClient) { }


  getTweets() {
    return this.http.get<Tweet[]>('/Twitter');
  }

  postTweet(tweet: Tweet) {
    console.log("Posting tweet")
    return this.http.post('/Twitter', tweet);
  }

}
