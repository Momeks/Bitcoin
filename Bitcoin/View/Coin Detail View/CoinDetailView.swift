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
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            case .success(let coin):
                NavigationStack {
                    Section {
                        List {
                            ForEach(currencies, id: \.self) { currency in
                                if let price = coin.marketData.currentPrice[currency.id] {
                                    currencyView(currency: currency, price: price)
                                }
                            }
                        }
                    } header: {
                        Text(displayDate)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                            .padding(.horizontal)
                    }
                    .listStyle(.plain)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .navigationTitle(coin.name)
                .navigationBarTitleDisplayMode(.large)
                
            case .failure(let errorMessage):
                ErrorView(errorMessage: errorMessage)
            }
        }
        .task {
            print(formatedDate)
            await viewModel.fetchHistoricaData(from: formatedDate)
        }
    }
    
    @ViewBuilder
    private func currencyView(currency: Currency, price: Double) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(currency.flag)
                    .font(.largeTitle)
                
                Text(currency.description)
                    .font(.title3)
                    .fontWeight(.medium)
            }
            
            Text(price.formatted(.currency(code: currency.id)))
                .bold()
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    CoinDetailView(date: Date())
}
