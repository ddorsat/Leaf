//
//  MockCardsViewModel.swift
//  Leaf_Tests
//
//  Created by ddorsat on 06.08.2025.
//

import Foundation
import CoreData
@testable import Leaf

@MainActor
final class MockCardsViewModel: CardsViewModel {
    var fetchCardsCount = 0
    
    override func fetchCards() {
        fetchCardsCount += 1
    }
}
