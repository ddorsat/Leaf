//
//  HistoryViewModel_Tests.swift
//  Leaf_Tests
//
//  Created by ddorsat on 07.08.2025.
//

import XCTest
import CoreData
@testable import Leaf

final class HistoryViewModel_UnitTests: XCTestCase {
    var context: NSManagedObjectContext!
    
    var cardService: MockCardService!
    var transactionService: MockTransactionService!
    
    var cardDetailsViewModel: CardDetailsViewModel!
    var cardsViewModel: CardsViewModel!
    
    var viewModel: HistoryViewModel!

    override func setUpWithError() throws {
        context = ContainerService.makeInMemoryContext()
        
        cardService = MockCardService(context: context)
        transactionService = MockTransactionService(context: context)
        
        cardDetailsViewModel = CardDetailsViewModel(cardService: cardService, transactionService: transactionService)
        cardsViewModel = CardsViewModel(cardService: cardService, cardDetailsViewModel: cardDetailsViewModel)
        
        viewModel = HistoryViewModel(cardsViewModel: cardsViewModel, transactionService: transactionService)
    }

    override func tearDownWithError() throws {
        context = nil
        cardService = nil
        transactionService = nil
        cardDetailsViewModel = nil
        cardsViewModel = nil
        viewModel = nil
    }
    
    func test_fetchTransactions() {
        // Given
        let transaction = ContainerService.createTestTransaction(context: context, category: "Шоппинг")
        transactionService.transactions = [transaction]
        
        XCTAssertTrue(viewModel.transactions.isEmpty)
        
        // When
        viewModel.fetchTransactions()
        
        // Then
        XCTAssertEqual(viewModel.transactions.count, 1)
        XCTAssertEqual(viewModel.transactions.first?.sum, 100)
        XCTAssertFalse(viewModel.transactions.isEmpty)
    }
    
    func test_deleteTransaction() {
        // Given
        let transaction = ContainerService.createTestTransaction(context: context, category: "Продукты")
        transactionService.transactions = [transaction]
        
        viewModel.calculateTotals()
        XCTAssertFalse(transactionService.didCallDelete)
        XCTAssertEqual(viewModel.groceriesSum, 100)
        
        // When
        viewModel.deleteTransaction(transaction: transaction)
        
        // Then
        XCTAssertTrue(transactionService.didCallDelete)
        XCTAssertEqual(viewModel.transactions.count, 0)
        XCTAssertEqual(viewModel.groceriesSum, 0)
    }
    
    func test_calculateTotalBalance() {
        // Given
        let card1 = ContainerService.createTestCard(context: context)
        let card2 = ContainerService.createTestCard(context: context)
        cardsViewModel.cards = [card1, card2]
        
        XCTAssertEqual(viewModel.totalBalance, Formatters.sumFormatter(sum: 0))
        
        // When
        viewModel.calculateTotalBalance()
        
        // Then
        XCTAssertEqual(viewModel.totalBalance, Formatters.sumFormatter(sum: 200))
    }
    
    func test_calculateTotals() {
        // Given
        let groceries = ContainerService.createTestTransaction(context: context, category: "Продукты")
        let bankTransfers = ContainerService.createTestTransaction(context: context, category: "Банковский перевод")
        let shopping = ContainerService.createTestTransaction(context: context, category: "Шоппинг")
        let other = ContainerService.createTestTransaction(context: context, category: "Другое")
        transactionService.transactions = [groceries, bankTransfers, shopping, other]
        
        XCTAssertEqual(viewModel.groceriesSum, 0)
        XCTAssertEqual(viewModel.bankTransferSum, 0)
        XCTAssertEqual(viewModel.shoppingSum, 0)
        XCTAssertEqual(viewModel.othersSum, 0)
        
        // When
        viewModel.calculateTotals()
        
        // Then
        XCTAssertEqual(viewModel.groceriesSum, 100)
        XCTAssertEqual(viewModel.bankTransferSum, 100)
        XCTAssertEqual(viewModel.shoppingSum, 100)
        XCTAssertEqual(viewModel.othersSum, 100)
    }
}
