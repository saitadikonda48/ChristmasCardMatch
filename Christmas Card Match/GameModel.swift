//
//  GameModel.swift
//  Christmas Card Match
//
//  Created by Sai Tadikonda on 10/24/15.
//  Copyright (c) 2015 TadCorp. All rights reserved.
//

import UIKit

class GameModel: NSObject {
    
    
    
    func getCards() -> [Card] {
        var generatedCards: [Card] = [Card]()
        
        for index in 0 ... 7 {
            var randomNumber:Int = Int(arc4random_uniform(13))
            
            var firstCard:Card = Card()
            firstCard.cardValue = randomNumber
            
            var secondCard:Card = Card()
            secondCard.cardValue = randomNumber
            
            generatedCards += [firstCard, secondCard]
        }
        
        for index in 0 ... generatedCards.count-1 {
            
            var currentCard:Card = generatedCards[index]
            
            var randomIndex:Int = Int(arc4random_uniform(16))
            
            generatedCards[index] = generatedCards[randomIndex]
            generatedCards[randomIndex] = currentCard
            
        }
        
        return generatedCards
    }
    
}
