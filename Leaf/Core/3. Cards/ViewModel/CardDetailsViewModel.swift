//
//  CardDetailsViewModel.swift
//  Leaf
//
//  Created by ddorsat on 30.07.2025.
//

import Foundation
import SwiftUI
import Combine
import CoreData

final class CardDetailsViewModel: ObservableObject, TransactionDetailsProtocol {
    @Published var transactions: [CardTransaction] = []
    @Published var showEllipsis: Bool = false
    @Published var showExpenseView: Bool = false
    @Published var showTopUpView: Bool = false
    
    private let cardService: CardServiceProtocol
    private let transactionService: TransactionServiceProtocol
    private let notificationCenter: NotificationCenter
    private var cancellables = Set<AnyCancellable>()
    
    init(cardService: CardServiceProtocol,
         transactionService: TransactionServiceProtocol,
         notificationCenter: NotificationCenter = .default) {
        self.cardService = cardService
        self.transactionService = transactionService
        self.notificationCenter = notificationCenter
    }
    
    func fetchTransactions(_ card: Card) {
        do {
            transactions = try cardService.fetchTransactions(card)
        } catch {
            print("Failed to fetch card transactions - \(error.localizedDescription)")
        }
    }
    
    func observeTransactions(_ card: Card) {
        notificationCenter.publisher(for: .NSManagedObjectContextDidSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchTransactions(card)
            }
            .store(in: &cancellables)
    }
    
    func deleteTransaction(transaction: CardTransaction) {
        transactionService.deleteTransaction(transaction)
    }
    
    func deleteCard(_ card: Card) {
        cardService.deleteCard(card)
    }
}
