# EPDeckView
`EPDeckView` is an easy-to-use Swift library that provides a deck of views that can be swiped or thrown left/right (inspired by the Tinder app).

[![Version](https://img.shields.io/cocoapods/v/EPDeckView.svg?style=flat)](http://cocoapods.org/pods/EPDeckView)
[![License](https://img.shields.io/cocoapods/l/EPDeckView.svg?style=flat)](http://cocoapods.org/pods/EPDeckView)
[![Platform](https://img.shields.io/cocoapods/p/EPDeckView.svg?style=flat)](http://cocoapods.org/pods/EPDeckView)

![EPDeckView](https://opensource.hopinside.com/epdeckview/demo.gif)


## Requirements

- iOS 8.0+
- Xcode 7.2


## Installation

### Manually

Clone this repo and manually add the source files to project.

### CocoaPods
If you are using [CocoaPods](https://cocoapods.org) just add in your podfile:

`pod 'EPDeckView'`

or if you want to get the latest release:

`pod 'EPDeckView', :git => 'https://github.com/EvansPie/EPDeckView.git'`


## Usage
1) Create a new view (from storyboard or programmatically) inheriting `EPDeckView` and add it on your view. Conform to `EPDeckViewDataSource` & `EPDeckViewDelegate` as you would with a `UITableView` and set the view's delegate & data source.
```swift
class ViewController: UIViewController, EPDeckViewDataSource, EPDeckViewDelegate {
    @IBOutlet weak var deckView: EPDeckView!

    // Array that keeps a reference to our cards.
    private var cardViews: [EPCardView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the deckView's delegate & data source.
        self.deckView.delegate = self
        self.deckView.dataSource = self

    }
}
```

2) Return the number of cards that you wish to add in the deck, as you would do with `UITableViewDataSource`.

```swift
func numberOfCardsInDeckView(deckView: EPDeckView) -> Int {
    return 6
}
```

3) Create your cards as you would do with `UITableViewCell`. Your cards must inherit `EPCardView`.
```swift
func deckView(deckView: EPDeckView, cardViewAtIndex index: Int) -> EPCardView {
    //  Create a TestView to be added as a card in the deck.
    let testView: TestView = TestView(frame: CGRectMake(0,0,240,240))

    //  Keep a reference so you can pass the nib's buttons to the delegate functions.
    self.cardViews.append(testView)

    return testView
}
```

That's it! Don't forget to reload your deck (after `viewDidLayoutSubviews()` if you are using autolayout).

```swift
override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.deckView.reloadCards()
}
```

### Features

For a detailed guide on how to use the features visit [here](http://bit.ly/1Y9qX10)

1) Modify the animation of the deck and the card being dragged.

2) Throw a card left/right.

3) Monitor the card's movement and the card's button tap.

4) Bring back the latest card thrown.


## Author

Evangelos Pittas, evangelospittas@gmail.com

## License

EPDeckView is available under the MIT license. See the LICENSE file for more info.
