# EPDeckView
`EPDeckView` is an easy-to-use Swift library that provides a deck of views that can be swiped or thrown left/right (inspired by the Tinder app).

[![CI Status](http://img.shields.io/travis/Evangelos Pittas/EPDeckView.svg?style=flat)](https://travis-ci.org/Evangelos Pittas/EPDeckView)
[![Version](https://img.shields.io/cocoapods/v/EPDeckView.svg?style=flat)](http://cocoapods.org/pods/EPDeckView)
[![License](https://img.shields.io/cocoapods/l/EPDeckView.svg?style=flat)](http://cocoapods.org/pods/EPDeckView)
[![Platform](https://img.shields.io/cocoapods/p/EPDeckView.svg?style=flat)](http://cocoapods.org/pods/EPDeckView)

![EPDeckView](https://github.com/EvansPie/EPDeckView/blob/master/demo.gif)


## Requirements

- iOS 8.0+
- Xcode 7.2


## Installation

### Manually

Clone this repo and manually add the source files to project.

### CocoaPods
If you are using [CocoaPods](https://cocoapods.org) just add in your podfile:

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

1) Modify the animation of the deck and the card being dragged by creating a `EPDeckViewAnimationManager` and setting it in `EPDeckView`. If you don't create a custom `EPDeckViewAnimationManager` then the default animation values will be applied. If you have instantiated `EPDeckView` from a storyboard with autolayout, you must instantiate the `EPDeckViewAnimationManager` after `viewDidLayoutSubviews()`.

```swift
override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    //  If you want to set custom values in the EPDeckViewAnimationManager then it should
    //  be set in the viewDidAppear func.
    let deckViewAnimationManager: EPDeckViewAnimationManager = EPDeckViewAnimationManager(frame: self.deckView.frame)

    //  The actionMargin is measured from the card's center x. Usually it can be set to a 
    //  bit less than half the deckView's width.
    deckViewAnimationManager.actionMargin = self.deckView.frame.size.width / 2.2

    //  The lower this rotationStrength gets, the faster the card rotates. This value is 
    //  also taken into account in the scaling of the card.
    deckViewAnimationManager.rotationStrength = 300.0

    //  This is the max angle allowed to the rotation while being dragged.
    deckViewAnimationManager.rotationMax = 360.0

    //  This is the angle that is reached when the distance of the card from the center equals
    //  the rotation strength. Therefore, with the above values, when the card is distanced
    //  100px from the center (1/3 of the rotation strength) of the deckView, the card will 
    //  have rotated 30 degrees (1/3 of the rotation angle).
    deckViewAnimationManager.rotationAngle = 90.0

    //  The smaller the scale strength, the quicker it scales down while the card is dragged, 
    //  till it reaches scaleMax.
    deckViewAnimationManager.scaleStrength = 4.0

    //  scaleMax should received values 0.0 ~> 1.0. It represents the max downscaling that 
    //  is allowed to be applied on the card while being dragged.
    deckViewAnimationManager.scaleMax = 0.5

    //  cardLeftFinishPoint & cardRightFinishPoint represent the points that the card will be 
    //  moved after being dragged, if it's left outside the actionMargin.
    deckViewAnimationManager.cardLeftFinishPoint = CGPointMake(-self.deckView.frame.width * 1.5, self.deckView.frame.height / 3.0)
    deckViewAnimationManager.cardRightFinishPoint = CGPointMake(self.deckView.frame.width * 1.5, self.deckView.frame.height / 3.0)

    //  The deckAnimationDuration represents the duration of the animation that the card being
    //  dragged needs to return to the deck or move out of the screen. It is also the animation
    //  duration that the rest of the cards in the deck animate.
    deckViewAnimationManager.deckAnimationDuration = 0.35

    //  The dckAnchor represents the anchor of the deck. It can take 4 values: TopLeft, TopRight,
    //  BottomRight or BottomLeft.
    deckViewAnimationManager.deckAnchor = .BottomLeft

    //  deckMaxVisibleCards represents the max number of visible cards in the deck. I.e. if the
    //  deck has 52 cards but the deckMaxVisibleCards is set to 10, then card 11 to 50 will be
    //  transparent. It doesn't account for transparent cards.
    deckViewAnimationManager.deckMaxVisibleCards = 3

    //  deckCardAngleDelta sets the angle difference between the cards in the deck.
    deckViewAnimationManager.deckCardAngleDelta = 7.0

    //  deckViewCardScaleDelta sets the scale difference between the cards in the deck.
    deckViewAnimationManager.deckViewCardScaleDelta = 0.08

    //  deckCardAlphaDelta sets the alpha channel difference between the cards in the deck.
    deckViewAnimationManager.deckCardAlphaDelta = 0.05

    //  deckCardAlphaDelta sets the deck's center.
    deckViewAnimationManager.deckCenter = CGPointMake(self.deckView.center.x, self.deckView.center.y - 40.0)

    //  Not setting a custom EPDeckViewAnimationManager will set the default value of an
    //  EPDeckViewAnimationManager
    self.deckView.deckViewAnimationManager = deckViewAnimationManager

    //  Empty the local reference array before reloading the cards.
    self.cardViews = []
    self.deckView.reloadCards()
}
```

2) To add the functionality to throw the cards left/right on your custom view's buttons, simply return the buttons of each card in the delegate functions.

```swift
func deckView(deckView: EPDeckView, rightButtonForCardAtIndex index: Int) -> UIButton? {
    let rightButton: UIButton = (self.cardViews[index] as! TestView).checkButton
    return rightButton
}

func deckView(deckView: EPDeckView, leftButtonForCardAtIndex index: Int) -> UIButton? {
    let leftButton: UIButton = (self.cardViews[index] as! TestView).cancelButton
    return leftButton
}
```

3) Monitor the card's movement and the card's button tap.

```swift
func deckView(deckView: EPDeckView, cardAtIndex index: Int, movedToDirection direction: CardViewDirection) {
    print("Card at index \(index) moved to \(direction.description()).")
}

func deckView(deckView: EPDeckView, didTapLeftButtonAtIndex index: Int) {
    print("Left button of card at index: \(index) tapped.")
}

func deckView(deckView: EPDeckView, didTapRightButtonAtIndex index: Int) {
    print("Right button of card at index: \(index) tapped.")
}
```

4) To throw a card left or right use the `EPDeckView`'s function `moveCardAtIndex(_:toDirection:)`. To throw the top card of the deck left or right use `moveTopCardToDirection(_:)`.

5) To bring back the last card use `EPDeckView`'s function `bringBackLastCardThrown()`.


## Author

Evangelos Pittas, evangelospittas@gmail.com

## License

EPDeckView is available under the MIT license. See the LICENSE file for more info.
