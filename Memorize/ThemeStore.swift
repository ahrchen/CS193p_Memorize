//
//  ThemeStore.swift
//  Memorize
//
//  Created by Raymond Chen on 7/15/23.
//

import SwiftUI

struct Theme: Identifiable, Codable, Hashable {
    var name: String
    var emojis: String
    var id: Int
    var numCardsDealt: Int
    var cardColor: RGBAColor
    
    var emojisArray: [String] {
        emojis.map({String($0)})
    }
    
    init(name: String, emojis: String, id: Int, numCardsDealt: Int, cardColor: RGBAColor) {
        self.name = name
        self.emojis = emojis
        self.id = id
        self.numCardsDealt = numCardsDealt
        self.cardColor = cardColor
    }
    
    init (name: String, emojis: String, id: Int) {
        self.name = name
        self.emojis = emojis
        self.id = id
        self.numCardsDealt = 5
        self.cardColor = RGBAColor(color: .red)
    }
}

class ThemeStore: ObservableObject {
    let name: String
    var chosenThemeIndex: Int = 0
    @Published var themes = [Theme]()
    
    init(named name: String) {
        self.name = name
//        restoreFromUserDefaults()
        if themes.isEmpty {
            print("Using built-in themes")
            insertTheme(named: "Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜")
            insertTheme(named: "Sports", emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳")
            insertTheme(named: "Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻")
            insertTheme(named: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔")
            insertTheme(named: "Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲")
            insertTheme(named: "Flora", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻")
            insertTheme(named: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪")
            insertTheme(named: "COVID", emojis: "💉🦠😷🤧🤒")
            insertTheme(named: "Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠")
        } else {
            print("successfully loaded themes from userDefaults")
        }
    }
    
    func insertTheme(named name: String, emojis: String? = nil, at index: Int = 0) {
        let unique = (themes.max(by: {$0.id < $1.id})?.id ?? 0) + 1
        let theme = Theme(name: name, emojis: emojis ?? "", id: unique)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
}


