//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Raymond Chen on 6/12/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
