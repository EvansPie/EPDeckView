//
//  ViewController.swift
//  EPDeckView
//
//  Created by Evangelos Pittas on 02/25/2016.
//  Copyright (c) 2016 Evangelos Pittas. All rights reserved.
//

import UIKit
import EPDeckView

class ViewController: UIViewController, EPDeckViewDataSource, EPDeckViewDelegate {
    
    private var deckView: EPDeckView!
    private var cardViews: [EPCardView] = []
    
    
    //  MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize and add the deck view.
        self.deckView = EPDeckView(frame: self.view.frame)
        self.deckView.delegate = self
        self.deckView.dataSource = self
        self.view.addSubview(self.deckView)

        self.view.sendSubviewToBack(self.deckView)
        
        // Create the card views.
        let numberOfCards: Int = 10
        
        for var i=0; i<numberOfCards; i++ {
            let testView: TestView = TestView(frame: CGRectMake(0,0,240,240))
            testView.center = self.deckView.center
            
            testView.layer.masksToBounds = false;
            testView.layer.shadowOffset = CGSizeMake(0, 0);
            testView.layer.shadowRadius = 25;
            testView.layer.shadowOpacity = 0.25;
            
            if i%2 == 0 {
                testView.profileImageView.image = UIImage(named: "darth_vader")
                testView.displayNameLabel.text = "Darth Vader"
            }

            self.cardViews.append(testView)
        }

        // Reload the deck view.
        self.deckView.reloadCards()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //  MARK: - BUTTON ACTIONS
    @IBAction func reloadCardsButtonTapped(sender: AnyObject) {
        self.deckView.reloadCards()
    }
    
    @IBAction func throwRightButtonTapped(sender: AnyObject) {
        self.deckView.moveTopCardToDirection(.Right)
    }
    
    @IBAction func throwLeftButtonTapped(sender: AnyObject) {
        self.deckView.moveTopCardToDirection(.Left)
    }
    
    @IBAction func previousCardButtonTapped(sender: AnyObject) {
        self.deckView.moveMovedCardBackToDeckViewTop()
    }
    
    
    //  MARK: - EPDECKVIEW DATASOURCE & DELEGATE
    func numberOfCardsInDeckView(deckView: EPDeckView) -> Int {
        return self.cardViews.count
    }
    
    func deckView(deckView: EPDeckView, cardViewAtIndexPath indexPath: Int) -> EPCardView {
        return self.cardViews[indexPath]
    }
    
    func deckView(deckView: EPDeckView, rightButtonForIndex index: Int) -> UIButton? {
        //let testView: TestView = self.cardViews[index] as! TestView
        //testView.checkButton.frame = CGRectMake(166, 186, 23, 23)
        
        let rightButton: UIButton = UIButton(frame: CGRectMake(166,186,23,23))
        rightButton.backgroundColor = UIColor.clearColor()
        rightButton.setImage(UIImage(named: "DoneBTN"), forState: .Normal)
        
        return rightButton
    }
    
    func deckView(deckView: EPDeckView, leftButtonForIndex index: Int) -> UIButton? {
        let leftButton: UIButton = UIButton(frame: CGRectMake(51,186,60,30))
        leftButton.backgroundColor = UIColor.clearColor()
        leftButton.setImage(UIImage(named: "CancelBTN"), forState: .Normal)
        return leftButton
    }
    
    func deckView(deckView: EPDeckView, cardAtIndex index: Int, movedToDirection direction: CardViewDirection) {
        
    }
}





















