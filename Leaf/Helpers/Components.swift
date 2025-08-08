//
//  Components.swift
//  Leaf
//
//  Created by ddorsat on 27.07.2025.
//

import SwiftUI

struct Formatters {
    static func sumFormatter(sum: Double) -> String {
        if sum.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f ₽", sum)
        } else {
            return String(format: "%.2f ₽", sum)
        }
    }

    static func dateFormatter(option: String) -> DateFormatter {
        let df = DateFormatter()
        
        if option == "date" {
            df.dateStyle = .short
            df.timeStyle = .none
        } else {
            df.dateStyle = .none
            df.timeStyle = .short
        }
        
        return df
    }
}

struct ButtonComponents {
    @ToolbarContentBuilder
    static func ellipsisButton(completion: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button {
                    completion()
                } label: {
                    Text("Удалить")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .fontWeight(.medium)
            }
        }
    }

    @ToolbarContentBuilder
    static func backButton(completion: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                completion()
            } label: {
                Image(systemName: "chevron.left")
                    .fontWeight(.medium)
            }
        }
    }
}

public func historyOperation(title: String, count: String, color: Color) -> some View {
    HStack(spacing: 5) {
        Text(title)
        
        Text(count)
            .fontWeight(.medium)
    }
    .font(.system(size: UIDevice.isProMax ? 16 : 14))
    .lineLimit(1)
    .minimumScaleFactor(0.8)
    .padding(.vertical, 5)
    .padding(.horizontal, UIDevice.isProMax ? 13 : 12)
    .background(color.opacity(0.25))
    .clipShape(RoundedRectangle(cornerRadius: 20))
}

public func cardInformation(balance: String,
                            proMaxPadding: CGFloat,
                            proPadding: CGFloat) -> some View {
    VStack(spacing: 10) {
        Text("Баланс карты:")
        
        Text(balance)
            .fontWeight(.medium)
    }
    .font(.title3)
    .safeAreaInset(edge: .bottom) {
        Color.clear.frame(height: UIDevice.isProMax ? proMaxPadding : proPadding)
    }
}

public func backgroundGradient(colors: [Color], isSheet: Bool) -> some View {
    LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottom)
        .ignoresSafeArea()
        .frame(height: UIScreen.main.bounds.height / 2)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .safeAreaInset(edge: .bottom) { isSheet ? Color.clear.frame(height: UIDevice.isProMax ? 460 : 430) : Color.clear.frame(height: UIDevice.isProMax ? 500 : 470)}
}

public func emptyView(title: String, padding: Bool) -> some View {
    Text(title)
        .font(.title2)
        .fontWeight(.medium)
        .padding(.top, padding ? 140 : 0)
}

func transactionsView(viewModel: any TransactionsProtocol,
                      completion: @escaping (CardTransaction) -> Void) -> some View {
    ForEach(Array(viewModel.transactions.enumerated()), id: \.1) { index, transaction in
        let shouldShowDate = viewModel.transactions
            .prefix(index)
            .last?.timestamp?.relativeDate != transaction.timestamp?.relativeDate
        
        if shouldShowDate {
            Text(transaction.timestamp?.relativeDate ?? "")
                .foregroundStyle(.gray)
                .font(.callout)
                .fontWeight(.medium)
        }
        
        TransactionCell(transaction: transaction) {
            completion(transaction)
        }
        .accessibilityIdentifier("transaction_\(index)")
    }
}
