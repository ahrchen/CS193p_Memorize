//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Raymond Chen on 6/12/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var themeStore =  ThemeStore(named: "Default")
    @StateObject var game  = EmojiMemoryGame()
    
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
                .environmentObject(themeStore)
        }
    }
}
