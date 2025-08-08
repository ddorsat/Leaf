//
//  TransactionDetailsView.swift
//  Leaf
//
//  Created by ddorsat on 29.07.2025.
//

import SwiftUI
import CoreData

protocol TransactionDetailsProtocol: ObservableObject {
    var showEllipsis: Bool { get set }
    
    func deleteTransaction(transaction: CardTransaction)
}

struct TransactionDetailsView<VM: TransactionDetailsProtocol>: View {
    @ObservedObject var viewModel: VM
    @Environment(\.dismiss) private var dismiss
    let transaction: CardTransaction
    
    private var cardNumber: String {
        return transaction.cardNumber ?? ""
    }
    
    var body: some View {
        ZStack {
            backgroundGradient(colors: [.blue.opacity(0.25), .blue.opacity(0.8)], isSheet: false)
            
            ScrollView(.vertical, showsIndicators: false) {
                Spacer(minLength: UIDevice.isProMax ? 270 : 250)
                
                VStack(spacing: 50) {
                    VStack(spacing: 15) {
                        Text(transaction.status ?? "")
                            .foregroundStyle(transaction.status == "Пополнение" ? .green : .red)
                            .fontWeight(.medium)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                            .background(transaction.status == "Пополнение" ? .green.opacity(0.1) : .red.opacity(0.1))
                            .clipShape(Capsule())
                            .padding(.top, 50)
                        
                        if transaction.status == "Списание" {
                            Text("- \(Formatters.sumFormatter(sum: transaction.sum))")
                                .font(.title2)
                                .fontWeight(.medium)
                        } else {
                            Text("+ \(Formatters.sumFormatter(sum: transaction.sum))")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Детали транзакции")
                            .fontWeight(.medium)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Статус")
                                    .foregroundStyle(.gray)
                                
                                Spacer()
                                
                                Text(transaction.status ?? "")
                                    .foregroundStyle(transaction.status == "Пополнение" ? .green : .red)
                            }
                            
                            if transaction.category != nil {
                                HStack {
                                    Text("Категория")
                                        .foregroundStyle(.gray)
                                    
                                    Spacer()
                                    
                                    Text(transaction.category ?? "")
                                }
                            }
                            
                            HStack {
                                Text("Карта")
                                    .foregroundStyle(.gray)
                                
                                Spacer()
                                
                                Text(cardNumber)
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Время")
                                    .foregroundStyle(.gray)
                                
                                Spacer()
                                
                                Text(Formatters.dateFormatter(option: "time").string(from: transaction.timestamp ?? Date()))
                            }
                            
                            HStack {
                                Text("Дата")
                                    .foregroundStyle(.gray)
                                
                                Spacer()
                                
                                Text(Formatters.dateFormatter(option: "date").string(from: transaction.timestamp ?? Date()))
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Сумма")
                                .foregroundStyle(.gray)
                            
                            Spacer()
                            
                            Text(Formatters.sumFormatter(sum: transaction.sum))
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .alert("Удалить транзакцию?", isPresented: $viewModel.showEllipsis) {
            Button("Удалить", role: .destructive) {
                viewModel.deleteTransaction(transaction: transaction)
                dismiss()
            }
            
            Button("Отмена", role: .cancel) {
                dismiss()
            }
        }
        .ignoresSafeArea()
        .navigationTitle("Детали транзакции")
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
    
    NavigationStack {
        TransactionDetailsView(viewModel: HistoryViewModel(cardsViewModel: CardsViewModel(cardService: cardService, cardDetailsViewModel: CardDetailsViewModel(cardService: cardService, transactionService: transactionService)), transactionService: transactionService), transaction: CardTransaction(context: context))
    }
}
