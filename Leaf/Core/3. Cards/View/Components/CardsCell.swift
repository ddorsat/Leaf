//
//  MyCardsCell.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import SwiftUI
import CoreData

struct CardsCell: View {
    @ObservedObject var viewModel: CardsViewModel
    let card: Card
    let onTapHandler: () -> Void
    
    var body: some View {
        Button {
            viewModel.cardRoutes.append(.cardDetails(card))
        } label: {
            VStack {
                HStack(spacing: 10) {
                    CardImage(card: card)
                    
                    VStack(alignment: .leading, spacing: 23) {
                        Text(card.type ?? "VISA")
                            .fontWeight(.medium)
                        
                        Text(card.date ?? "01/29")
                            .foregroundStyle(Color(.systemGray2))
                            .fontWeight(.medium)
                            .font(.footnote)
                    }
                    .layoutPriority(2)
                    
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .opacity(0.001)
                        .layoutPriority(0)
                    
                    VStack(alignment: .trailing) {
                        Menu {
                            Button("История транзакций", role: .confirm) {
                                viewModel.cardRoutes.append(.cardDetails(card))
                            }
                            
                            Button("Удалить карту", role: .destructive) {
                                viewModel.handleEllipsis(card: card)
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.black)
                                .fontWeight(.medium)
                                .imageScale(.large)
                        }
                        .accessibilityIdentifier("ellipsis")

                        Spacer()
                        
                        Text(Formatters.sumFormatter(sum: card.balance))
                            .font(.system(size: 23))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .layoutPriority(1)
                }
                
                Divider()
            }
            .tint(.black)
        }
    }
}

#Preview {
    let context = ContainerService.shared.context
    let cardService = CardServiceImplementation(context: context)
    let transactionService = TransactionServiceImplementation(context: context)
    
    CardsCell(viewModel: CardsViewModel(cardService: cardService, cardDetailsViewModel: CardDetailsViewModel(cardService: cardService, transactionService: transactionService)), card: Card(context: context)) {
        
    }
}
