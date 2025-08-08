//
//  CardServiceProtocol.swift
//  Leaf
//
//  Created by ddorsat on 05.08.2025.
//

import Foundation

protocol CardServiceProtocol {
    func fetchCards() throws -> [Card]
    func fetchTransactions(_ card: Card) throws -> [CardTransaction]
    func addCard() -> Card
    func deleteCard(_ card: Card)
    func save()
}
