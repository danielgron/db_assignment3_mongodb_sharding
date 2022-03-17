export class Tweet{

  text: string | undefined
  source: string | undefined


  constructor(init?: Partial<Tweet>) {
      Object.assign(this, init);
  }
}
