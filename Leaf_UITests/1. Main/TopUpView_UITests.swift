//
//  TopUpView_UITests.swift
//  Leaf_UITests
//
//  Created by ddorsat on 07.08.2025.
//

import XCTest

final class TopUpView_UITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }

    func test_showSuccessfulTopUpAlert() {
        // Given
        let topUpView = app.staticTexts["topUpView"]
        let cardPicker = app.staticTexts["cardPicker"]
        let cardOption = app.staticTexts["cardPicker"].firstMatch
        let sumTextField = app.textFields["sumTextField"]
        let doneButton = app.buttons["doneButton"]
        let successAlert = app.staticTexts["Успешное пополнение"].firstMatch
        
        // When
        topUpView.tap()
        cardPicker.tap()
        cardOption.tap()
        sumTextField.tap()
        sumTextField.typeText("50")
        doneButton.tap()
        
        // Then
        XCTAssertTrue(successAlert.waitForExistence(timeout: 2))
    }
    
    func test_showFillAllFieldsAlert() {
        // Given
        let topUpView = app.staticTexts["topUpView"]
        let cardPicker = app.staticTexts["cardPicker"]
        let cardOption = app.staticTexts["cardPicker"].firstMatch
        let doneButton = app.buttons["doneButton"]
        let fillAllFieldsAlert = app.staticTexts["Заполните все поля"].firstMatch
        
        // When
        topUpView.tap()
        cardPicker.tap()
        cardOption.tap()
        doneButton.tap()
        
        // Then
        XCTAssertTrue(fillAllFieldsAlert.waitForExistence(timeout: 2))
    }
}
