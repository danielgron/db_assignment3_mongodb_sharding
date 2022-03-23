export class Tweet{

  name: string | undefined


  constructor(init?: Partial<Tweet>) {
      Object.assign(this, init);
  }
}
