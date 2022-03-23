import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { Tweet } from 'src/app/tweet';
import { TweetService } from 'src/app/_services/tweet.service';

@Component({
  selector: 'app-tweet-list',
  templateUrl: './tweet-list.component.html',
  styleUrls: ['./tweet-list.component.css']
})
export class TweetListComponent implements OnInit {

  tweets: Tweet[] | undefined
  twitterTweets: Tweet[] | undefined
  sh: number | undefined
  isChecked: boolean = false

  tweetForm!: FormGroup;

  constructor(private tweetService: TweetService, private fb: FormBuilder) {

  }

  ngOnInit(): void {
    this.getTweets();

    this.tweetForm = this.fb.group({
      source: new FormControl(''),
      text: new FormControl('')
    });
  }

  getTweets(){
    this.tweetService.getTweets().subscribe(x => this.tweets = x);
  }

  onSubmit(form: FormGroup) {
    console.log('Valid?', form.valid); // true or false
    console.log('Source', form.value.source);
    console.log('Text', form.value.text);

    this.tweetService.postTweet(new Tweet(form.value)).subscribe(x => console.log(x))
  }

  addFromTwitter(){
    this.tweetService.addTweetsFromTwitter().subscribe(x => this.twitterTweets = x)
  }
}
