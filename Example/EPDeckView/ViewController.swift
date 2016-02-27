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
    
    @IBOutlet weak var deckView: EPDeckView!
    private var cardViews: [EPCardView] = []
    
    
    //  MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let numberOfCards: Int = 10
        
        self.deckView.delegate = self
        self.deckView.dataSource = self
        
        for var i=0; i<numberOfCards; i++ {
            let testView: TestView = TestView(frame: CGRectMake(0,0,240,240))
            testView.center = self.deckView.center
            self.cardViews.append(testView)
        }
        
        self.deckView.reloadCards()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  MARK: - BUTTON ACTIONS
    @IBAction func reloadCardsButtonTapped(sender: AnyObject) {
        //self.deckView.reloadCards()
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
        let testView: TestView = self.cardViews[index] as! TestView
        return testView.checkButton
    }
    
    func deckView(deckView: EPDeckView, leftButtonForIndex index: Int) -> UIButton? {
        let leftButton: UIButton = UIButton(frame: CGRectMake(10,160,60,30))
        leftButton.backgroundColor = UIColor.redColor()
        return leftButton
    }
    
    func deckView(deckView: EPDeckView, cardAtIndex index: Int, movedToDirection direction: CardViewDirection) {
        
    }
}





















