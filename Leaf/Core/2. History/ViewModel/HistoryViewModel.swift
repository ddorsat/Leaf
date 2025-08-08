//
//  HistoryViewModel.swift
//  Leaf
//
//  Created by ddorsat on 31.07.2025.
//

import Foundation
import Combine
import SwiftUI
import CoreData
import AlertKit

final class HistoryViewModel: ObservableObject, TransactionDetailsProtocol, TransactionsProtocol {
    @Published var historyRoutes: [HistoryRoutes] = []
    @Published var transactions: [CardTransaction] = []
    @Published var showEllipsis: Bool = false
    @Published var hasMoreTransactions: Bool = true
    @Published var totalBalance: String = ""
    @Published var groceriesSum: Double = 0
    @Published var bankTransferSum: Double = 0
    @Published var shoppingSum: Double = 0
    @Published var othersSum: Double = 0
    
    private let cardsViewModel: CardsViewModel
    private let transactionService: TransactionServiceProtocol
    private let notificationCenter: NotificationCenter
    private var cancellables = Set<AnyCancellable>()
    
    init(cardsViewModel: CardsViewModel,
         transactionService: TransactionServiceProtocol,
         notificationCenter: NotificationCenter = .default) {
        self.cardsViewModel = cardsViewModel
        self.transactionService = transactionService
        self.notificationCenter = notificationCenter
        
        cardsViewModel.fetchCards()
        fetchTransactions()
        calculateTotals()
        calculateTotalBalance()
        observeTransactions()
    }
    
    deinit {
        cancellables.removeAll()
        notificationCenter.removeObserver(self)
    }
    
    func fetchTransactions() {
        do {
            self.transactions = try transactionService.fetchTransactions(limit: Int.max)
        }  catch {
            print("Failed to fetch transactions - \(error.localizedDescription)")
        }
    }
    
    private func observeTransactions() {
        notificationCenter.publisher(for: .NSManagedObjectContextDidSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.fetchTransactions()
                self.calculateTotals()
            }
            .store(in: &cancellables)
    }
    
    func deleteTransaction(transaction: CardTransaction) {
        transactionService.deleteTransaction(transaction)
        calculateTotals()
    }
    
    func calculateTotalBalance() {
        let value = Double(cardsViewModel.cards.map { $0.balance }.reduce(0, +))
        self.totalBalance = Formatters.sumFormatter(sum: value)
    }
    
    func calculateTotals() {
        do {
            let transactions = try transactionService.fetchTransactions(limit: Int.max)
            
            groceriesSum = sum(category: "Продукты", transactions: transactions)
            bankTransferSum = sum(category: "Банковский перевод", transactions: transactions)
            shoppingSum = sum(category: "Шоппинг", transactions: transactions)
            othersSum = sum(category: "Другое", transactions: transactions)
        } catch {
            print("Failed to calculate totals: \(error.localizedDescription)")
        }
    }
    
    private func sum(category: String, transactions: [CardTransaction]) -> Double {
        transactions
            .filter { $0.category == category }
            .map { $0.sum }
            .reduce(0, +)
    }
}

enum HistoryRoutes: Hashable {
    case transactionDetails(CardTransaction)
}
