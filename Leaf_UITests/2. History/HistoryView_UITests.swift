//
//  HistoryView_UITests.swift
//  Leaf_UITests
//
//  Created by ddorsat on 07.08.2025.
//

import XCTest

final class HistoryView_UITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    func test_transactionDetailsView() {
        // Given
        let historyTab = app.images["list.bullet.rectangle.fill"]
        let historyTitle = app.staticTexts["История"]
        let scroll = app.scrollViews.firstMatch
        let transactionDetails = app.buttons["transaction_0"]
        let transactionDetailsTitle = app.staticTexts["Детали транзакции"]
        let backButton = app.buttons["BackButton"]
        
        // When
        historyTab.tap()
        
        // Then
        XCTAssertTrue(historyTitle.waitForExistence(timeout: 2))
        
        // And
        scroll.swipeUp()
        transactionDetails.tap()
        
        // Then
        XCTAssertTrue(transactionDetailsTitle.waitForExistence(timeout: 2))
        
        // And
        backButton.tap()
        
        // Then
        XCTAssertTrue(historyTitle.waitForExistence(timeout: 2))
    }
    
    func test_transactionDetailsViewAndDelete() {
        // Given
        let historyTab = app.images["list.bullet.rectangle.fill"]
        let historyTitle = app.staticTexts["История"]
        let scroll = app.scrollViews.firstMatch
        let transactionDetails = app.buttons["transaction_3"]
        let transactionDetailsTitle = app.staticTexts["Детали транзакции"]
        let ellipsisButton = app.buttons["More"]
        let deleteButton = app.buttons["Удалить"]
        let confirmDelete = app.buttons["Удалить"]
        
        // When
        historyTab.tap()
        
        // Then
        XCTAssertTrue(historyTitle.waitForExistence(timeout: 2))
        
        // And
        scroll.swipeUp()
        transactionDetails.tap()
        
        // Then
        XCTAssertTrue(transactionDetailsTitle.waitForExistence(timeout: 2))
        
        // And
        ellipsisButton.tap()
        deleteButton.tap()
        confirmDelete.tap()
        
        // Then
        XCTAssertTrue(historyTitle.waitForExistence(timeout: 2))
    }
}
