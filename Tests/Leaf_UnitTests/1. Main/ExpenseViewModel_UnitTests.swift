//
//  ExpenseViewModel_Tests.swift
//  Leaf_Tests
//
//  Created by ddorsat on 06.08.2025.
//

import XCTest
import CoreData
@testable import Leaf

final class ExpenseViewModel_UnitTests: XCTestCase {
    var context: NSManagedObjectContext!
    
    var transactionService: MockTransactionService!
    var cardService: MockCardService!
    var cardsViewModel: CardsViewModel!
    
    var viewModel: ExpenseViewModel!
    
    override func setUpWithError() throws {
        context = ContainerService.makeInMemoryContext()
        transactionService = MockTransactionService(context: context)
        cardService = MockCardService(context: context)
        cardsViewModel = CardsViewModel(cardService: cardService, cardDetailsViewModel: CardDetailsViewModel(cardService: cardService, transactionService: transactionService))
        viewModel = ExpenseViewModel(cardsViewModel: cardsViewModel, transactionService: transactionService)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        transactionService = nil
        cardService = nil
        context = nil
        cardsViewModel = nil
    }
    
    func test_showFillAllFieldsAlert() {
        // Given
        viewModel.selectedCategory = nil
        viewModel.selectedSum = ""
        viewModel.selectedCard = nil
        
        // When
        viewModel.addTransaction()
        
        // Then
        XCTAssertTrue(viewModel.showFillAllFieldsAlert)
    }
    
    func test_showNotEnoughtCreditsAlert() {
        // Given
        let card = ContainerService.createTestCard(context: context)
        cardsViewModel.cards = [card]
        
        XCTAssertEqual(cardsViewModel.cards.count, 1)
        
        viewModel.selectedCard = card.number
        viewModel.selectedCategory = "Продукты"
        viewModel.selectedSum = "150"
        
        // When
        viewModel.addTransaction()
        
        // Then
        XCTAssertTrue(viewModel.showNotEnoughtCreditsAlert)
    }
    
    func test_showSuccessfulTransactionAlert() {
        // Given
        let card = ContainerService.createTestCard(context: context)
        cardsViewModel.cards = [card]
        
        XCTAssertEqual(cardsViewModel.cards.count, 1)
        
        viewModel.selectedCard = "1234 5678 9123 4567"
        viewModel.selectedCategory = "Продукты"
        viewModel.selectedSum = "80"
        
        // When
        viewModel.addTransaction()
        
        // Then
        XCTAssertTrue(transactionService.didCallSave)
        XCTAssertTrue(viewModel.showSuccessfulTransactionAlert)
    }
    
    func test_addTransaction() {
        // Given
        let card = ContainerService.createTestCard(context: context)
        cardsViewModel.cards = [card]
        
        XCTAssertEqual(cardsViewModel.cards.count, 1)
        
        viewModel.selectedCategory = "Продукты"
        viewModel.selectedSum = "50"
        viewModel.selectedCard = "1234 5678 9123 4567"
        
        XCTAssertFalse(viewModel.showFillAllFieldsAlert)
        XCTAssertFalse(viewModel.showNotEnoughtCreditsAlert)
        
        // When
        viewModel.addTransaction()
        
        // Then
        XCTAssertTrue(transactionService.didCallSave)
        XCTAssertTrue(viewModel.showSuccessfulTransactionAlert)
        XCTAssertEqual(transactionService.transactions.count, 1)
    }
    
    func test_deleteTransaction() {
        // Given
        let transaction = transactionService.addTransaction()
        
        XCTAssertEqual(transactionService.transactions.count, 1)
        
        // When
        viewModel.deleteTransaction(transaction: transaction)
        
        // Then
        XCTAssertTrue(transactionService.didCallDelete)
        XCTAssertEqual(transactionService.transactions.count, 0)
    }
    
    func test_onDisappear() {
        // Given
        viewModel.selectedCategory = "Продукты"
        
        XCTAssertFalse(viewModel.selectedCategory?.isEmpty ?? false)
        
        // When
        viewModel.onDisappear()
        
        // Then
        XCTAssertEqual(viewModel.selectedCategory, "Выберите категорию")
    }
}
