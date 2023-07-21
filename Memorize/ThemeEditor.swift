//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Raymond Chen on 7/20/23.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    
    
    var body: some View {
        Form {
            nameSection
            numCardsDealtSection
            cardColorPicker
            addEmojisSection
            removeEmojisSection
            
        }
        .navigationTitle("Edit \(theme.name)")
        .frame(minWidth: 300, minHeight: 350)
        .onAppear {
            numCardsDealt = theme.numCardsDealt
        }
        .onDisappear {
            theme.numCardsDealt = min(theme.emojis.count, numCardsDealt)
        }
    }
    
    var nameSection: some View {
        Section {
            TextField("Name", text: $theme.name)
        } header: {
            Text("Name")
        }
    }
    
    @State private var emojisToAdd = ""
    
    var addEmojisSection: some View {
        Section {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        } header: {
            Text("Add Emojis")
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            theme.emojis = (emojis + theme.emojis)
                .filter {$0.isEmoji}
                .removingDuplicateCharacters
        }
    }
    
    var removeEmojisSection: some View {
        Section {
            let emojis = theme.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                theme.emojis.removeAll(where: {String($0) == emoji})
                            }
                        }
                }
            }
        } header: {
            Text("Remove Emoji")
        }
    }
    
    @State private var numCardsDealt: Int = 0
    
    var numCardsDealtSection: some View {
        Section {
            TextField("Number of Cards Dealt", value: $numCardsDealt, format: .number)
        } header: {
            Text("Number of Cards Dealt")
        }
    }
    
    private var cardColor: Binding<Color> {
        Binding {
            return Color(rgbaColor: theme.cardColor)
        } set: { updatedColor in
            theme.cardColor = RGBAColor(color: updatedColor)
        }
    }
    
    var cardColorPicker: some View {
        Section {
            ColorPicker("Card Color", selection: cardColor)
        }
    }
}
