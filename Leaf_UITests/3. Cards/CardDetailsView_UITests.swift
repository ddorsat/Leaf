//
//  CardDetailsView_UITests.swift
//  Leaf_UITests
//
//  Created by ddorsat on 07.08.2025.
//

import XCTest

final class CardDetailsView_UITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    func test_expenseView_toggle() {
        // Given
        let cardsView = app.images["creditcard.fill"]
        let cardsTitle = app.staticTexts["Карты"]
        let cardDetails = app.buttons["card_0"]
        let cardDetailsTitle = app.staticTexts["История операций"]
        let expenseView = app.images["expenseViewSheet"]
        let expenseViewTitle = app.staticTexts["Потратить"]
        let categoryPicker = app.staticTexts["categoryPicker"]
        let categoryOption = app.staticTexts["Продукты"].firstMatch
        let cardPicker = app.staticTexts["cardPicker"]
        let cardOption = app.staticTexts["cardPicker"].firstMatch
        let sumTextField = app.textFields["sumTextField"]
        let doneButton = app.buttons["doneButton"]
        let successAlert = app.staticTexts["Успешная транзакция"]
        
        // When
        cardsView.tap()
        
        // Then
        XCTAssertTrue(cardsTitle.waitForExistence(timeout: 2))
        
        // And
        cardDetails.tap()
        
        // Then
        XCTAssertTrue(cardDetailsTitle.waitForExistence(timeout: 2))
        
        // And
        expenseView.tap()
        
        // Then
        XCTAssertTrue(expenseViewTitle.waitForExistence(timeout: 2))
        
        // And
        categoryPicker.tap()
        categoryOption.tap()
        cardPicker.tap()
        cardOption.tap()
        sumTextField.tap()
        sumTextField.typeText("50")
        doneButton.tap()
        
        // Then
        XCTAssertTrue(successAlert.waitForExistence(timeout: 2))
        XCTAssertTrue(cardDetailsTitle.waitForExistence(timeout: 2))
    }
    
    func test_topUpView_toggle() {
        // Given
        let cardsView = app.images["creditcard.fill"]
        let cardsTitle = app.staticTexts["Карты"]
        let cardDetails = app.buttons["card_0"]
        let cardDetailsTitle = app.staticTexts["История операций"]
        let topUpView = app.images["topUpViewSheet"]
        let topUpViewTitle = app.staticTexts["Пополнить"]
        let cardPicker = app.staticTexts["cardPicker"]
        let cardOption = app.staticTexts["cardPicker"].firstMatch
        let sumTextField = app.textFields["sumTextField"]
        let doneButton = app.buttons["doneButton"]
        let successAlert = app.staticTexts["Успешное пополнение"].firstMatch
        
        // When
        cardsView.tap()
        
        // Then
        XCTAssertTrue(cardsTitle.waitForExistence(timeout: 2))
        
        // And
        cardDetails.tap()
        
        // Then
        XCTAssertTrue(cardDetailsTitle.waitForExistence(timeout: 2))
        
        // And
        topUpView.tap()
        
        // Then
        XCTAssertTrue(topUpViewTitle.waitForExistence(timeout: 2))
        
        // And
        cardPicker.tap()
        cardOption.tap()
        sumTextField.tap()
        sumTextField.typeText("50")
        doneButton.tap()
        
        // Then
        XCTAssertTrue(successAlert.waitForExistence(timeout: 2))
        XCTAssertTrue(cardDetailsTitle.waitForExistence(timeout: 2))
    }
    
    func test_transactionDetails() {
        // Given
        let cardsView = app.images["creditcard.fill"]
        let cardsTitle = app.staticTexts["Карты"]
        let cardDetails = app.buttons["card_0"]
        let cardDetailsTitle = app.staticTexts["История операций"]
        let transactionDetails = app.buttons["transaction_0"]
        let transactionDetailsTitle = app.staticTexts["Детали транзакции"]
        let ellipsis = app.images["ellipsis"]
        let deleteButton = app.buttons["Удалить"]
        let confirmDelete = app.buttons["Удалить"]
        
        // When
        cardsView.tap()
        
        // Then
        XCTAssertTrue(cardsTitle.waitForExistence(timeout: 2))
        
        // And
        cardDetails.tap()
        
        // Then
        XCTAssertTrue(cardDetailsTitle.waitForExistence(timeout: 2))
        
        // And
        transactionDetails.tap()
        
        // Then
        XCTAssertTrue(transactionDetailsTitle.waitForExistence(timeout: 2))
        
        // And
        ellipsis.tap()
        deleteButton.tap()
        confirmDelete.tap()
        
        // Then
        XCTAssertTrue(cardDetailsTitle.waitForExistence(timeout: 2))
    }
    
    func test_cardDelete() {
        // Given
        let cardsView = app.images["creditcard.fill"]
        let cardsTitle = app.staticTexts["Карты"]
        let cardDetails = app.buttons["card_1"]
        let cardDetailsTitle = app.staticTexts["История операций"]
        let ellipsis = app.images["ellipsis"]
        let deleteButton = app.buttons["Удалить"]
        let confirmDelete = app.buttons["Удалить"]
        
        // When
        cardsView.tap()
        
        // Then
        XCTAssertTrue(cardsTitle.waitForExistence(timeout: 2))
        
        // And
        cardDetails.tap()
        
        // Then
        XCTAssertTrue(cardDetailsTitle.waitForExistence(timeout: 2))
        
        // And
        ellipsis.tap()
        deleteButton.tap()
        confirmDelete.tap()
        
        // Then
        XCTAssertTrue(cardsTitle.waitForExistence(timeout: 2))
    }
}
