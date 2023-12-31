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
    @State var showingGoToMenu = false
    @State var themeToEdit: Theme?
    @State private var managing = false
    
    var chosenTheme: Theme {
        store.themes[store.chosenThemeIndex]
    }
    
    var body: some View {
        themeControlButton
            .sheet(item: $themeToEdit, content: { theme in
                ThemeEditor(theme: $store.themes[theme])
                    .onDisappear {
                        game.changeThemes(theme: chosenTheme)
                    }
            })
            .sheet(isPresented: $managing) {
                ThemeManager()
            }
            
    }
    
    var themeControlButton: some View {
        Button {
            withAnimation {
                store.chosenThemeIndex = (store.chosenThemeIndex + 1) % store.themes.count
                game.changeThemes(theme: chosenTheme)
            }
        } label: {
            Label(chosenTheme.name, systemImage: "paintbrush.pointed")
        }
        .contextMenu { contextMenu }
        .sheet(isPresented: $showingGoToMenu) {
            goToMenu
        }
    }
    
    
    @ViewBuilder
    var contextMenu: some View {
        AnimatedActionButton(title: "Edit", systemImage: "pencil") {
            themeToEdit = store.theme(at: store.chosenThemeIndex)
        }
        AnimatedActionButton(title: "New", systemImage: "plus") {
            store.insertTheme(named: "New")
            themeToEdit = store.theme(at: store.chosenThemeIndex)
            game.changeThemes(theme: chosenTheme)
        }
        AnimatedActionButton(title: "Delete", systemImage: "minus.circle") {
            store.chosenThemeIndex = store.removeTheme(at: store.chosenThemeIndex)
        }
        AnimatedActionButton(title: "Manager", systemImage: "slider.vertical.3") {
            managing = true
        }
        Button("Show Sheet") {
            showingGoToMenu.toggle()
        }
    }
    
    
    @ViewBuilder
    var goToMenu: some View {
        List {
            ForEach (store.themes) { theme in
                VStack (alignment: .leading) {
                    AnimatedActionButton(title: theme.name) {
                        if let index = store.themes.index(matching: theme) {
                            store.chosenThemeIndex = index
                        }
                        game.changeThemes(theme: theme)
                        showingGoToMenu.toggle()
                    }
                    Spacer()
                    Text("Available Emojis:")
                    Text("\(theme.emojis)")
                    HStack {
                        Text("Card Background Color: ")
                        Rectangle()
                            .fill(Color(rgbaColor:theme.cardColor))
                            .frame(width: 20, height: 20)
                            .fixedSize()
                    }
                    Text("Number of Cards Dealt: \(theme.numCardsDealt)")
                   
                    
                }
            }
        }
    }
}


//struct ThemeChooser_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeChooser(game: EmojiMemoryGame())
//    }
//}
