//
//  MainView.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import SwiftUI
import AlertKit

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var addCard: CardsViewCases = .addCard
    let loadMoreHandler: () -> Void
    
    var body: some View {
        NavigationStack(path: $viewModel.mainRoutes) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Баланс")
                            .font(.title3)
                            .foregroundStyle(.gray)
                        
                        HStack {
                            if viewModel.hideBalance {
                                Text("*** *** ₽")
                                    .frame(width: UIDevice.isProMax ? 285 : 270, alignment: .leading)
                                    .accessibilityIdentifier("hiddenBalance")
                            } else {
                                Text("\(viewModel.totalBalance)")
                                    .lineLimit(1)
                                    .frame(width: UIDevice.isProMax ? 285 : 270, alignment: .leading)
                                    .minimumScaleFactor(0.7)
                                    .accessibilityIdentifier("visibleBalance")
                            }
                            
                            Button {
                                viewModel.hideBalance.toggle()
                            } label: {
                                Image(systemName: !viewModel.hideBalance ? "eye.slash" : "eye")
                                    .font(.callout)
                                    .foregroundStyle(viewModel.hideBalance ? .gray : Color(.systemGray3))
                            }
                            .accessibilityIdentifier("toggleBalanceVisibility")
                        }
                        .fontWeight(.semibold)
                        .font(.system(size: 45))
                    }
                    .padding(.horizontal, UIDevice.isProMax ? 20 : 15)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 25) {
                            Button {
                                viewModel.showAddCard.toggle()
                            } label: {
                                HStack(spacing: 25) {
                                    Text("Мои карты")
                                        .font(.system(size: UIDevice.isProMax ? 22 : 20))
                                        .foregroundStyle(.black)
                                    
                                    Image(systemName: "plus")
                                        .font(UIDevice.isProMax ? .callout : .footnote)
                                        .foregroundStyle(.white)
                                        .fontWeight(.medium)
                                        .padding(4)
                                        .background(Color(red: 0.12, green: 0.4, blue: 0.11))
                                        .clipShape(Circle())
                                }
                            }
                            .accessibilityIdentifier("addCardButton")
                            
                            HStack(spacing: 10) {
                                ForEach(Array(viewModel.cardsViewModel.cards.enumerated()), id: \.1) { (index, card) in
                                    CardImage(card: card) {
                                        viewModel.mainRoutes.append(.cardDetails(card: card))
                                    }
                                    .accessibilityIdentifier("card_\(index)")
                                }
                            }
                        }
                        .padding(.horizontal, UIDevice.isProMax ? 20 : 15)
                    }
                    .frame(height: UIScreen.main.bounds.height / 14)
                    
                    HStack {
                        FinanceActions(action: .expense) {
                            viewModel.showExpenseView.toggle()
                        }
                        .accessibilityIdentifier("expenseView")
                        
                        Spacer()
                        
                        FinanceActions(action: .topUp) {
                            viewModel.showTopUpView.toggle()
                        }
                        .accessibilityIdentifier("topUpView")
                    }
                    .padding(.horizontal, UIDevice.isProMax ? 20 : 15)
                    
                    VStack(spacing: 20) {
                        Text("История")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .font(.title3)
                        
                        if !viewModel.transactions.isEmpty {
                            VStack(alignment: .leading, spacing: 20) {
                                transactionsView(viewModel: viewModel) { transaction in
                                    viewModel.mainRoutes.append(.transactionDetails(transaction: transaction))
                                }
                            }
                            
                            if viewModel.transactions.count >= 6 {
                                Button {
                                    loadMoreHandler()
                                } label: {
                                    Text("Загрузить еще")
                                        .foregroundStyle(.black)
                                        .fontWeight(.medium)
                                        .padding(.vertical, 13)
                                        .padding(.horizontal, 25)
                                        .background(Color(.systemBackground))
                                        .clipShape(RoundedRectangle(cornerRadius: 30))
                                        .shadow(color: Color(.systemGray5), radius: 10)
                                        .padding(.top, 15)
                                        .frame(maxWidth: .infinity)
                                }
                                .accessibilityIdentifier("loadMoreButton")
                            }
                        } else {
                            emptyView(title: "Транзакций пока нет.", padding: true)
                        }
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .shadow(color: Color(.systemGray6), radius: 6, x: 0, y: -7)
                    .padding(.horizontal, 10)
                }
            }
            .task {
                await viewModel.fetchCards()
            }
            .sheet(isPresented: $viewModel.showAddCard)  {
                NavigationStack {
                    AddCardView(viewModel: viewModel.cardsViewModel, isSheet: true)
                        .navigationTitle("Мои карты")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ButtonComponents.backButton {
                                viewModel.showAddCard = false
                            }
                        }
                        .onDisappear {
                            Task { await viewModel.fetchCards() }
                        }
                        .accessibilityIdentifier("showAddCard")
                }
            }
            .sheet(isPresented: $viewModel.showTopUpView) {
                NavigationStack {
                    TopUpView(viewModel: viewModel.topUpViewModel)
                }
            }
            .sheet(isPresented: $viewModel.showExpenseView) {
                NavigationStack {
                    ExpenseView(viewModel: viewModel.expenseViewModel)
                }
            }
            .navigationDestination(for: MainRoutes.self) { destination in
                destinationView(route: destination)
            }
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 15) }
            .navigationTitle("Главная")
        }
    }
}

extension MainView {
    @ViewBuilder
    private func destinationView(route: MainRoutes) -> some View {
        switch route {
            case .cardDetails(let card):
                CardDetailsView(viewModel: viewModel.cardDetailsViewModel, card: card) { transaction in
                    viewModel.mainRoutes.append(.transactionDetails(transaction: transaction))
                } expenseHandler: {
                    viewModel.showExpenseView.toggle()
                } topUpHandler: {
                    viewModel.showTopUpView.toggle()
                }
            case .transactionDetails(let transaction):
                TransactionDetailsView(viewModel: viewModel, transaction: transaction)
        }
    }
}

#Preview {
    let context = ContainerService.shared.context
    let cardService = CardServiceImplementation(context: context)
    let transactionService = TransactionServiceImplementation(context: context)
    MainView(viewModel: MainViewModel(cardsViewModel: CardsViewModel(cardService: CardServiceImplementation(context: context), cardDetailsViewModel: CardDetailsViewModel(cardService: cardService, transactionService: transactionService)),
                                      cardDetailsViewModel: CardDetailsViewModel(cardService: cardService, transactionService: transactionService),
                                      expenseViewModel: ExpenseViewModel(cardsViewModel: CardsViewModel(cardService: cardService, cardDetailsViewModel: CardDetailsViewModel(cardService: cardService, transactionService: transactionService)), transactionService: transactionService),
                                      topUpViewModel: TopUpViewModel(cardsViewModel: CardsViewModel(cardService: cardService, cardDetailsViewModel: CardDetailsViewModel(cardService: cardService, transactionService: transactionService)), transactionService: transactionService),
                                      transactionService: TransactionServiceImplementation(context: context)))  {
    }
}

