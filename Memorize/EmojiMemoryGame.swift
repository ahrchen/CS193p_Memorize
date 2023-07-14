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
    private var theme: [String]
    
    init(theme: [String]) {
        self.theme = theme
        model = MemoryGame<String>(numberOfPairsOfCards: 5) { pairIndex in
            theme[pairIndex]
        }
    }
    
    func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 5) { pairIndex in
            theme[pairIndex]
        }
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
}
