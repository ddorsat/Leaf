//
//  TopUpViewModel_Tests.swift
//  Leaf_Tests
//
//  Created by ddorsat on 06.08.2025.
//

import XCTest
import CoreData
@testable import Leaf

final class TopUpViewModel_UnitTests: XCTestCase {
    var context: NSManagedObjectContext!
    
    var transactionService: MockTransactionService!
    var cardService: MockCardService!
    
    var cardDetailsViewModel: CardDetailsViewModel!
    var cardsViewModel: CardsViewModel!
    
    var viewModel: TopUpViewModel!

    override func setUpWithError() throws {
        context = ContainerService.makeInMemoryContext()
        
        transactionService = MockTransactionService(context: context)
        cardService = MockCardService(context: context)
        
        cardDetailsViewModel = CardDetailsViewModel(cardService: cardService, transactionService: transactionService)
        cardsViewModel = CardsViewModel(cardService: cardService, cardDetailsViewModel: cardDetailsViewModel)
        
        viewModel = TopUpViewModel(cardsViewModel: cardsViewModel, transactionService: transactionService)
    }

    override func tearDownWithError() throws {
        context = nil
        transactionService = nil
        cardService = nil
        cardDetailsViewModel = nil
        cardsViewModel = nil
        viewModel = nil
    }
    
    func test_showFillAllFieldsAlert() {
        // Given
        viewModel.selectedCard = nil
        viewModel.selectedSum = "10"
        
        // When
        viewModel.topUpBalance()
        
        // Then
        XCTAssert(viewModel.showFillAllFieldsAlert)
    }
    
    func test_topUpBalance() {
        // Given
        let card = ContainerService.createTestCard(context: context)
        cardsViewModel.cards = [card]
        
        XCTAssertEqual(cardsViewModel.cards.count, 1)
        
        viewModel.selectedCard = "1234 5678 9123 4567"
        viewModel.selectedSum = "50"
        
        XCTAssertEqual(viewModel.selectedCardBalance, Formatters.sumFormatter(sum: 100))
        XCTAssertFalse(viewModel.showFillAllFieldsAlert)
        
        // When
        viewModel.topUpBalance()
        
        // Then
        XCTAssertTrue(transactionService.didCallSave)
        XCTAssertTrue(viewModel.showSuccessfulPopUpAlert)
        XCTAssertEqual(viewModel.selectedCardBalance, Formatters.sumFormatter(sum: 150))
    }
}
