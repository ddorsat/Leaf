//
//  TransactionServiceProtocol.swift
//  Leaf
//
//  Created by ddorsat on 05.08.2025.
//

import Foundation

protocol TransactionServiceProtocol {
    func fetchTransactions(limit: Int) throws -> [CardTransaction]
    func addTransaction() -> CardTransaction
    func topUpBalance() -> CardTransaction
    func deleteTransaction(_ transaction: CardTransaction)
    func save()
}
