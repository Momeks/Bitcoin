//
//  MarketChartListView.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct MarketChartListView: View {
    @StateObject private var viewModel = MarketChartViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
                
            case .loading:
                MarketChartLoadingView()
                
            case .success(let marketChart):
                List {
                    ForEach(marketChart.toHistoricalPrices()) { price in
                        NavigationLink(destination: CoinDetailView(date: price.date)) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(price.date, style: .date)
                                    .bold()
                                    .foregroundStyle(.secondary)
                                Text("€\(price.price, specifier: "%.2f")")
                                    .bold()
                            }
                        }
                    }
                }
                .listStyle(.plain)
                
            case .failure(let errorMessage):
                ErrorView(errorMessage: errorMessage)
            }
        }
        .task {
            await viewModel.fetchMarketChartData()
        }
    }
}

#Preview {
    MarketChartListView()
}
