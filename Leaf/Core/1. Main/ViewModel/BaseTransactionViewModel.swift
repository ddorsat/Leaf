//
//  BasicTransactionViewModel.swift
//  Leaf
//
//  Created by ddorsat on 30.07.2025.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class BaseTransactionViewModel: ObservableObject {
    @Published var cardsViewModel: CardsViewModel
    @Published var selectedCard: String? = nil
    @Published var selectedSum: String = ""
    
    init(cardsViewModel: CardsViewModel) {
        self.cardsViewModel = cardsViewModel
    }
    
    var totalBalance: String {
        let value = Double(cardsViewModel.cards.map { $0.balance }.reduce(0, +))
        return Formatters.sumFormatter(sum: value)
    }
    
    var transactionSum: Double {
        Double(selectedSum) ?? 0
    }

    var cards: [Card] {
        cardsViewModel.cards
    }

    var allCards: [String] {
        cards.map { $0.number ?? "" }
    }

    var selectedCardBalance: String {
        guard let selectedCard else { return "" }
        
        let card = cards.first(where: { $0.number == selectedCard })
        return Formatters.sumFormatter(sum: card?.balance ?? 0)
    }

    var transactionCard: Card? {
        guard let selectedCard else { return nil }
        
        return cards.first(where: { $0.number == selectedCard })
    }

    func onDisappear() {
        selectedCard = nil
        selectedSum = ""
    }
}
