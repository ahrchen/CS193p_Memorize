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
            removedEmojisSection
            
        }
        .navigationTitle("Edit \(theme.name)")
        .frame(minWidth: 300, minHeight: 350)
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
    
    @State private var emojisToRemove = ""
    
    var removeEmojisSection: some View {
        Section {
            let emojis = theme.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                emojisToRemove =  (emojisToRemove + emoji)
                                theme.emojis.removeAll(where: {String($0) == emoji})
                            }
                        }
                }
            }
        } header: {
            Text("Remove Emoji")
        }
    }
    
    var removedEmojisSection: some View {
        Section {
            let emojis = emojisToRemove.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                addEmojis(emoji)
                                emojisToRemove.removeAll(where: {String($0) == emoji})
                            }
                        }
                }
            }
        } header: {
            Text("Removed Emoji")
        }
    }
    
    private var numberCardsDealt: Binding<Double> {
        Binding {
            return Double(theme.numCardsDealt)
        } set: { updateNumberCardsDealt in
            theme.numCardsDealt = min(theme.emojis.count, Int(updateNumberCardsDealt))
        }
    }
    
    var numCardsDealtSection: some View {
        Section {
            Slider(value: numberCardsDealt, in: 1...Double(theme.emojisArray.count), step: 1) {
                Text("Number Pair Cards Dealt")
            } minimumValueLabel: {
                Text("1")
            } maximumValueLabel: {
                Text("\(theme.emojisArray.count)")
            }
        } header: {
            Text("Number Pair of Cards Dealt: \(theme.numCardsDealt)")
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
