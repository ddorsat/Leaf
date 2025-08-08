//
//  AddCardView.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import SwiftUI
import AlertKit

struct AddCardView: View {
    @ObservedObject var viewModel: CardsViewModel
    @Environment(\.dismiss) private var dismiss
    let isSheet: Bool
    let onTapHandler: (() -> Void)?
    
    init(viewModel: CardsViewModel, isSheet: Bool, onTapHandler: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.isSheet = isSheet
        self.onTapHandler = onTapHandler
    }
    
    var body: some View {
        VStack(spacing: 25) {
            VStack(alignment: .leading, spacing: 20) {
                ImageView(isSheet: isSheet)
                    .accessibilityIdentifier("imageView")
                
                Text("Добавьте вашу карту")
                    .font(.title2)
                    .fontWeight(.medium)
                
                HStack {
                    CardTextField(cardCases: .name, text: $viewModel.name)
                        .accessibilityIdentifier("cardName")
                    
                    CardTextField(cardCases: .number, text: $viewModel.number)
                        .accessibilityIdentifier("cardNumber")
                }
                
                HStack {
                    CardTextField(cardCases: .balance, text: $viewModel.balance)
                        .accessibilityIdentifier("cardBalance")
                    
                    CardTextField(cardCases: .date, text: $viewModel.date)
                        .accessibilityIdentifier("cardDate")
                }
            }
            
            Picker("Выберите карту", selection: $viewModel.type) {
                ForEach(CardTypes.allCases, id: \.self) { card in
                    Text(card.rawValue)
                }
                .accessibilityIdentifier("cardType")
            }
            .pickerStyle(.palette)
            
            ColorPicker("Выберите цвет карты", selection: $viewModel.color)
                .accessibilityIdentifier("cardColor")
            
            Button {
                viewModel.addCard()
                
                if viewModel.showValidCard {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        viewModel.onDisappear()
                        onTapHandler?()
                        dismiss()
                    }
                }
            } label: {
                Text("Добавить")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .accessibilityIdentifier("addButton")
        }
        .padding(.horizontal, 15)
        .alert(isPresent: $viewModel.showInvalidCard, view: viewModel.invalidCardAlert)
        .alert(isPresent: $viewModel.showValidCard, view: viewModel.validCardAlert)
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

private struct ImageView: View {
    let isSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image("card")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Text("1111 1111 1111 1111")
                .font(.custom("Courier", size: UIDevice.isProMax ? 29 : 28).bold())
            
            HStack(spacing: UIDevice.isProMax ? 75 : 69) {
                Text("VISA")
                
                Text("01/29")
            }
            
            Text("CARDHOLDER NAME")
        }
        .font(.custom("Courier", size: UIDevice.isProMax ? 21 : 18).bold())
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .frame(height: UIScreen.main.bounds.height / 3.8)
        .background(LinearGradient(colors: [.blue.opacity(0.25),
                                            .blue.opacity(0.85)],
                                   startPoint: .topLeading,
                                   endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.top, isSheet ? -40 : 15)
    }
}

enum CardTypes: String, CaseIterable {
    case visa = "VISA"
    case mastercard = "MASTERCARD"
    case mir = "МИР"
}

#Preview {
    let context = ContainerService.shared.context
    let cardService = CardServiceImplementation(context: context)
    let transactionService = TransactionServiceImplementation(context: context)
    
    AddCardView(viewModel: CardsViewModel(cardService: cardService, cardDetailsViewModel: CardDetailsViewModel(cardService: cardService, transactionService: transactionService)), isSheet: true) {
        
    }
}
