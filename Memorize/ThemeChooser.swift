//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Raymond Chen on 7/13/23.
//

import SwiftUI

struct ThemeChooser: View {
    
    @EnvironmentObject var store: ThemeStore
    @ObservedObject var game: EmojiMemoryGame
    
    @State var chosenThemeIndex = 0
    
    
    var body: some View {
        themeControlButton
    }
    
    var themeControlButton: some View {
        Button {
            withAnimation {
                chosenThemeIndex = (chosenThemeIndex + 1) % store.themes.count
                game.changeTheme(themeArray: store.themes[chosenThemeIndex].emojis.map({String($0)}))
            }
        } label: {
            Image(systemName: "paintbrush.pointed")
        }
        .contextMenu { contextMenu }
    }
    
    @ViewBuilder
    var contextMenu: some View {
        AnimatedActionButton(title: "Edit", systemImage: "pencil") {
            // Edit Theme
        }
        AnimatedActionButton(title: "New", systemImage: "plus") {
            // Create New Theme
        }
        AnimatedActionButton(title: "delete", systemImage: "minus.circle") {
            // Delete Theme
        }
        AnimatedActionButton(title: "Manager", systemImage: "slider.vertical.3") {
            // Manage Themes
        }
        goToMenu
    }
    
    var goToMenu: some View {
        Menu {
            ForEach (store.themes) { theme in
                AnimatedActionButton(title: theme.name) {
                    if let index = store.themes.index(matching: theme) {
                        chosenThemeIndex = index
                    }
                    game.changeTheme(themeArray: store.themes[chosenThemeIndex].emojis.map({String($0)}))
                }
            }
        } label: {
            Label("Go To", systemImage: "text.insert")
        }
    }
}

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser(game: EmojiMemoryGame())
    }
}
