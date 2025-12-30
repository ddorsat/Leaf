//
//  AddCardView_UITests.swift
//  Leaf_UITests
//
//  Created by ddorsat on 07.08.2025.
//

import XCTest

final class AddCardView_UITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    func test_SuccessfullyAddCard() {
        // Given
        let cardsView = app.images["creditcard.fill"]
        let cardsTitle = app.staticTexts["Карты"]
        let addCardButton = app.buttons["Добавить карту"]
        let imageView = app.staticTexts["imageView"]
        let cardName = app.textFields["cardName"]
        let cardNumber = app.textFields["cardNumber"]
        let cardBalance = app.textFields["cardBalance"]
        let cardDate = app.textFields["cardDate"]
        let cardType = app.buttons["MASTERCARD"]
        let addButton = app.buttons["addButton"]
        let successAlert = app.staticTexts["Карта добавлена"]
        
        // When
        cardsView.tap()
        
        // Then
        XCTAssertTrue(cardsTitle.waitForExistence(timeout: 2))
        
        // And
        addCardButton.tap()
        
        // Then
        XCTAssertTrue(imageView.waitForExistence(timeout: 2))
        
        // And
        cardName.tap()
        cardName.typeText("TEST")
        cardNumber.tap()
        cardNumber.typeText("1234 5678 9123 4567")
        cardBalance.tap()
        cardBalance.typeText("25000")
        cardDate.tap()
        cardDate.typeText("0526")
        cardType.tap()
        addButton.tap()
        
        // Then
        XCTAssertTrue(successAlert.waitForExistence(timeout: 2))
    }
    
    func test_fillAllFields() {
        // Given
        let cardsView = app.images["creditcard.fill"]
        let cardsTitle = app.staticTexts["Карты"]
        let addCardButton = app.buttons["Добавить карту"]
        let imageView = app.staticTexts["imageView"]
        let cardName = app.textFields["cardName"]
        let cardNumber = app.textFields["cardNumber"]
        let cardBalance = app.textFields["cardBalance"]
        let cardType = app.buttons["MASTERCARD"]
        let addButton = app.buttons["addButton"]
        let fillAllFieldsAlert = app.staticTexts["Заполните все поля"]
        
        // When
        cardsView.tap()
        
        // Then
        XCTAssertTrue(cardsTitle.waitForExistence(timeout: 2))
        
        // And
        addCardButton.tap()
        
        // Then
        XCTAssertTrue(imageView.waitForExistence(timeout: 2))
        
        // And
        cardName.tap()
        cardName.typeText("TEST")
        cardNumber.tap()
        cardNumber.typeText("1234 5678 9123 4567")
        cardBalance.tap()
        cardBalance.typeText("25000")
        cardType.tap()
        addButton.tap()
        
        // Then
        XCTAssertTrue(fillAllFieldsAlert.waitForExistence(timeout: 2))
    }
}
