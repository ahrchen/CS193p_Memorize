//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Raymond Chen on 6/28/22.
//

import SwiftUI

func makeCardContent(index: Int) -> String {
    return "😀"
}

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    @Published private(set) var model: MemoryGame<String>
    static var themeArray =  "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜".map{ String($0) }
    var themeArray: [String]
    
    init() {
        themeArray =  EmojiMemoryGame.themeArray
        model = MemoryGame<String>(numberOfPairsOfCards: 5,  createCardContent: { pairIndex in
            return EmojiMemoryGame.themeArray[pairIndex]
        })
    }
    
    func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 5,  createCardContent: { pairIndex in
            return themeArray[pairIndex]
        })
    }
    
    var cards: Array<Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = createMemoryGame()
    }
    
    func changeTheme(themeArray: [String]) {
        self.themeArray = themeArray
        restart()
    }
}
