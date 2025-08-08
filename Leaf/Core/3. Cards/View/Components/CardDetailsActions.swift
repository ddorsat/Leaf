//
//  CardDetailsActions.swift
//  Leaf
//
//  Created by ddorsat on 30.07.2025.
//

import SwiftUI

struct CardDetailsActions: View {
    let type: CardDetailsActionTypes
    let onTapHandler: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: type == .expense ? "arrow.down.left" : "plus")
                .font(.title3)
                .padding(10)
                .overlay {
                    Circle()
                        .stroke(.black, lineWidth: 1)
                }
                .clipShape(Circle())
            
            Text(type.title)
                .font(.callout)
                .fontWeight(.medium)
        }
        .onTapGesture {
            onTapHandler()
        }
    }
}

enum CardDetailsActionTypes {
    case expense
    case topUp
    
    var title: String {
        switch self {
            case .expense:
                return "Потратить"
            case .topUp:
                return "Пополнить"
        }
    }
}

#Preview {
    CardDetailsActions(type: .expense) {
        
    }
}
