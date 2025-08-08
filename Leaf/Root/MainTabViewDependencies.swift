//
//  AppDependencies.swift
//  Leaf
//
//  Created by ddorsat on 30.07.2025.
//

import Foundation

final class MainTabViewDependencies {
    lazy var transactionService = TransactionServiceImplementation()
    lazy var cardService = CardServiceImplementation()
    
    lazy var cardsViewModel = CardsViewModel(cardService: cardService, cardDetailsViewModel: cardDetailsViewModel)
    
    lazy var mainViewModel = MainViewModel(cardsViewModel: cardsViewModel,
                                           cardDetailsViewModel: cardDetailsViewModel,
                                           expenseViewModel: expenseViewModel,
                                           topUpViewModel: topUpViewModel,
                                           transactionService: transactionService)
    
    lazy var historyViewModel = HistoryViewModel(cardsViewModel: cardsViewModel,
                                                 transactionService: transactionService)
    
    lazy var cardDetailsViewModel = CardDetailsViewModel(cardService: cardService,
                                                         transactionService: transactionService)
    
    lazy var expenseViewModel = ExpenseViewModel(cardsViewModel: cardsViewModel,
                                                 transactionService: transactionService)
    
    lazy var topUpViewModel = TopUpViewModel(cardsViewModel: cardsViewModel,
                                             transactionService: transactionService)
}
