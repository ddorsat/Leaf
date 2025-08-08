//
//  FinanceActionCell.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import SwiftUI

struct FinanceActions: View {
    var action: FinanceActionTypes
    let onTapHandler: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: action.icon)
                .foregroundStyle(action.foregroundColor)
                .font(.system(size: UIDevice.isProMax ? 22 : 20))
            
            Text(action.rawValue)
                .font(.system(size: UIDevice.isProMax ? 20 : 18))
                .foregroundStyle(action.foregroundColor)
                .fontWeight(.medium)
        }
        .padding(.vertical, 17)
        .padding(.horizontal, 25)
        .background(action.backgroundColor)
        .clipShape(Capsule())
        .onTapGesture {
            onTapHandler()
        }
    }
}

enum FinanceActionTypes: String, CaseIterable {
    case expense = "Потратить"
    case topUp = "Пополнить"
    
    var transactionTitle: String {
        switch self {
            case .topUp:
                return "Пополнение"
            case .expense:
                return "Трата"
        }
    }
    
    var foregroundColor: Color {
        switch self {
            case .topUp:
                return Color(red: 0.12, green: 0.4, blue: 0.11)
            case .expense:
                return .white
        }
    }
    
    var icon: String {
        switch self {
            case .topUp:
                return "arrow.uturn.left.circle"
            case .expense:
                return "arrow.down.left.circle"
        }
    }
    
    var backgroundColor: Color {
        switch self {
            case .topUp:
                return Color(red: 0.85, green: 0.95, blue: 0.71)
            case .expense:
                return Color(red: 0.12, green: 0.4, blue: 0.11)
        }
    }
}

#Preview {
    HStack {
        FinanceActions(action: .topUp) {
            
        }
        
        FinanceActions(action: .expense) {
            
        }
    }
}
