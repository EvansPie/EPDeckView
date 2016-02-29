# EPDeckView

[![CI Status](http://img.shields.io/travis/Evangelos Pittas/EPDeckView.svg?style=flat)](https://travis-ci.org/Evangelos Pittas/EPDeckView)
[![Version](https://img.shields.io/cocoapods/v/EPDeckView.svg?style=flat)](http://cocoapods.org/pods/EPDeckView)
[![License](https://img.shields.io/cocoapods/l/EPDeckView.svg?style=flat)](http://cocoapods.org/pods/EPDeckView)
[![Platform](https://img.shields.io/cocoapods/p/EPDeckView.svg?style=flat)](http://cocoapods.org/pods/EPDeckView)


## Requirements

- iOS 8.0+
- Xcode 7.2


## Installation
Just add the EPDeckView.swift, EPCardView, EPDeckViewAnimationManager & Extensions.swift files to your project.

Alternatively use [CocoaPods](https://cocoapods.org) with Podfile:`pod 'EPDeckView', '~> 0.1.0'`


## Usage
1.) Create a new view inheriting `EPDeckView` and add it on your view.

2.) Conform to `EPDeckViewDataSource` & `EPDeckViewDelegate` as you would with a `UITableView`.

3.) Return the number of cards that you wish to add in the data source function `numberOfCardsInDeckView(_:)`.

4.) Create & return each card of the deck with `deckView(_:cardViewAtIndexPath:`.

5.) Modify the animation of the deck and the card being dragged by creating a ...

6.) To add the functionality to throw the cards left/right on your custom view's buttons, simply return the buttons of each card in the delegate functions `deckView(_:rightButtonForCardAtIndex:)` and `deckView(_:leftButtonForCardAtIndex:)`.

7.) Monitor the card's movement with the delegate function `deckView(_:cardAtIndex:movedToDirection:)` and the card's button tap with `deckView(_:didTapLeftButtonAtIndex:)` or `deckView(_:didTapRightButtonAtIndex:)`.


## Author

Evangelos Pittas, evangelospittas@gmail.com

## License

EPDeckView is available under the MIT license. See the LICENSE file for more info.
