//
//  TopUpBalanceViewModel.swift
//  Leaf
//
//  Created by ddorsat on 30.07.2025.
//

import Foundation
import SwiftUI
import Combine
import AlertKit
import CoreData

final class TopUpViewModel: BaseTransactionViewModel {
    @Published var showFillAllFieldsAlert: Bool = false
    @Published var showSuccessfulPopUpAlert: Bool = false
    
    var fillAllFieldsAlert = AlertAppleMusic17View(title: "Заполните все поля", subtitle: nil, icon: .error)
    var successfulTopUpAlert = AlertAppleMusic17View(title: "Успешное пополнение", subtitle: nil, icon: .heart)
    
    private let transactionService: TransactionServiceProtocol
    
    init(cardsViewModel: CardsViewModel, transactionService: TransactionServiceProtocol) {
        self.transactionService = transactionService
        super.init(cardsViewModel: cardsViewModel)
    }
    
    func topUpBalance() {
        guard selectedCard != nil, !selectedSum.isEmpty else {
            showFillAllFieldsAlert = true
            Haptics.impact(.light)
            return
        }
        
        showSuccessfulPopUpAlert = true
        transactionCard?.balance += transactionSum
        
        let transaction = transactionService.topUpBalance()
        transaction.card = transactionCard
        transaction.cardName = transactionCard?.name
        transaction.cardNumber = transactionCard?.number
        transaction.icon = "arrow.down.to.line"
        transaction.sum = transactionSum
        transaction.status = "Пополнение"
        transaction.timestamp = Date()
        
        transactionService.save()
    }
}
