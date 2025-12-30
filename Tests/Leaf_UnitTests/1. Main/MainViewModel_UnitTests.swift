//
//  MainViewModel.swift
//  Leaf_Tests
//
//  Created by ddorsat on 06.08.2025.
//

import XCTest
import CoreData
@testable import Leaf

@MainActor
final class MainViewModel_UnitTests: XCTestCase {
    var context: NSManagedObjectContext!
    
    var cardService: MockCardService!
    var transactionService: MockTransactionService!
    
    var cardDetailsViewModel: CardDetailsViewModel!
    var cardsViewModel: CardsViewModel!
    var expenseViewModel: ExpenseViewModel!
    var topUpViewModel: TopUpViewModel!
    
    var viewModel: MainViewModel!
    
    override func setUpWithError() throws {
        context = ContainerService.makeInMemoryContext()
        cardService = MockCardService(context: context)
        transactionService = MockTransactionService(context: context)
        
        cardDetailsViewModel = CardDetailsViewModel(cardService: cardService, transactionService: transactionService)
        cardsViewModel = CardsViewModel(cardService: cardService, cardDetailsViewModel: cardDetailsViewModel)
        expenseViewModel = ExpenseViewModel(cardsViewModel: cardsViewModel, transactionService: transactionService)
        topUpViewModel = TopUpViewModel(cardsViewModel: cardsViewModel, transactionService: transactionService)
        
        viewModel = MainViewModel(cardsViewModel: cardsViewModel, cardDetailsViewModel: cardDetailsViewModel, expenseViewModel: expenseViewModel, topUpViewModel: topUpViewModel, transactionService: transactionService)
    }

    override func tearDownWithError() throws {
        context = nil
        cardService = nil
        transactionService = nil
        
        cardsViewModel = nil
        cardDetailsViewModel = nil
        expenseViewModel = nil
        topUpViewModel = nil
        
        viewModel = nil
    }
    
    func test_totalBalance() {
        // Given
        let card1 = ContainerService.createTestCard(context: context)
        let card2 = ContainerService.createTestCard(context: context)
        cardsViewModel.cards = [card1, card2]
        
        XCTAssertEqual(cardsViewModel.cards.count, 2)
        XCTAssertEqual(card1.balance, 100)
        XCTAssertEqual(card2.balance, 100)
        
        // When
        let total = viewModel.totalBalance
        
        // Then
        XCTAssertEqual(total, Formatters.sumFormatter(sum: 200))
        XCTAssertFalse(viewModel.totalBalance.isEmpty)
    }
    
    func test_fetchCards() async {
        // Given
        let mockCardsViewModel = MockCardsViewModel(cardService: cardService, cardDetailsViewModel: cardDetailsViewModel)
        let mockExpenseViewModel = ExpenseViewModel(cardsViewModel: mockCardsViewModel, transactionService: transactionService)
        let mockTopUpViewModel = TopUpViewModel(cardsViewModel: mockCardsViewModel, transactionService: transactionService)
        
        let viewModel = MainViewModel(cardsViewModel: mockCardsViewModel, cardDetailsViewModel: cardDetailsViewModel, expenseViewModel: mockExpenseViewModel, topUpViewModel: mockTopUpViewModel, transactionService: transactionService)
        
        // When
        await viewModel.fetchCards()
        
        // Then
        XCTAssertEqual(mockCardsViewModel.fetchCardsCount, 3)
    }
    
    func test_fetchTransactions() {
        // Given
        let transaction = ContainerService.createTestTransaction(context: context)
        transactionService.transactions = [transaction]
        
        XCTAssertEqual(transactionService.transactions.count, 1)
        XCTAssertEqual(viewModel.transactions.count, 0)
        
        // When
        viewModel.fetchTransactions()
        
        // Then
        XCTAssertEqual(viewModel.transactions.count, 1)
        XCTAssertEqual(viewModel.transactions.first?.cardName, "TEST CARD")
    }
    
    func test_deleteTransaction() {
        // Given
        let transaction = ContainerService.createTestTransaction(context: context)
        viewModel.transactions = [transaction]
        
        XCTAssertFalse(transactionService.didCallDelete)
        XCTAssertEqual(viewModel.transactions.count, 1)
        
        // When
        viewModel.deleteTransaction(transaction: transaction)
        
        // Then
        viewModel.fetchTransactions()
        
        XCTAssertTrue(transactionService.didCallDelete)
        XCTAssertEqual(viewModel.transactions.count, 0)
    }
}
