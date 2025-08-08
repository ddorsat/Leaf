//
//  DropDownPicker.swift
//  Leaf
//
//  Created by ddorsat on 28.07.2025.
//

import SwiftUI

struct DropDownPicker: View {
    @State private var showOptions: Bool = false
    var title: String
    var options: [String]
    @Binding var selection: String?
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(selection ?? title)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .layoutPriority(1)
                    
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 20)
                        .opacity(0.001)
                    
                    Image(systemName: "chevron.down")
                        .font(.title3)
                        .foregroundStyle(.gray)
                        .rotationEffect(.init(degrees: showOptions ? -180 : 0))
                        .layoutPriority(2)
                }
                .padding(.horizontal, 15)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(.white)
                .onTapGesture {
                    withAnimation(.snappy) {
                        showOptions.toggle()
                    }
                }
                .zIndex(1)
                
                if showOptions {
                    optionsView()
                }
            }
            .onAppear {
                if options.count == 1 {
                    selection = options.first
                }
            }
            .clipped()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .shadow(color: Color(.systemGray4), radius: 3)
    }
    
    @ViewBuilder
    private func optionsView() -> some View {
        if !options.isEmpty {
            ForEach(options, id: \.self) { option in
                HStack(spacing: 0) {
                    Text(option)
                        .lineLimit(1)
                        .layoutPriority(1)
                    
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 20)
                        .opacity(0.001)
                }
                .foregroundStyle(selection == option ? .primary : Color.gray)
                .frame(height: 40)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection = option
                        showOptions = false
                    }
                }
            }
            .padding([.horizontal, .bottom], 15)
            .transition(.move(edge: .top))
        } else {
            HStack(spacing: 0) {
                Text("Нет добавленных карт")
                    .foregroundStyle(.gray)
                    .lineLimit(1)
                    .layoutPriority(1)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
                    .opacity(0.001)
            }
            .frame(height: 40)
            .padding([.horizontal, .bottom], 15)
            .transition(.move(edge: .top))
        }
    }
}

#Preview {
    VStack {
        DropDownPicker(title: "Выберите", options: ["123", "123"], selection: .constant(""))
        DropDownPicker(title: "Выберите", options: ["123", "123"], selection: .constant(""))
    }
    .padding()
}
