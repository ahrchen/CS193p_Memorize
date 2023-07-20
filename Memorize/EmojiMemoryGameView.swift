//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Raymond Chen on 6/12/22.
//
// Completed Lecture 8 with animations

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    @EnvironmentObject var store: ThemeStore
    var theme: Theme {
        store.themes[store.chosenThemeIndex]
    }
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    VStack(alignment: .leading) {
                        Text("Score: \(game.getScore())")
                        ThemeChooser(game: game)
                    }
                    Spacer()
                    VStack {
                        shuffle
                        restart
                    }
                }
            }
            deckBody
        }
        .padding()
        .onAppear {
            game.changeThemes(theme: theme)
        }
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 1)) {
                            game.choose(card)
                        }
                    }
            }
        }
        
        .foregroundColor(Color(rgbaColor: theme.cardColor))
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor((Color(rgbaColor: theme.cardColor)))
        .onTapGesture {
            // "deal" cards
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation(.easeInOut(duration: 1)) {
                game.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation() {
                dealt = []
                game.restart()
                
            }
        }
    }
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let theme =  "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜".map{ String($0) }
//        let game = EmojiMemoryGame(theme: theme)
//        game.choose(game.cards.first!)
//        return EmojiMemoryGameView(game: game)
//    }
//}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    private var cardDegrees: Double {
        get {
            card.isMatched ? 360 : 0
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                .padding(5)
                .opacity(DrawingConstants.pieOpacity)
                
                Text(card.content)
                    .rotationEffect(Angle(degrees: cardDegrees))
                    .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: cardDegrees)
                    .font(font(in:geometry.size))
            }
        }
        .cardify(isFaceUp: card.isFaceUp)
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
        static let pieOpacity: CGFloat = 0.5
    }
}
