//
//  CardsView.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import SwiftUI

struct CardsView: View {
    @ObservedObject var viewModel: CardsViewModel
    @Binding var selectedCase: CardsViewCases
    let expenseHandler: () -> Void
    let topUpHandler: () -> Void
    
    var body: some View {
        NavigationStack(path: $viewModel.cardRoutes) {
            ScrollView(.vertical, showsIndicators: false) {
                Picker("", selection: $selectedCase) {
                    ForEach(CardsViewCases.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
                .padding(.horizontal, 15)
                .pickerStyle(.segmented)
                
                if selectedCase == .addCard {
                    AddCardView(viewModel: viewModel, isSheet: false) {
                        selectedCase = .myCards
                    }
                } else {
                    MyCardsView(viewModel: viewModel)
                }
            }
            .onAppear {
                viewModel.fetchCards()
            }
            .navigationDestination(for: CardsRoutes.self) { destination in
                destinationView(route: destination)
            }
            .navigationTitle("Карты")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 200) }
        }
    }
}

extension CardsView {
    @ViewBuilder
    private func destinationView(route: CardsRoutes) -> some View {
        switch route {
            case .cardDetails(let card):
                CardDetailsView(viewModel: viewModel.cardDetailsViewModel, card: card) { transaction in
                    viewModel.cardRoutes.append(.transactionDetails(transaction))
                } expenseHandler: {
                    expenseHandler()
                } topUpHandler: {
                    topUpHandler()
                }
            case .transactionDetails(let transaction):
                TransactionDetailsView(viewModel: viewModel.cardDetailsViewModel, transaction: transaction)
        }
    }
}

enum CardsViewCases: String, CaseIterable {
    case addCard = "Добавить карту"
    case myCards = "Мои карты"
}


#Preview {
    let context = ContainerService.shared.context
    let cardService = CardServiceImplementation(context: context)
    let transactionService = TransactionServiceImplementation(context: context)
    
    NavigationStack {
        CardsView(viewModel: CardsViewModel(cardService: cardService, cardDetailsViewModel: CardDetailsViewModel(cardService: cardService, transactionService: transactionService)), selectedCase: .constant(.addCard)) {
            
        } topUpHandler: {
            
        }
    }
}
