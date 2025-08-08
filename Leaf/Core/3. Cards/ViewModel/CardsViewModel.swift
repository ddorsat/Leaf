//
//  CardsViewModel.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import Foundation
import SwiftUI
import Combine
import CoreData
import AlertKit

class CardsViewModel: ObservableObject {
    @Published var cardRoutes: [CardsRoutes] = []
    @Published var cards: [Card] = []
    @Published var name: String = ""
    @Published var number: String = ""
    @Published var date: String = ""
    @Published var color: Color = .gray
    @Published var type: CardTypes = .visa
    @Published var balance: String = ""
    @Published var showEllipsis: Bool = false
    @Published var showValidCard: Bool = false
    @Published var showInvalidCard: Bool = false
    @Published var cardToDelete: Card? = nil
    
    var validCardAlert = AlertAppleMusic17View(title: "Карта добавлена", subtitle: nil, icon: .done)
    var invalidCardAlert = AlertAppleMusic17View(title: "Заполните все поля", subtitle: nil, icon: .error)
    
    let cardDetailsViewModel: CardDetailsViewModel
    private let cardService: CardServiceProtocol
    private let notificationCenter: NotificationCenter
    private var cancellables = Set<AnyCancellable>()
    
    init(cardService: CardServiceProtocol,
         cardDetailsViewModel: CardDetailsViewModel,
         notificationCenter: NotificationCenter = .default) {
        self.cardDetailsViewModel = cardDetailsViewModel
        self.cardService = cardService
        self.notificationCenter = notificationCenter
        
        observeCards()
    }
    
    deinit {
        cancellables.removeAll()
        notificationCenter.removeObserver(self)
    }
    
    func fetchCards() {
        do {
            self.cards = try cardService.fetchCards()
        } catch {
            print("Failed to fetch cards - \(error.localizedDescription)")
        }
    }
    
    func addCard() {
        guard !name.isEmpty, number.count == 19, !date.isEmpty, !balance.isEmpty else {
            showInvalidCard = true
            Haptics.impact(.light)
            return
        }
        
        showValidCard = true
        
        let card = cardService.addCard()
        card.name = name
        card.number = number
        card.date = date
        card.color = UIColor(color).encode()
        card.type = type.rawValue
        card.balance = Double(balance) ?? 0
        
        cardService.save()
    }
    
    func observeCards() {
        notificationCenter.publisher(for: .NSManagedObjectContextDidSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchCards()
            }
            .store(in: &cancellables)
    }
    
    func deleteCard() {
        if let cardToDelete {
            cardService.deleteCard(cardToDelete)
            cardService.save()
        }
    }
    
    func handleEllipsis(card: Card) {
        showEllipsis.toggle()
        cardToDelete = card
    }
    
    func onDisappear() {
        name = ""
        number = ""
        date = ""
        color = .gray
        type = .visa
        balance = ""
    }
}

enum CardsRoutes: Hashable {
    case cardDetails(Card)
    case transactionDetails(CardTransaction)
}

