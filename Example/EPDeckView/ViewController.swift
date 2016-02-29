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
    
    //private var deckView: EPDeckView!
    private var cardViews: [EPCardView] = []
    @IBOutlet weak var deckView: EPDeckView!
    
    
    //  MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize and add the deck view.
        self.deckView.delegate = self
        self.deckView.dataSource = self
    }
    

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.cardViews = []
        self.deckView.reloadCards()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //  MARK: - BUTTON ACTIONS
    @IBAction func reloadCardsButtonTapped(sender: AnyObject) {
        self.cardViews = []
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
        return 3
    }
    
    func deckView(deckView: EPDeckView, cardViewAtIndexPath indexPath: Int) -> EPCardView {
        let testView: TestView = TestView(frame: CGRectMake(0,0,240,240))
        testView.center = self.deckView.center
        
        testView.layer.masksToBounds = false;
        testView.layer.shadowOffset = CGSizeMake(0, 0);
        testView.layer.shadowRadius = 25;
        testView.layer.shadowOpacity = 0.25;
        
        if indexPath%2 == 0 {
            testView.profileImageView.image = UIImage(named: "darth_vader")
            testView.displayNameLabel.text = "Darth Vader"
        }
        
        self.cardViews.append(testView)
        
        return testView
    }
    
    func deckView(deckView: EPDeckView, rightButtonForIndex index: Int) -> UIButton? {
        let rightButton: UIButton = (self.cardViews[index] as! TestView).checkButton
        return rightButton
    }
    
    func deckView(deckView: EPDeckView, leftButtonForIndex index: Int) -> UIButton? {
        let leftButton: UIButton = (self.cardViews[index] as! TestView).cancelButton
        return leftButton
    }
    
    func deckView(deckView: EPDeckView, cardAtIndex index: Int, movedToDirection direction: CardViewDirection) {
        print("Card at index \(index) moved to \(direction.description()).")
    }
    
    func deckView(deckView: EPDeckView, didTapLeftButtonAtIndex index: Int) {
        print("Left button of card at index: \(index) tapped.")
    }
    
    func deckView(deckView: EPDeckView, didTapRightButtonAtIndex index: Int) {
        print("Right button of card at index: \(index) tapped.")
        
        //
    }

}





















