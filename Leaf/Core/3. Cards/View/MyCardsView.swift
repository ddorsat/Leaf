//
//  MyCardsView.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import SwiftUI

struct MyCardsView: View {
    @ObservedObject var viewModel: CardsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 15) {
            if !viewModel.cards.isEmpty {
                ForEach(Array(viewModel.cards.enumerated()), id: \.1) { (index, card) in
                    CardsCell(viewModel: viewModel, card: card) {
                        viewModel.handleEllipsis(card: card)
                    }
                    .accessibilityIdentifier("card_\(index)")
                }
            } else {
                emptyView(title: "Карт пока нет.", padding: true)
            }
        }
        .padding([.top, .horizontal], 15)
        .alert("Удалить карту?", isPresented: $viewModel.showEllipsis) {
            Button("Удалить", role: .destructive) {
                viewModel.deleteCard()
            }
            
            Button("Отмена", role: .cancel) {
                dismiss()
            }
        }
    }
}

#Preview {
    let context = ContainerService.shared.context
    let cardService = CardServiceImplementation(context: context)
    let transactionService = TransactionServiceImplementation(context: context)
    
    MyCardsView(viewModel: CardsViewModel(cardService: cardService, cardDetailsViewModel: CardDetailsViewModel(cardService: cardService, transactionService: transactionService)))
}
