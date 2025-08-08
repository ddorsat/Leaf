//
//  CardsViewModel_Tests.swift
//  Leaf_Tests
//
//  Created by ddorsat on 07.08.2025.
//

import XCTest
import CoreData
import SwiftUI
@testable import Leaf

final class CardsViewModel_UnitTests: XCTestCase {
    var context: NSManagedObjectContext!
    
    var cardService: MockCardService!
    var transactionService: MockTransactionService!
    var cardDetailsViewModel: CardDetailsViewModel!
    
    var viewModel: CardsViewModel!

    override func setUpWithError() throws {
        context = ContainerService.makeInMemoryContext()
        
        cardService = MockCardService(context: context)
        transactionService = MockTransactionService(context: context)
        cardDetailsViewModel = CardDetailsViewModel(cardService: cardService, transactionService: transactionService)
        
        viewModel = CardsViewModel(cardService: cardService, cardDetailsViewModel: cardDetailsViewModel)
    }

    override func tearDownWithError() throws {
        context = nil
        cardService = nil
        transactionService = nil
        cardDetailsViewModel = nil
        viewModel = nil
    }
    
    func test_showInvalidCard() {
        // Given
        viewModel.name = ""
        viewModel.number = ""
        viewModel.date = ""
        viewModel.balance = ""
        
        // When
        viewModel.addCard()
        
        // Then
        XCTAssertFalse(cardService.didCallSave)
        XCTAssertTrue(viewModel.showInvalidCard)
    }
    
    func test_showValidCard() {
        // Given
        viewModel.name = "DMITRY"
        viewModel.number = "5555555555555555555"
        viewModel.date = "05/28"
        viewModel.balance = "150"
        
        XCTAssertTrue(!viewModel.name.isEmpty)
        XCTAssertTrue(!viewModel.number.isEmpty)
        XCTAssertTrue(viewModel.number.count == 19)
        XCTAssertTrue(!viewModel.name.isEmpty)
        
        // When
        viewModel.addCard()
        
        // Then
        XCTAssertTrue(cardService.didCallSave)
        XCTAssertTrue(viewModel.showValidCard)
    }
    
    func test_fetchCards() {
        // Given
        let card1 = ContainerService.createTestCard(context: context)
        let card2 = ContainerService.createTestCard(context: context)
        cardService.cards = [card1, card2]
        
        XCTAssertEqual(viewModel.cards.count, 0)
        
        // When
        viewModel.fetchCards()
        
        // Then
        XCTAssertEqual(viewModel.cards.count, 2)
    }
    
    func test_addCard() {
        // Given
        viewModel.name = "Test Card"
        viewModel.number = "1234 5678 9012 3456"
        viewModel.date = "12/25"
        viewModel.balance = "100"
        viewModel.color = .blue
        viewModel.type = .visa
        
        XCTAssertEqual(cardService.cards.count, 0)
        XCTAssertFalse(cardService.didCallSave)
        
        // When
        viewModel.addCard()
        
        // Then
        XCTAssertTrue(viewModel.showValidCard)
        XCTAssertFalse(viewModel.showInvalidCard)
        XCTAssertTrue(cardService.didCallSave)
        XCTAssertEqual(cardService.cards.count, 1)
    }
    
    func test_deleteCard() {
        // Given
        let card = Card(context: context)
        viewModel.cardToDelete = card
        
        XCTAssertFalse(cardService.didCallDeleteCard)
        XCTAssertFalse(cardService.didCallSave)
        XCTAssertTrue(viewModel.cardToDelete != nil)
        
        // When
        viewModel.deleteCard()
        viewModel.cardToDelete = nil
        
        // Then
        XCTAssertTrue(cardService.didCallDeleteCard)
        XCTAssertTrue(cardService.didCallSave)
        XCTAssertTrue(viewModel.cardToDelete == nil)
    }
    
    func test_handleEllipsis() {
        // Given
        let card = ContainerService.createTestCard(context: context)
        viewModel.cardToDelete = card
        
        XCTAssertFalse(viewModel.showEllipsis)
        
        // When
        viewModel.handleEllipsis(card: card)
        
        // Then
        XCTAssertTrue(viewModel.showEllipsis)
    }
    
    func test_onDisappear() {
        // Given
        viewModel.name = "DMITRY"
        viewModel.number = "1234 5678 9123 4567"
        viewModel.date = "05/29"
        viewModel.color = .gray
        viewModel.type = .visa
        viewModel.balance = "552"
        
        // When
        viewModel.onDisappear()
        
        // Then
        XCTAssertEqual(viewModel.name, "")
        XCTAssertEqual(viewModel.number, "")
        XCTAssertEqual(viewModel.date, "")
        XCTAssertEqual(viewModel.color, .gray)
        XCTAssertEqual(viewModel.type, .visa)
        XCTAssertEqual(viewModel.balance, "")
    }
}
