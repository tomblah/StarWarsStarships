# Star Wars Starships
<br />
  <p align="center">
  Solution to Transurban's coding challenge. This solution loads a page of Star Wars starships and shows in a list. The user can tap a starship to see more details.
  </p>
</p>

<p align="center">
<img src= "https://media.giphy.com/media/ZixAQOZjkEXRltnHNJ/giphy.gif" width="300" >
</p>

## Installation

The solution is a Swift iPhone app. To run, simply open `StarWarsStarships.xcworkspace` in Xcode and click the play button.

Although the solution uses `CocoaPods`, it is <b>not necessary</b> to run `pod install` as I have put all the `pods` under source control. This is simply to make things easier for the reviewer(s).

The finished solution is available on the `coding-challenge` branch. Once code reviewed, it can be landed onto `master` :-).


## Solution Overview

- My solution uses a `Model, View, Presenter` pattern as this is the design pattern I'm most familiar with. I'm happy to re-write in `MVVM` if required.
- I opted not to use `Storyboards` simply because they do not play well with source control. Additionally, programmatic layout is almost always faster to develop than using `Storyboards`. I've used [TinyConstraints](https://github.com/roberthein/TinyConstraints) to help with the programmatic layout.
- Using `Alamofire` for network requests and then `SwiftyJSON` to parse the result into our native objects. In a real-life scenario these objects (and the parsing code) would probably be automatically generated via an `OpenAPI` doc and generator or equivalent.

## Considerations

#### How does the user know which items have been favorited?
I've opted for a star in the top right hand corner to indicate if an item is favourited. Tapping the star will toggle the favourite status. This can be done both in the starships in the list and in the details screen.
 
#### What order is the data displayed in? Can the user switch between different sort options?
By default the order will be displayed in natural order (i.e. the order from the API). Additionally, I've chosen a few sample sort ordering fields that can be accessed by tapping the top right button on the main list.

#### How does the user navigate back and forth between the list of starships and a specific starship’s details?
I've opted to keep things simple and just use standard `UINavigation` push (and the implicit pop when the user taps the back button).

#### What happens if an API call fails?
I simply display a generic error message. In a real life scenario, would source the error message from the server.


## Notes for reviewers

- NB: I haven't included an app icon nor a launch screen. I can add these in if required.
- Playing around with the app, I think the tie-breaker for sorting with favourites selected should be the date of favouriting in chronological order rather than the `name` field. Visually more appealing when the favourites are appended.


