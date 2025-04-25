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
                Section {
                    List {
                        ForEach(marketChart.toHistoricalPrices()) { price in
                            NavigationLink(destination: CoinDetailView(date: price.date)) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(price.date, style: .date)
                                        .bold()
                                        .foregroundStyle(.secondary)
                                    Text(price.price.formatted(.currency(code: Currency.euro.id)))
                                        .bold()
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                } header: {
                    Label("Last 14 Days", systemImage: "calendar")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
                
            case .failure(let errorMessage):
                ErrorView(errorMessage: errorMessage)
            }
        }
    }
}

#Preview {
    MarketChartListView()
}
