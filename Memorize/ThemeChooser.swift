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
    var chosenTheme: Theme {
        store.themes[store.chosenThemeIndex]
    }
    
    var body: some View {
        themeControlButton
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
            // Edit Theme
        }
        AnimatedActionButton(title: "New", systemImage: "plus") {
            store.insertTheme(named: "New")
        }
        AnimatedActionButton(title: "Delete", systemImage: "minus.circle") {
            // Delete Theme
        }
        AnimatedActionButton(title: "Manager", systemImage: "slider.vertical.3") {
            // Manage Themes
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
                            .fill(.red)
                            .frame(width: 20, height: 20)
                            .fixedSize()
                    }
                    Text("Number of Cards Dealt: \(theme.numCardsDealt)")
                   
                    
                }
            }
        }
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
        .background(.black)
    }
}

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser(game: EmojiMemoryGame())
    }
}
