//
//  MainView_UITests.swift
//  Leaf_UITests
//
//  Created by ddorsat on 07.08.2025.
//

import XCTest
@testable import Leaf

final class MainView_UITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    func test_toggleBalanceVisibility() {
        // Given
        let visible = app.staticTexts["visibleBalance"]
        let hidden = app.staticTexts["hiddenBalance"]
        let toggle = app.buttons["toggleBalanceVisibility"]
        
        // When
        toggle.tap()
        
        // Then
        XCTAssertTrue(hidden.waitForExistence(timeout: 2))
        
        // When
        toggle.tap()
        
        // Then
        XCTAssertTrue(visible.waitForExistence(timeout: 2))
    }
    
    func test_addCardButton() {
        // Given
        let addButton = app.buttons["addCardButton"]
        let addButtonSheet = app.images["plus"]
        let backButton = app.buttons["chevron.left"]
        let mainView = app.staticTexts["Главная"]

        // When
        addButton.tap()
        
        // Then
        XCTAssertTrue(addButtonSheet.waitForExistence(timeout: 2))
        
        // When
        backButton.tap()
        
        // Then
        XCTAssertTrue(mainView.waitForExistence(timeout: 2))
    }
    
    func test_navigateToCardDetails() {
        // Given
        let cardDetails = app.buttons["card_0"]
        let cardTitle = app.staticTexts["История операций"]
        let backButton = app.buttons["BackButton"]
        let mainView = app.staticTexts["Главная"]

        // When
        cardDetails.tap()
        
        // Then
        XCTAssertTrue(cardTitle.waitForExistence(timeout: 2))
        
        // And
        backButton.tap()
        
        // Then
        XCTAssertTrue(mainView.waitForExistence(timeout: 2))
    }
    
    func test_expenseView_toggle() {
        // Given
        let expenseView = app.staticTexts["expenseView"]
        let backButton = app.buttons["chevron.left"]
        let mainView = app.staticTexts["Главная"]

        // When
        expenseView.tap()
        
        // Then
        XCTAssertTrue(expenseView.waitForExistence(timeout: 2))
        
        // And
        XCTAssertTrue(backButton.waitForExistence(timeout: 2))
        backButton.tap()
        
        // Then
        XCTAssertTrue(mainView.waitForExistence(timeout: 2))
    }
    
    func test_topUpView_toggle() {
        // Given
        let topUpView = app.staticTexts["topUpView"]
        let backButton = app.buttons["chevron.left"]
        let mainView = app.staticTexts["Главная"]

        // When
        topUpView.tap()
        
        // Then
        XCTAssertTrue(topUpView.waitForExistence(timeout: 2))
        
        // And
        XCTAssertTrue(backButton.waitForExistence(timeout: 2))
        backButton.tap()
        
        // Then
        XCTAssertTrue(mainView.waitForExistence(timeout: 2))
    }
    
    func test_transactionDetailsView() {
        // Given
        let scroll = app.scrollViews.containing(.staticText, identifier: "Баланс").firstMatch
        let transactionDetails = app.buttons["transaction_0"]
        let transactionTitle = app.staticTexts["Детали транзакции"]
        let backButton = app.buttons["BackButton"]
        let mainView = app.staticTexts["Главная"]

        // When
        scroll.swipeUp()
        
        // Then
        XCTAssertTrue(transactionDetails.waitForExistence(timeout: 2))
                
        // And
        transactionDetails.tap()
        
        // Then
        XCTAssertTrue(transactionTitle.waitForExistence(timeout: 2))
        
        // And
        backButton.tap()
        
        // Then
        XCTAssertTrue(mainView.waitForExistence(timeout: 2))
    }
    
    func test_transactionDetailsViewAndDelete() {
        // Given
        let scroll = app.scrollViews.containing(.staticText, identifier: "Баланс").firstMatch
        let transactionDetails = app.buttons["transaction_0"]
        let transactionTitle = app.staticTexts["Детали транзакции"]
        let mainTitle = app.staticTexts["Главная"]
        let ellipsisButton = app.buttons["More"]
        let deleteButton = app.buttons["Удалить"]
        let confirmDelete = app.buttons["Удалить"]

        // When
        scroll.swipeUp()
        
        // Then
        XCTAssertTrue(transactionDetails.waitForExistence(timeout: 2))
                
        // And
        transactionDetails.tap()
        
        // Then
        XCTAssertTrue(transactionTitle.waitForExistence(timeout: 2))
        
        // And
        ellipsisButton.tap()
        deleteButton.tap()
        confirmDelete.tap()
        
        // Then
        XCTAssertTrue(mainTitle.waitForExistence(timeout: 2))
    }
    
    func test_loadMoreButton() {
        // Given
        let scroll = app.scrollViews.containing(.staticText, identifier: "Баланс").firstMatch
        let button = app.buttons["loadMoreButton"]
        let historyTitle = app.staticTexts["История"]
        
        // When
        scroll.swipeUp()
        button.tap()
        
        // Then
        XCTAssertTrue(historyTitle.waitForExistence(timeout: 2))
    }
}
