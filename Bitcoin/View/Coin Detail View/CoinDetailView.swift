//
//  CoinDetailView.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct CoinDetailView: View {
    var date: Date
    @StateObject private var viewModel = HistoricalDataViewModel()
    private  let currencies: [Currency] = [.euro, .usd, .pound]
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
    
    private var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
                
            case .loading:
                CoinDetailLoading()
                
            case .success(let coin):
                if let currentPrice = coin.marketData?.currentPrice, !currentPrice.isEmpty {
                    NavigationStack {
                        List {
                            ForEach(currencies, id: \.self) { currency in
                                if let price = currentPrice[currency.id] {
                                    CurrencyView(currency: currency, price: price)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .navigationTitle(displayDate)
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarRole(.editor)
                } else {
                    ErrorView(errorMessage: "No price data available for this date.")
                }
                
            case .failure(let errorMessage):
                ErrorView(errorMessage: errorMessage)
            }
        }
        .task {
            await viewModel.fetchHistoricalData(from: formattedDate)
        }
    }
}

#Preview {
    CoinDetailView(date: Date())
}
