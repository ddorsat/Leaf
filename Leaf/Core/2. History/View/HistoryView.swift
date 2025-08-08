//
//  HistoryView.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.historyRoutes) {
            if !viewModel.transactions.isEmpty {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        CircleView(groceriesSum: Int(viewModel.groceriesSum),
                                   bankTransferSum: Int(viewModel.bankTransferSum),
                                   shoppingSum: Int(viewModel.shoppingSum),
                                   othersSum: Int(viewModel.othersSum),
                                   totalBalance: viewModel.totalBalance)
                        .padding(.vertical, 15)
                        
                        HStack {
                            if viewModel.groceriesSum != 0 {
                                historyOperation(title: "Продукты:",
                                                 count: Formatters.sumFormatter(sum: viewModel.groceriesSum),
                                                 color: .red)
                            }
                            
                            if viewModel.bankTransferSum != 0 {
                                historyOperation(title: "Банк. переводы:",
                                                 count: Formatters.sumFormatter(sum: viewModel.bankTransferSum),
                                                 color: .orange)
                            }
                        }
                        
                        HStack(spacing: 20) {
                            if viewModel.shoppingSum != 0 {
                                historyOperation(title: "Шоппинг:",
                                                 count: Formatters.sumFormatter(sum: viewModel.shoppingSum),
                                                 color: .blue)
                            }
                            
                            if viewModel.othersSum != 0 {
                                historyOperation(title: "Другое:",
                                                 count: Formatters.sumFormatter(sum: viewModel.othersSum),
                                                 color: .green)
                            }
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    LazyVStack(alignment: .leading, spacing: 20) {
                        Text("История")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        transactionsView(viewModel: viewModel) { transaction in
                            viewModel.historyRoutes.append(.transactionDetails(transaction))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 50) }
                .navigationDestination(for: HistoryRoutes.self) { destination in
                    destinationView(route: destination)
                }
                .navigationTitle("История")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                emptyView(title: "История пуста", padding: false)
            }
        }
    }
}

extension HistoryView {
    @ViewBuilder
    private func destinationView(route: HistoryRoutes) -> some View {
        switch route {
            case .transactionDetails(let transaction):
                TransactionDetailsView(viewModel: viewModel, transaction: transaction)
        }
    }
}

#Preview {
    let context = ContainerService.shared.context
    let cardService = CardServiceImplementation(context: context)
    let transactionService = TransactionServiceImplementation(context: context)
    
    HistoryView(viewModel: HistoryViewModel(cardsViewModel: CardsViewModel(cardService: cardService, cardDetailsViewModel: CardDetailsViewModel(cardService: cardService, transactionService: transactionService)), transactionService: transactionService))
}
