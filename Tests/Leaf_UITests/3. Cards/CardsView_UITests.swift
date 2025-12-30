//
//  CardsView_UITests.swift
//  Leaf_UITests
//
//  Created by ddorsat on 07.08.2025.
//

import XCTest

final class CardsView_UITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    func test_addCardView() {
        // Given
        let cardsView = app.images["creditcard.fill"]
        let cardsTitle = app.staticTexts["Карты"]
        let addCardsButton = app.buttons["Добавить карту"]
        let imageView = app.staticTexts["imageView"]
        
        // When
        cardsView.tap()
        
        // Then
        XCTAssertTrue(cardsTitle.waitForExistence(timeout: 2))
        
        // When
        addCardsButton.tap()
        
        // Then
        XCTAssertTrue(imageView.waitForExistence(timeout: 2))
    }
    
    func test_myCardsView() {
        // Given
        let cardsView = app.images["creditcard.fill"]
        let cardsTitle = app.staticTexts["Карты"]
        let addCardsButton = app.buttons["Добавить карту"]
        let myCardsButton = app.buttons["Мои карты"]
        let imageView = app.staticTexts["imageView"]
        
        // When
        cardsView.tap()
        
        // Then
        XCTAssertTrue(cardsTitle.waitForExistence(timeout: 2))
        
        // And
        addCardsButton.tap()
        
        // Then
        XCTAssertTrue(imageView.waitForExistence(timeout: 2))
        
        // And
        myCardsButton.tap()
        
        // Then
        XCTAssertTrue(cardsTitle.waitForExistence(timeout: 2))
    }
    
    func test_cardTransactionHistory() {
        // Given
        let cardsView = app.images["creditcard.fill"]
        let cardsTitle = app.staticTexts["Карты"]
        let cardEllipsis = app.buttons["card_0"].buttons["ellipsis"]
        let transactionHistory = app.buttons["История транзакций"]
        let transactionsTitle = app.staticTexts["История операций"]
        let backButton = app.buttons["BackButton"]
        
        // When
        cardsView.tap()
        
        // Then
        XCTAssertTrue(cardsTitle.waitForExistence(timeout: 2))
        
        // And
        cardEllipsis.tap()
        transactionHistory.tap()
        
        // Then
        XCTAssertTrue(transactionsTitle.waitForExistence(timeout: 2))
        
        // And
        backButton.tap()
        
        // Then
        XCTAssertTrue(cardsTitle.waitForExistence(timeout: 2))
    }
    
    func test_cardDelete() {
        // Given
        let cardsView = app.images["creditcard.fill"]
        let cardsTitle = app.staticTexts["Карты"]
        let cardEllipsis = app.buttons["card_0"].buttons["ellipsis"]
        let deleteCard = app.buttons["Удалить карту"]
        let confirmDelete = app.buttons["Удалить"]
        
        // When
        cardsView.tap()
        
        // Then
        XCTAssertTrue(cardsTitle.waitForExistence(timeout: 2))
        
        // And
        cardEllipsis.tap()
        deleteCard.tap()
        confirmDelete.tap()
        
        // Then
        XCTAssertFalse(confirmDelete.waitForExistence(timeout: 2))
    }
}
