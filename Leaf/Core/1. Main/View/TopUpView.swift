//
//  TopUpBalance.swift
//  Leaf
//
//  Created by ddorsat on 27.07.2025.
//

import SwiftUI
import AlertKit

struct TopUpView: View {
    @ObservedObject var viewModel: TopUpViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            backgroundGradient(colors: [.green.opacity(0.2), .green.opacity(0.85)], isSheet: true)
            
            if viewModel.selectedCard != nil {
                cardInformation(balance: viewModel.selectedCardBalance, proMaxPadding: 540, proPadding: 510)
            }
            
            VStack(spacing: 15) {
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
                    viewModel.topUpBalance()
                    
                    guard viewModel.showSuccessfulPopUpAlert else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                } label: {
                    Text("Пополнить")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.top, 20)
                }
                .accessibilityIdentifier("doneButton")
            }
            .onDisappear {
                viewModel.onDisappear()
            }
            .padding(30)
            .alert(isPresent: $viewModel.showSuccessfulPopUpAlert, view: viewModel.successfulTopUpAlert)
            .alert(isPresent: $viewModel.showFillAllFieldsAlert, view: viewModel.fillAllFieldsAlert)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding()
            .shadow(color: Color(.systemGray5), radius: 5)
            .navigationTitle("Пополнить")
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
    let cardService = CardServiceImplementation(context: context)
    let transactionService = TransactionServiceImplementation(context: context)
    TopUpView(viewModel: TopUpViewModel(cardsViewModel: CardsViewModel(cardService: cardService, cardDetailsViewModel: CardDetailsViewModel(cardService: cardService, transactionService: transactionService)), transactionService: transactionService))
}
