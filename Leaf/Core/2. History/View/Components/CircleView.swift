//
//  CircleView.swift
//  Leaf
//
//  Created by ddorsat on 31.07.2025.
//

import SwiftUI

struct CircleView: View {
    let groceriesSum: Int
    let bankTransferSum: Int
    let shoppingSum: Int
    let othersSum: Int
    let totalBalance: String

    private var total: Int {
        groceriesSum + bankTransferSum + shoppingSum + othersSum
    }

    private var groceriesCircle: CGFloat {
        total == 0 ? 0 : CGFloat(groceriesSum) / CGFloat(total)
    }

    private var bankTransferCircle: CGFloat {
        total == 0 ? 0 : CGFloat(bankTransferSum) / CGFloat(total)
    }
    
    private var shoppingCircle: CGFloat {
        total == 0 ? 0 : CGFloat(shoppingSum) / CGFloat(total)
    }

    private var othersCircle: CGFloat {
        total == 0 ? 0 : CGFloat(othersSum) / CGFloat(total)
    }

    var body: some View {
        let strokeStyle = StrokeStyle(lineWidth: 18, lineCap: .butt)
        
        ZStack(alignment: .center) {
            Circle()
                .trim(from: 0.0, to: groceriesCircle)
                .stroke(.red.opacity(0.25), style: strokeStyle)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .trim(from: groceriesCircle, to: groceriesCircle + bankTransferCircle)
                .stroke(.orange.opacity(0.25), style: strokeStyle)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .trim(from: groceriesCircle + bankTransferCircle,
                      to: groceriesCircle + bankTransferCircle + shoppingCircle)
                .stroke(.blue.opacity(0.25), style: strokeStyle)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .trim(from: groceriesCircle + bankTransferCircle + shoppingCircle,
                      to: groceriesCircle + bankTransferCircle + shoppingCircle + othersCircle)
                .stroke(.green.opacity(0.25), style: strokeStyle)
                .rotationEffect(.degrees(-90))
            
            VStack(spacing: 5) {
                Text("Общий баланс:")
                Text(totalBalance)
                    .fontWeight(.medium)
            }
            .padding(.top, 15)
            .font(.system(size: UIDevice.isProMax ? 17 : 15))
        }
        .frame(width: UIDevice.isProMax ? 175 : 160, height: UIDevice.isProMax ? 175 : 160)
    }
}

#Preview {
    CircleView(groceriesSum: 552, bankTransferSum: 7828, shoppingSum: 77828, othersSum: 992, totalBalance: "512512")
}
