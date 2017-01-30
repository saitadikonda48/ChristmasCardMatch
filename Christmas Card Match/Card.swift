//
//  Card.swift
//  Christmas Card Match
//
//  Created by Sai Tadikonda on 10/24/15.
//  Copyright (c) 2015 TadCorp. All rights reserved.
//

import UIKit

class Card: UIView {
    
    var cardValue: Int = 0
    var frontImageView: UIImageView = UIImageView()
    var backImageView: UIImageView = UIImageView()
    var cardNames: [String] = ["ace", "card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9", "card10", "jack", "queen", "king" ]
    
    var isFlipped:Bool = false
    var isDone:Bool = false {
        
        didSet {
            
            UIView.animateWithDuration(1, delay: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.frontImageView.alpha = 0
                }, completion: nil)
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //default image for cards
        backImageView.image = UIImage(named: "back")
        self.applySizeConstraintsToImage(backImageView)
        self.applyPositioningConstraints(backImageView)
        
        //Apply autolayout constraints to the front
        self.applySizeConstraintsToImage(frontImageView)
        self.applyPositioningConstraints(frontImageView)
    }
    
    func applySizeConstraintsToImage(imageView: UIImageView ) {
        
        //sets autotranslateresizingmask to false
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //add the image veiw to the view
        addSubview(imageView)
        
        //set constraints to the imageview
        var heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150)
        
        var widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 120)
        
        imageView.addConstraints([heightConstraint, widthConstraint])
        
        
    }
    
    func applyPositioningConstraints(imageView: UIImageView) {
        // Set the position of the imageview
        
        var verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        var horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        self.addConstraints([verticalConstraint, horizontalConstraint])
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    func flipUp() {
        //Set imageview to card value
        self.frontImageView.image = UIImage(named: self.cardNames[self.cardValue])
        
        //Animation
        UIView.transitionFromView(backImageView, toView: frontImageView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
        
        self.applyPositioningConstraints(frontImageView)
        
        //Set the card to show it is flipped
        isFlipped = true
    }
    
    func flipDown() {
        
        UIView.transitionFromView(frontImageView, toView: backImageView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
        
        self.applyPositioningConstraints(backImageView)
        
        isFlipped = false
    }
    
}
