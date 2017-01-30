//
//  ViewController.swift
//  Christmas Card Match
//
//  Created by Sai Tadikonda on 10/24/15.
//  Copyright (c) 2015 TadCorp. All rights reserved.
//

import UIKit
import AVFoundation
import iAd

class ViewController: UIViewController, ADBannerViewDelegate {
    
    //StoryBoard IBOutlet properties
    @IBOutlet weak var cardScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var Banner: ADBannerView!
    
    
    var gameModel:GameModel = GameModel()
    var cards:[Card] = [Card]()
    var revealedCard:Card?
    
    //timer properties
    var timer: NSTimer!
    var countdown: Int = 40
    
    //Keep track of the user's high score
    var playerScore:Int = 0
    var playerHighScore: Int = 0
    
    //Audio player properties
    var correctSoundPlayer: AVAudioPlayer?
    var wrongSoundPlayer: AVAudioPlayer?
    var shuffleSoundPlayer: AVAudioPlayer?
    var flipSoundPlayer: AVAudioPlayer?
    var backgroundThemePlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Load and show player's high score
        var highScoreDefaults = NSUserDefaults.standardUserDefaults()
        if(highScoreDefaults.valueForKey("highscore") != nil) {
            playerHighScore = highScoreDefaults.valueForKey("highscore") as! NSInteger
    
            
        }
        
        //Load and Show ads
        Banner.hidden = true
        Banner.delegate = self
        self.canDisplayBannerAds=true
        
        //Initialize the audio players
        var correctSoundURL: NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dingcorrect", ofType: "wav")!)
        if(correctSoundURL != nil) {
            self.correctSoundPlayer = AVAudioPlayer(contentsOfURL: correctSoundURL!, error: nil)
        }
        
