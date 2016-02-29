# EPDeckView

[![CI Status](http://img.shields.io/travis/Evangelos Pittas/EPDeckView.svg?style=flat)](https://travis-ci.org/Evangelos Pittas/EPDeckView)
[![Version](https://img.shields.io/cocoapods/v/EPDeckView.svg?style=flat)](http://cocoapods.org/pods/EPDeckView)
[![License](https://img.shields.io/cocoapods/l/EPDeckView.svg?style=flat)](http://cocoapods.org/pods/EPDeckView)
[![Platform](https://img.shields.io/cocoapods/p/EPDeckView.svg?style=flat)](http://cocoapods.org/pods/EPDeckView)


## Requirements

- iOS 8.0+
- Xcode 7.2


## Installation

### Manually

Clone this repo and manually add the source files to project.

### CocoaPods
If you are using [CocoaPods](https://cocoapods.org) just add in your podfile:

`pod 'EPDeckView', '~> 0.1.0'`


## Usage
1) Create a new view inheriting `EPDeckView` and add it on your view.

2) Conform to `EPDeckViewDataSource` & `EPDeckViewDelegate` as you would with a `UITableView`.

3) Return the number of cards that you wish to add in the deck:

```swift
func numberOfCardsInDeckView(deckView: EPDeckView) -> Int {
    return 6
}
```

4) Create & return each card of the deck:
```swift
func deckView(deckView: EPDeckView, cardViewAtIndexPath indexPath: Int) -> EPCardView {
    //  Create a TestView to be added as a card in the deck.
    let testView: TestView = TestView(frame: CGRectMake(0,0,240,240))
    return testView
}
```


5) Modify the animation of the deck and the card being dragged by creating a `EPDeckViewAnimationManager` and setting it in `EPDeckView`. If you don't create a custom `EPDeckViewAnimationManager` then the default animation values will be applied.

6) To add the functionality to throw the cards left/right on your custom view's buttons, simply return the buttons of each card in the delegate functions `deckView(_:rightButtonForCardAtIndex:)` and `deckView(_:leftButtonForCardAtIndex:)`.

7) Monitor the card's movement with the delegate function `deckView(_:cardAtIndex:movedToDirection:)` and the card's button tap with `deckView(_:didTapLeftButtonAtIndex:)` or `deckView(_:didTapRightButtonAtIndex:)`.


## Author

Evangelos Pittas, evangelospittas@gmail.com

## License

EPDeckView is available under the MIT license. See the LICENSE file for more info.
