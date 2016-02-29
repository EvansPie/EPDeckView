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
1) Create a new view inheriting `EPDeckView` and add it on your view.

2.) Conform to `EPDeckViewDataSource` & `EPDeckViewDelegate` as you would with a `UITableView`.

3) Return the number of cards that you wish to add in the data source function `numberOfCardsInDeckView:`.

4) Create & return each card of the deck with `deckView(:, cardViewAtIndexPath:`.



## Requirements

## Installation

EPDeckView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EPDeckView"
```

## Author

Evangelos Pittas, evangelospittas@gmail.com

## License

EPDeckView is available under the MIT license. See the LICENSE file for more info.
