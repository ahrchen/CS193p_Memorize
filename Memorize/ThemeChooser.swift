//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Raymond Chen on 7/13/23.
//

import SwiftUI

struct ThemeChooser: View {
    @State var chosenThemeIndex = 0
    let themes = [
        "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜".map{ String($0) },
        "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳".map{ String($0) }
    ]
    
    var body: some View {
        themeControlButton
    }
    
    var themeControlButton: some View {
        Button {
            withAnimation {
                chosenThemeIndex = (chosenThemeIndex + 1) % themes.count
            }
        } label: {
            Image(systemName: "paintbrush.pointed")
        }
    }
}

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser()
    }
}
