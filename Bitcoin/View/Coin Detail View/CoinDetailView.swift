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
    
    private var formatedDate: String {
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
                NavigationStack {
                    VStack(spacing: 0) {
                        Text(displayDate)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                            .padding(.horizontal)
                        
                        List {
                            ForEach(currencies, id: \.self) { currency in
                                if let price = coin.marketData.currentPrice[currency.id] {
                                    CurrencyView(currency: currency, price: price)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .navigationTitle(coin.name)
                .navigationBarTitleDisplayMode(.large)
                .toolbarRole(.editor)
                
            case .failure(let errorMessage):
                ErrorView(errorMessage: errorMessage)
            }
        }
        .task {
            await viewModel.fetchHistoricalData(from: formatedDate)
        }
    }
}

#Preview {
    CoinDetailView(date: Date())
}
