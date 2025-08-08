//
//  SpendView.swift
//  Leaf
//
//  Created by ddorsat on 27.07.2025.
//

import SwiftUI
import AlertKit

struct ExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            backgroundGradient(colors: [.green.opacity(0.2), .green.opacity(0.85)], isSheet: true)
            
            if viewModel.selectedCard != nil {
                cardInformation(balance: viewModel.selectedCardBalance, proMaxPadding: 540, proPadding: 510)
            }
            
            VStack(spacing: 15) {
                DropDownPicker(title: "Выберите категорию",
                               options: viewModel.categories,
                               selection: $viewModel.selectedCategory)
                    .zIndex(2)
                    .accessibilityIdentifier("categoryPicker")
                
                DropDownPicker(title: "Выберите карту",
                               options: viewModel.allCards,
                               selection: $viewModel.selectedCard)
                    .zIndex(1)
                    .accessibilityIdentifier("cardPicker")
                
                
                TextField("Сумма", text: $viewModel.selectedSum)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding(.horizontal, 15)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .clipped()
                    .shadow(color: Color(.systemGray4), radius: 3)
                    .overlay(alignment: .trailing) {
                        Button {
                            viewModel.selectedSum = ""
                        } label: {
                            Image(systemName: "xmark")
                                .padding(.trailing, 18)
                                .foregroundStyle(.gray)
                                .fontWeight(.medium)
                                .opacity(viewModel.selectedSum.isEmpty ? 0 : 1)
                        }
                    }
                    .accessibilityIdentifier("sumTextField")
                
                Button {
                    viewModel.addTransaction()
                    
                    guard viewModel.showSuccessfulTransactionAlert else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                } label: {
                    Text("Готово")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.top, 20)
                        .zIndex(0)
                }
                .accessibilityIdentifier("doneButton")
            }
            .padding(30)
            .onDisappear {
                viewModel.onDisappear()
            }
            .alert(isPresent: $viewModel.showNotEnoughtCreditsAlert, view: viewModel.notEnoughCreditsAlert)
            .alert(isPresent: $viewModel.showSuccessfulTransactionAlert, view: viewModel.successfulTransactionAlert)
            .alert(isPresent: $viewModel.showFillAllFieldsAlert, view: viewModel.fillAllFieldsAlert)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding()
            .shadow(color: Color(.systemGray5), radius: 5)
            .navigationTitle("Потратить")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ButtonComponents.backButton {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    let context = ContainerService.shared.context
    let transactionService = TransactionServiceImplementation(context: context)
    let cardService = CardServiceImplementation(context: context)
    
    NavigationStack {
        ExpenseView(viewModel: ExpenseViewModel(cardsViewModel: CardsViewModel(cardService: CardServiceImplementation(), cardDetailsViewModel: CardDetailsViewModel(cardService: cardService, transactionService: transactionService)), transactionService: transactionService))
    }
}
