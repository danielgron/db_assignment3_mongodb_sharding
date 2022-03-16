import { Component, OnInit } from '@angular/core';
import { FormControl } from '@angular/forms';
import { Tweet } from 'src/app/tweet';
import { TweetService } from 'src/app/_services/tweet.service';

@Component({
  selector: 'app-tweet-list',
  templateUrl: './tweet-list.component.html',
  styleUrls: ['./tweet-list.component.css']
})
export class TweetListComponent implements OnInit {

  tweets: Tweet[] | undefined
  sh: number | undefined
  isChecked: boolean = false

  name = new FormControl('');

  constructor(private tweetService: TweetService) {

  }

  ngOnInit(): void {
    this.tweetService.getTweets().subscribe(x => this.tweets = x);
  }

}
