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
    private(set) var theme: Theme
    var isGameAvailable: Bool {
        !theme.emojisArray.isEmpty
    }
    static var defaultTheme = Theme(name: "Default", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜", id: 9999)

    init() {
        self.theme = EmojiMemoryGame.defaultTheme
        model = MemoryGame<String>(numberOfPairsOfCards: EmojiMemoryGame.defaultTheme.numCardsDealt,  createCardContent: { pairIndex in
            return EmojiMemoryGame.defaultTheme.emojisArray[pairIndex]
        })
    }
    
    func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: theme.numCardsDealt,  createCardContent: { pairIndex in
            return theme.emojisArray[pairIndex]
        })
    }
    
    var cards: Array<Card> {
        return model.cards
    }
    
    func getScore() -> String {
        String(format: "%.2f", model.score)
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        if isGameAvailable {
            model.choose(card)
        }
    }
    
    func shuffle() {
        if isGameAvailable {
            model.shuffle()
        }
    }
    
    func restart() {
        if isGameAvailable {
            model = createMemoryGame()
        }
    }
    
    func changeThemes(theme: Theme) {
        if theme != self.theme {
            self.theme = theme
            restart()
            shuffle()
        }
    }
}
