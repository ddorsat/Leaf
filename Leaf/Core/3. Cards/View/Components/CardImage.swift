//
//  CardsCell.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import SwiftUI
import CoreData

struct CardImage: View {
    let card: Card
    let onTapHandler: (() -> Void)?
    
    init(card: Card, onTapHandler: (() -> Void)? = nil) {
        self.card = card
        self.onTapHandler = onTapHandler
    }
    
    var body: some View {
        Button {
            onTapHandler?()
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text(card.name ?? "DMITRY")
                
                Text("**** \(card.number?.suffix(4) ?? "1111")")
            }
            .font(.footnote)
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.leading, 4)
            .padding(4)
            .background {
                if let data = card.color,
                   let color = UIColor.color(data: data) {
                    LinearGradient(colors: [Color(uiColor: color).opacity(0.25),
                                            Color(uiColor: color).opacity(0.8)],
                                   startPoint: .topLeading,
                                   endPoint: .bottom)
                }
            }
            .frame(width: UIScreen.main.bounds.width / 4,
                   height: UIScreen.main.bounds.height / 14)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

#Preview {
    let service = ContainerService()
    CardImage(card: Card(context: service.context))
}
