//
//  ContentView.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tabs = .main
    @State private var myCards: CardsViewCases = .myCards
    
    private let dependencies: MainTabViewDependencies
    @StateObject private var mainViewModel: MainViewModel
    @StateObject private var historyViewModel: HistoryViewModel
    @StateObject private var cardsViewModel: CardsViewModel
    
    init(dependencies: MainTabViewDependencies = MainTabViewDependencies()) {
        self.dependencies = dependencies
        self._mainViewModel = StateObject(wrappedValue: dependencies.mainViewModel)
        self._historyViewModel = StateObject(wrappedValue: dependencies.historyViewModel)
        self._cardsViewModel = StateObject(wrappedValue: dependencies.cardsViewModel)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(Tabs.main.rawValue, systemImage: Tabs.main.icon, value: .main) {
                MainView(viewModel: mainViewModel) {
                    selectedTab = .history
                }
            }
            
            Tab(Tabs.history.rawValue, systemImage: Tabs.history.icon, value: .history) {
                HistoryView(viewModel: historyViewModel)
            }
            
            Tab(Tabs.cards.rawValue, systemImage: Tabs.cards.icon, value: .cards) {
                CardsView(viewModel: cardsViewModel, selectedCase: $myCards) {
                    mainViewModel.showExpenseView.toggle()
                } topUpHandler: {
                    mainViewModel.showTopUpView.toggle()
                }
            }
        }
    }
}

enum Tabs: String {
    case main = "Главная"
    case history = "История"
    case cards = "Карты"
    
    var icon: String {
        switch self {
            case .main:
                return "leaf"
            case .history:
                return "list.bullet.rectangle"
            case .cards:
                return "creditcard"
        }
    }
}

#Preview {
    MainTabView()
}