        var backgroundThemePlayerURL:NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("LastChristmasInstrumental", ofType: "mp3")!)
        if(backgroundThemePlayerURL != nil) {
            self.backgroundThemePlayer = AVAudioPlayer(contentsOfURL: backgroundThemePlayerURL!, error: nil)
        }
        
        
        var wrongSoundURL: NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dingwrong", ofType: "wav")!)
        if(wrongSoundURL != nil) {
            self.wrongSoundPlayer = AVAudioPlayer(contentsOfURL: wrongSoundURL!, error: nil)
        }
        
        var shuffleSoundURL: NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("shuffle", ofType: "wav")!)
        if(shuffleSoundURL != nil) {
            self.shuffleSoundPlayer = AVAudioPlayer(contentsOfURL: shuffleSoundURL!, error: nil)
        }
        
        var flipSoundURL: NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cardflip", ofType: "wav")!)
        if(flipSoundURL != nil) {
            self.flipSoundPlayer = AVAudioPlayer(contentsOfURL: flipSoundURL!, error: nil)
        }
        
        //Get the cards from array
        self.cards = gameModel.getCards()
        
        //Layout the cards
        self.layoutCards()
        
        //Play the shuffle card
        if(shuffleSoundPlayer != nil) {
            self.shuffleSoundPlayer?.play()
        }
        
        //Initialize timer
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerUpdate"), userInfo: nil, repeats: true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerUpdate() {
        //Decrement timer
        countdown--
        
        //link the timer label to the timer
        countDownLabel.text = String(countdown)
        
        if(countdown == 0) {
            //stop the timer
            self.timer.invalidate()
            
            //Game is over check if all cards have been matched
            var allCardsMatched: Bool = true
            
            for card in self.cards {
                //See if all the cards are gone
                if(card.isDone == false) {
                    allCardsMatched = false
                    break;
                }
            }
            
            var alertText:String = ""
            if(allCardsMatched == true) {
                //Win
                alertText = "You Won"
                
            }
            else {
                //Lose
                alertText = "You Lost"
            }
            var alert: UIAlertController = UIAlertController(title: "Time's up", message: alertText, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            self.backgroundThemePlayer?.play()
        }
    }
    
    func layoutCards() {
        var columnCounter: Int = 0
        var rowCounter: Int = 0
        
        for index in 0 ... cards.count-1 {
            
            //Place the card in the view and turn off translate auto resizing mask
            var thisCard: Card = cards[index]
            thisCard.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.contentView.addSubview(thisCard)
            
            var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("cardTapped:"))
            thisCard.addGestureRecognizer(tapGestureRecognizer)
            
            
            //Set the height and width constraints
            var heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 170)
            
            var widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute:NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 120)
            
            thisCard.addConstraints([heightConstraint, widthConstraint])
            
            //Set the horizontal position
            if(columnCounter > 0) {
                var cardOnTheLeft: Card = cards[index - 1]
                
                var leftMarginConstraint: NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: cardOnTheLeft, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 5)
                
                self.contentView.addConstraint(leftMarginConstraint)
            }
            else {
                var leftMarginConstraint: NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
                
                self.contentView.addConstraint(leftMarginConstraint)
            }
            //Set the vertical position
            
            if(rowCounter > 0) {
                var cardOnTop: Card = cards[index - 4]
                
                var topMarginConstraint: NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: cardOnTop, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
                
                self.contentView.addConstraint(topMarginConstraint)
            }
            else {
                var topMarginConstraint: NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
                
                self.contentView.addConstraint(topMarginConstraint)
            }
            
            //Increment the counter
            columnCounter++
            if(columnCounter >= 4){
                columnCounter = 0
                rowCounter++
            }
            
        }
        // Add height constraint to content view so the scroll view knows how much to scroll
        var contentViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: cards[0], attribute: NSLayoutAttribute.Height, multiplier: 4, constant: 35)
        contentView.addConstraint(contentViewHeightConstraint)
        
    }
    
    func cardTapped(recognizer: UITapGestureRecognizer) {
        
        if(countdown <= 0) {
            return
        }
        
        //Get the card that was tapped
        var cardThatWasTapped:Card = recognizer.view as! Card
        
        //Is the card already flipped?
        if (cardThatWasTapped.isFlipped == false) {
            
            //Play the card flip sound
            if(flipSoundPlayer != nil) {
                flipSoundPlayer?.play()
            }
            
            //Card is not flipped now check if it is the first card being flipped
            if(revealedCard == nil) {
                
                //First card being flipped
                
                //Flip up the card
                cardThatWasTapped.flipUp()
                //Set the revealed card
                revealedCard = cardThatWasTapped
            }
            else {
                
                //Second card being flipped
                
                //Flip up the card
                cardThatWasTapped.flipUp()
                
                //Check if it's a match
                if(revealedCard?.cardValue == cardThatWasTapped.cardValue) {
                    
                    //It is a match
                    
                    self.playerScore++
                    self.scoreLabel.text = String(self.playerScore)
                    if(self.playerScore > self.playerHighScore) {
                        playerHighScore = playerScore
                        
                        var highScoreDefault = NSUserDefaults.standardUserDefaults()
                        highScoreDefault.setValue(playerHighScore, forKey: "highscore")
                        highScoreDefault.synchronize()
                    }
                    
                    //Play correct sound
                    if(correctSoundPlayer != nil) {
                        correctSoundPlayer?.play()
                    }
                    
                    //Remove both cards
                    self.revealedCard?.isDone = true
                    cardThatWasTapped.isDone = true
                    
                    //Reset temporary card holder
                    self.revealedCard = nil
                }
                else {
                    
                    //It is not a match
                    
                    //Play wrong sound
                    if(wrongSoundPlayer != nil) {
                        wrongSoundPlayer?.play()
                    }
                    
                    var timer1 = NSTimer.scheduledTimerWithTimeInterval(1, target: self.revealedCard!, selector: Selector("flipDown"), userInfo: nil, repeats: false)
                    var timer2 = NSTimer.scheduledTimerWithTimeInterval(1, target: cardThatWasTapped, selector: Selector("flipDown"), userInfo: nil, repeats: false)
                    
                    //Reset the temporary card holder
                    revealedCard = nil
                }
            }
        }
    }// end function cardTapped
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        NSLog("Error Loading Ad")
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        Banner.hidden = false
    }
    
}

