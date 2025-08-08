//
//  MainViewModel.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import Foundation
import SwiftUI
import Combine
import CoreData
import AlertKit

protocol TransactionsProtocol {
    var transactions: [CardTransaction] { get }
}

final class MainViewModel: ObservableObject, TransactionDetailsProtocol, TransactionsProtocol {
    @Published var mainRoutes: [MainRoutes] = []
    @Published var transactions: [CardTransaction] = []
    @Published var hideBalance: Bool = false
    @Published var showExpenseView: Bool = false
    @Published var showTopUpView: Bool = false
    @Published var showAddCard: Bool = false
    @Published var showEllipsis: Bool = false
    
    let cardsViewModel: CardsViewModel
    let cardDetailsViewModel: CardDetailsViewModel
    let expenseViewModel: ExpenseViewModel
    let topUpViewModel: TopUpViewModel
    
    private let transactionService: TransactionServiceProtocol
    private let notificationCenter: NotificationCenter
    private var cancellables = Set<AnyCancellable>()
    
    var totalBalance: String {
        let value = Double(cardsViewModel.cards.map { $0.balance }.reduce(0, +))
        return Formatters.sumFormatter(sum: value)
    }
    
    init(cardsViewModel: CardsViewModel,
         cardDetailsViewModel: CardDetailsViewModel,
         expenseViewModel: ExpenseViewModel,
         topUpViewModel: TopUpViewModel,
         transactionService: TransactionServiceProtocol,
         notificationCenter: NotificationCenter = .default) {
        self.cardsViewModel = cardsViewModel
        self.cardDetailsViewModel = cardDetailsViewModel
        self.expenseViewModel = expenseViewModel
        self.topUpViewModel = topUpViewModel
        self.transactionService = transactionService
        self.notificationCenter = notificationCenter
        
        listenToCards()
        fetchTransactions()
        observeTransactions()
    }
    
    deinit {
        cancellables.removeAll()
        notificationCenter.removeObserver(self)
    }
    
    func fetchCards() async {
        await withTaskGroup(of: Void.self) { task in
            task.addTask { await self.cardsViewModel.fetchCards() }

            task.addTask { await self.expenseViewModel.cardsViewModel.fetchCards() }

            task.addTask { await self.topUpViewModel.cardsViewModel.fetchCards() }
        }
    }
    
    private func listenToCards() {
        Publishers.Merge(expenseViewModel.objectWillChange,
                         topUpViewModel.objectWillChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func fetchTransactions() {
        do {
            self.transactions = try transactionService.fetchTransactions(limit: 6)
        } catch {
            print("Failed to fetch card transactions - \(error.localizedDescription)")
        }
    }
    
    private func observeTransactions() {
        notificationCenter.publisher(for: .NSManagedObjectContextDidSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchTransactions()
            }
            .store(in: &cancellables)
    }
    
    func deleteTransaction(transaction: CardTransaction) {
        transactionService.deleteTransaction(transaction)
    }
}

enum MainRoutes: Hashable {
    case cardDetails(card: Card)
    case transactionDetails(transaction: CardTransaction)
}

