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
            cardColorSection
            addEmojisSection
            removeEmojisSection
            
        }
        .navigationTitle("Edit \(theme.name)")
        .frame(minWidth: 300, minHeight: 350)
        .onAppear {
            red = theme.cardColor.red * 255
            green = theme.cardColor.green * 255
            blue = theme.cardColor.blue * 255
            alpha = theme.cardColor.alpha
            numCardsDealt = theme.numCardsDealt
        }
        .onDisappear {
            theme.cardColor = RGBAColor(red: red/255, green: green/255, blue: blue/255 , alpha: alpha)
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
    
    @State private var red: Double = 0
    @State private var green: Double = 0
    @State private var blue: Double = 0
    @State private  var alpha: Double = 0
    
    var cardColorSection: some View {
        
        Section {
            HStack {
                Text("Red")
                Divider()
                TextField("Red", value: $red, format: .number)
            }
            HStack {
                Text("Green")
                Divider()
                TextField("Green", value: $green, format: .number)
            }
            HStack {
                Text("Blue")
                Divider()
                TextField("Blue", value: $blue, format: .number)
            }
            HStack {
                Text("Alpha")
                Divider()
                TextField("Alpha", value: $alpha, format: .number)
            }
        } header: {
            Text("Card Color Section")
        }
    }
}
