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
  sh: number | undefined
  isChecked: boolean = false

  tweetForm!: FormGroup;

  constructor(private tweetService: TweetService, private fb: FormBuilder) {

  }

  ngOnInit(): void {
    this.tweetService.getTweets().subscribe(x => this.tweets = x);

    this.tweetForm = this.fb.group({
      source: new FormControl(''),
      email: new FormControl(''),
      text: new FormControl('')
    });
  }

  onSubmit(form: FormGroup) {
    console.log('Valid?', form.valid); // true or false
    console.log('Source', form.value.source);
    console.log('Email', form.value.email);
    console.log('Text', form.value.text);
  }

}
