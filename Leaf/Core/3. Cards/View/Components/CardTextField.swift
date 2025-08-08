//
//  CardTextField.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import SwiftUI

struct CardTextField: View {
    let cardCases: CardCases
    @Binding var text: String
    @FocusState private var focused
    
    var body: some View {
        TextField(cardCases.rawValue, text: $text)
            .foregroundStyle(.gray)
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .keyboardType(cardCases == .name ? .default : .numberPad)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(.systemGray4), lineWidth: focused ? 1 : 0)
            }
            .focused($focused)
            .onChange(of: text) { _, newValue in
                if cardCases == .number {
                    onChangeHandler(value: newValue, limit: 16, percentOf: 4, separator: " ")
                }
                
                if cardCases == .date {
                    onChangeHandler(value: newValue, limit: 4, percentOf: 2, separator: "/")
                }
                
                if cardCases == .name {
                    let limit = String(newValue.prefix(10)).uppercased()
                    text = limit
                }
                
                if cardCases == .balance {
                    let digitsOnly = newValue.filter { $0.isNumber }
                    let limit = String(digitsOnly.prefix(7))
                    
                    text = limit
                }
            }
    }
    
    private func onChangeHandler(value: String, limit: Int, percentOf: Int, separator: String) {
        let digitsOnly = value.filter { $0.isNumber }
        let limited = String(digitsOnly.prefix(limit))
        
        var result = ""
        for (index, char) in limited.enumerated() {
            if index > 0 && index % percentOf == 0 {
                result += separator
            }
            result.append(char)
        }
        
        text = result
    }
}

enum CardCases: String {
    case name = "Владелец"
    case number = "Номер карты"
    case date = "Срок действия"
    case balance = "Баланс карты"
}

#Preview {
    CardTextField(cardCases: .date, text: .constant(""))
        .padding(.horizontal)
}
