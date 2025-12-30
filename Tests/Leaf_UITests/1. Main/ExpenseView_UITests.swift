//
//  ExpenseView_UITests.swift
//  Leaf_UITests
//
//  Created by ddorsat on 07.08.2025.
//

import XCTest
import CoreData
@testable import Leaf
@testable import Leaf_UnitTests

final class ExpenseView_UITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }

    func test_showSuccessfulExpenseAlert() {
        // Given
        let expenseView = app.staticTexts["expenseView"]
        let categoryPicker = app.staticTexts["categoryPicker"]
        let categoryOption = app.staticTexts["Продукты"].firstMatch
        let cardPicker = app.staticTexts["cardPicker"]
        let cardOption = app.staticTexts["cardPicker"].firstMatch
        let sumTextField = app.textFields["sumTextField"]
        let doneButton = app.buttons["doneButton"]
        let successAlert = app.staticTexts["Успешная транзакция"]
        
        // When
        expenseView.tap()
        categoryPicker.tap()
        categoryOption.tap()
        cardPicker.tap()
        cardOption.tap()
        sumTextField.tap()
        sumTextField.typeText("50")
        doneButton.tap()
        
        // Then
        XCTAssertTrue(successAlert.waitForExistence(timeout: 2))
    }
    
    func test_showNotEnoughtCreditsAlert() {
        // Given
        let expenseView = app.staticTexts["expenseView"]
        let categoryPicker = app.staticTexts["categoryPicker"]
        let categoryOption = app.staticTexts["Продукты"].firstMatch
        let cardPicker = app.staticTexts["cardPicker"]
        let cardOption = app.staticTexts["cardPicker"].firstMatch
        let sumTextField = app.textFields["sumTextField"]
        let doneButton = app.buttons["doneButton"]
        let notEnoughCreditsAlert = app.staticTexts["Недостаточно средств"]
        
        // When
        expenseView.tap()
        categoryPicker.tap()
        categoryOption.tap()
        cardPicker.tap()
        cardOption.tap()
        sumTextField.tap()
        sumTextField.typeText("100000")
        doneButton.tap()
        
        // Then
        XCTAssertTrue(notEnoughCreditsAlert.waitForExistence(timeout: 2))
    }
    
    func test_showFillAllFieldsAlert() {
        // Given
        let expenseView = app.staticTexts["expenseView"]
        let categoryPicker = app.staticTexts["categoryPicker"]
        let categoryOption = app.staticTexts["Продукты"].firstMatch
        let cardPicker = app.staticTexts["cardPicker"]
        let cardOption = app.staticTexts["cardPicker"].firstMatch
        let doneButton = app.buttons["doneButton"]
        let fillAllFieldsAlert = app.staticTexts["Заполните все поля"]
        
        // When
        expenseView.tap()
        categoryPicker.tap()
        categoryOption.tap()
        cardPicker.tap()
        cardOption.tap()
        doneButton.tap()
        
        // Then
        XCTAssertTrue(fillAllFieldsAlert.waitForExistence(timeout: 2))
    }
}
