//
//  TransactionCell.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import SwiftUI
import CoreData

struct TransactionCell: View {
    let transaction: CardTransaction
    let onTapHandler: () -> Void
    
    private var timestamp: Date {
        transaction.timestamp ?? Date()
    }
    
    var body: some View {
        Button(action: onTapHandler) {
            HStack(alignment: .center, spacing: 15) {
                if transaction.status == "Списание" {
                    Image(systemName: transaction.icon ?? "")
                        .font(.system(size: UIDevice.isProMax ? 25 : 24))
                        .frame(width: 30)
                    
                    VStack(alignment:.leading, spacing: 7) {
                        Text(transaction.category ?? "")
                            .font(.system(size: UIDevice.isProMax ? 17 : 16))
                        
                        Text("\(Formatters.dateFormatter(option: "date").string(from: timestamp)), \(Formatters.dateFormatter(option: "time").string(from: timestamp))")
                            .font(.system(size: UIDevice.isProMax ? 14 : 13))
                            .foregroundStyle(.gray)
                            .fontWeight(.medium)
                    }
                    .layoutPriority(1)
                } else {
                    Image(systemName: transaction.icon ?? "")
                        .font(.system(size: UIDevice.isProMax ? 25 : 24))
                        .frame(width: 30)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Пополнение карты")
                            .font(.system(size: UIDevice.isProMax ? 17 : 16))
                        
                        Text("\(Formatters.dateFormatter(option: "date").string(from: timestamp)), \(Formatters.dateFormatter(option: "time").string(from: timestamp))")
                            .font(.system(size: UIDevice.isProMax ? 14 : 13))
                            .foregroundStyle(.gray)
                            .fontWeight(.medium)
                    }
                    .layoutPriority(1)
                }
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
                    .opacity(0.001)
                
                VStack(alignment: .trailing, spacing: 7) {
                    HStack {
                        if transaction.status == "Списание" {
                            Text("- \(Formatters.sumFormatter(sum: transaction.sum))")
                                .font(.system(size: UIDevice.isProMax ? 17 : 16))
                                .fontWeight(.medium)
                        } else {
                            Text("+ \(Formatters.sumFormatter(sum: transaction.sum))")
                                .font(.system(size: UIDevice.isProMax ? 17 : 16))
                                .fontWeight(.medium)
                        }
                    }
                    
                    if transaction.status == "Списание" {
                        Text("Списание")
                            .font(.system(size: UIDevice.isProMax ? 14 : 13))
                            .foregroundStyle(.gray)
                            .fontWeight(.medium)
                    } else {
                        Text("Пополнение")
                            .font(.system(size: UIDevice.isProMax ? 14 : 13))
                            .foregroundStyle(.gray)
                            .fontWeight(.medium)
                    }
                }
                .layoutPriority(1)
            }
        }
        .tint(.black)
    }
}


#Preview {
    let context = ContainerService.shared.context
    TransactionCell(transaction: CardTransaction(context: context)) {
        
    }
}
