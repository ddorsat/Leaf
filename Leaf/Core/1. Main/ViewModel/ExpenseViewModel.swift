//
//  ExpenseViewModel.swift
//  Leaf
//
//  Created by ddorsat on 30.07.2025.
//

import Foundation
import SwiftUI
import Combine
import CoreData
import AlertKit

final class ExpenseViewModel: BaseTransactionViewModel {
    @Published var selectedCategory: String? = nil
    @Published var showFillAllFieldsAlert: Bool = false
    @Published var showNotEnoughtCreditsAlert: Bool = false
    @Published var showSuccessfulTransactionAlert: Bool = false
    @Published var showEllipsis: Bool = false
    
    var fillAllFieldsAlert = AlertAppleMusic17View(title: "Заполните все поля", subtitle: nil, icon: .error)
    var notEnoughCreditsAlert = AlertAppleMusic17View(title: "Недостаточно средств", subtitle: nil, icon: .error)
    var successfulTransactionAlert = AlertAppleMusic17View(title: "Успешная транзакция", subtitle: nil, icon: .done)
    
    var categories: [String] = ["Продукты", "Банковский перевод", "Шоппинг", "Другое"]
    
    private let transactionService: TransactionServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(cardsViewModel: CardsViewModel, transactionService: TransactionServiceProtocol) {
        self.transactionService = transactionService
        super.init(cardsViewModel: cardsViewModel)
    }
    
    func addTransaction() {
        guard selectedCategory != nil, !selectedSum.isEmpty, selectedCard != nil else {
            showFillAllFieldsAlert = true
            Haptics.impact(.light)
            return
        }
        
        guard (Double(selectedSum) ?? 0) <= (transactionCard?.balance ?? 0) else {
            showNotEnoughtCreditsAlert = true
            Haptics.impact(.light)
            return
        }
        
        showSuccessfulTransactionAlert = true
        transactionCard?.balance -= transactionSum
        
        let transaction = transactionService.addTransaction()
        transaction.card = transactionCard
        transaction.category = selectedCategory
        transaction.icon = iconHandler(selectedCategory ?? "")
        transaction.sum = transactionSum
        transaction.cardName = transactionCard?.name
        transaction.cardNumber = transactionCard?.number
        transaction.status = "Списание"
        transaction.timestamp = Date()
        
        transactionService.save()
    }
    
    private func iconHandler(_ selectedCategory: String) -> String {
        if selectedCategory == "Продукты" {
            return "cart"
        } else if selectedCategory == "Банковский перевод" {
            return "arrow.up.to.line"
        } else if selectedCategory == "Шоппинг" {
            return "bag"
        } else {
            return "tree"
        }
    }
    
    func deleteTransaction(transaction: CardTransaction) {
        transactionService.deleteTransaction(transaction)
    }
    
    override func onDisappear() {
        super.onDisappear()
        selectedCategory = "Выберите категорию"
    }
}
