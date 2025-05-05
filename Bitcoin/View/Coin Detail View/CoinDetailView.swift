//
//  CoinDetailView.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct CoinDetailView: View {
    var date: Date
    @ObservedObject private var viewModel: HistoricalDataViewModel
    private let currencies: [Currency] = [.euro, .usd, .pound]
    
    init(date: Date, viewModel: HistoricalDataViewModel = HistoricalDataViewModel()) {
        self.date = date
        self.viewModel = viewModel
    }
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
    
    private var titleDate: String {
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
                
            case .failure(let errorMessage):
                ErrorView(errorMessage: errorMessage)
                
            case .success(let displayData):
                if displayData.pricesByCurrency.isEmpty {
                    ErrorView(errorMessage: "No price data available for this date.")
                } else {
                    NavigationStack {
                        List {
                            ForEach(currencies, id: \.self) { currency in
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
        .navigationTitle(titleDate)
        .navigationBarTitleDisplayMode(.large)
        .toolbarRole(.editor)
        .task {
            await viewModel.fetchHistoricalData(from: formattedDate)
        }
    }
}
