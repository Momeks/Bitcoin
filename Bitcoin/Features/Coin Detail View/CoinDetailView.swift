//
//  CoinDetailView.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct CoinDetailView<ViewModel: HistoricalDataProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
                
            case .loading:
                CoinDetailLoading()
                
            case .failure(let errorMessage):
                ErrorView(errorMessage: errorMessage)
                
            case .success(let displayData):
                if displayData.pricesByCurrency.isEmpty {
                    ErrorView(errorMessage: "No price data available for this date.")
                } else {
                    NavigationStack {
                        List {
                            ForEach(viewModel.availableCurrencies, id: \.self) { currency in
                                if let price = displayData.pricesByCurrency[currency] {
                                    CurrencyView(currency: currency, price: price)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .toolbarRole(.editor)
    }
}
