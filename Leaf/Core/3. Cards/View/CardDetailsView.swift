//
//  CardDetailsView.swift
//  Leaf
//
//  Created by ddorsat on 27.07.2025.
//

import SwiftUI
import CoreData

struct CardDetailsView: View {
    @ObservedObject var viewModel: CardDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    let card: Card
    let routeHandler: (CardTransaction) -> Void
    let expenseHandler: () -> Void
    let topUpHandler: () -> Void
    
    var body: some View {
        ZStack {
            backgroundGradient(colors: [.blue.opacity(0.25), .blue.opacity(0.8)], isSheet: false)
            
            ScrollView(.vertical, showsIndicators: false) {
                Spacer(minLength: 250)
                
                LazyVStack(spacing: 15) {
                    VStack(spacing: 10) {
                        Text("Баланс карты")
                            .foregroundStyle(.gray)
                            .font(UIDevice.isProMax ? .title3 : .default)
                        
                        Text(Formatters.sumFormatter(sum: card.balance))
                            .font(UIDevice.isProMax ? .title : .title2)
                            .fontWeight(.medium)
                    }
                    .padding(.top, 35)
                    
                    HStack(spacing: 35) {
                        CardDetailsActions(type: .expense) {
                            expenseHandler()
                        }
                        .accessibilityIdentifier("expenseViewSheet")
                        
                        CardDetailsActions(type: .topUp) {
                            topUpHandler()
                        }
                        .accessibilityIdentifier("topUpViewSheet")
                    }
                    .padding(.vertical, 20)
                    
                    Divider()
                    
                    if viewModel.transactions.isEmpty {
                        emptyView(title: "Операций пока нет.", padding: true)
                    } else {
                        ForEach(Array(viewModel.transactions.enumerated()), id: \.1) { (index, transaction) in
                            TransactionCell(transaction: transaction) {
                                routeHandler(transaction)
                            }
                            .accessibilityIdentifier("transaction_\(index)")
                            
                            Divider()
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 150) }
        }
        .alert("Удалить карту?", isPresented: $viewModel.showEllipsis) {
            Button("Удалить", role: .destructive) {
                viewModel.deleteCard(card)
                dismiss()
            }
            
            Button("Отмена", role: .cancel) {
                dismiss()
            }
        }
        .onAppear {
            viewModel.fetchTransactions(card)
            viewModel.observeTransactions(card)
        }
        .navigationTitle("История операций")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ButtonComponents.ellipsisButton {
                viewModel.showEllipsis.toggle()
            }
        }
    }
}

#Preview {
    let context = ContainerService.shared.context
    let cardService = CardServiceImplementation(context: context)
    let transactionService = TransactionServiceImplementation(context: context)
    CardDetailsView(viewModel: CardDetailsViewModel(cardService: cardService,
                                                    transactionService: transactionService), card: Card(context: context)) { _ in
        
    } expenseHandler: {
        
    } topUpHandler: {
        
    }
}
