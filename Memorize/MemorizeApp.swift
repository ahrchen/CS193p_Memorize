//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Raymond Chen on 6/12/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private static let theme =  "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜".map{ String($0) }
    private let game = EmojiMemoryGame(theme: theme)
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
