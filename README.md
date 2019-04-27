![Travis CI](https://travis-ci.com/yfujiki/NowPlayingTMDB.svg?branch=master)
![platform](https://img.shields.io/badge/platform-iOS-blue.svg)
![language](https://img.shields.io/badge/language-swift5-green.svg)
![twitter](https://img.shields.io/badge/twitter-@yfujiki-blue.svg)

## NowPlayingTMDB

Show case project for a potential employer. Displays now-playing list from TMDB.

### Functionality

Fetches/displays currently playing movie information from TMDB. Able to drill down detail of related movies as well. Works on iPhone/iPad devices and both orientations.

#### iPhone X

![Now Playing](https://raw.githubusercontent.com/yfujiki/NowPlayingTMDB/master/screenshots/en-US/iPhone%20X-1NowPlaying_framed.png)

![Detail](https://raw.githubusercontent.com/yfujiki/NowPlayingTMDB/master/screenshots/en-US/iPhone%20X-2Detail_framed.png)

#### iPhone SE

![Now Playing](https://raw.githubusercontent.com/yfujiki/NowPlayingTMDB/master/screenshots/en-US/iPhone%20SE-1NowPlaying_framed.png)

![Detail](https://raw.githubusercontent.com/yfujiki/NowPlayingTMDB/master/screenshots/en-US/iPhone%20SE-2Detail_framed.png)

#### iPhone X

![Now Playing](https://raw.githubusercontent.com/yfujiki/NowPlayingTMDB/master/screenshots/en-US/iPhone%20X-1NowPlaying_framed.png)

![Detail](https://raw.githubusercontent.com/yfujiki/NowPlayingTMDB/master/screenshots/en-US/iPhone%20X-2Detail_framed.png)

#### iPad Pro (12.9 inch)

![Now Playing](<https://raw.githubusercontent.com/yfujiki/NowPlayingTMDB/master/screenshots/en-US/iPad%20Pro%20(12.9-inch)-1NowPlaying_framed.png>)

![Detail](<https://raw.githubusercontent.com/yfujiki/NowPlayingTMDB/master/screenshots/en-US/iPad%20Pro%20(12.9-inch)-2Detail_framed.png>)

#### iPad Pro (9.7 inch)

![Now Playing](<https://raw.githubusercontent.com/yfujiki/NowPlayingTMDB/master/screenshots/en-US/iPad%20Pro%20(9.7-inch)-1NowPlaying_framed.png>)

![Detail](<https://raw.githubusercontent.com/yfujiki/NowPlayingTMDB/master/screenshots/en-US/iPad%20Pro%20(9.7-inch)-2Detail_framed.png>)

### Install

#### 1. Carthage bootstrap

```
% carthage bootstrap --platform ios
```

#### 2. Run

Just run "NowPlayingTMDB" scheme from Xcode

#### 3. Run Unit Test

Run Test with "NowPlayingTMDBTest" scheme from Xcode

#### 4. Run UI Test

Run Test with "NowPlayingTMDBUITest" scheme from Xcode

### Extra Stuff

#### Adaptive Layout

The movie detail screen commands different layout depending on the screen width.

- On portrait iPhone screen, the movie description label comes to the bottom of the poster image
- On other screens, the movie description label sits to the right of the poster image

#### Fastlane Snapshot

Run

```
% bundle exec fastlane screenshots
```

and it will generate screenshots as listed above.

#### Travis CI integration

It was an optional requirement. You can see `.travis.yml` and closed pull requests. Carthage folder is cached so it runs much faster after the first successful build with the same dependencies.

#### Data Mocking with OHHTTPStubs

For all UI tests, network response is mocked via `OHHTTPStubs`, thus getting reliable results every time.

### Insight. Where to go from here.

#### CoreData or Realm

Once offline capability is in the scope, we should add backing storage like `CoreData` or `Realm`. Decided unnecessary with the current requirement.

#### RxSwift + MVVM

Having ViewModel layer would allow increasing the testability (At unit test level). Decided unnecessary with the current requirement.
I would like to introduce it with the backing storage, because that starts complicate the dataflow a little bit + `CoreData` (with `NSFetchedResultsController`) and `Realm` (with `RxRealm`) provides reliable pub-sub functionality.

#### Coordinator

Coordinator pattern would help decoupling routing functionality from ViewControllers. Decided unnecessary with the current scope.

#### Moya

Haven't used it myself yet. This time, wanted to try out the new `Result` type introduced with Swift5 and went with `URLSession` implementation. I hear good things about `Moya` + `Alamofire`. Just looking at the documentation, it looks you can remove a lot of boilerplate you had to code here, while getting the benefit of `Result` type alike.
