//
//  CoinHeaderView.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI
import CoinKit

struct CoinHeaderView: View {
    @StateObject private var viewModel = CoinViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
                
            case .loading:
                LoadingHeaderView()
                
            case .success(let coin):
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 10) {
                        AsyncImage(url: URL(string: coin.image.large)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(coin.name)
                            .font(.largeTitle)
                            .bold()
                        
                        Text(coin.symbol)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let eur = coin.marketData.currentPrice["eur"] {
                        Text("€\(eur, specifier: "%.2f")")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    PriceChangeView(change: coin.marketData.priceChange24H,
                                    percentage: coin.marketData.priceChangePercentage24H)
                    
                    Text("Last Updated: \(coin.toDateString())")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
                
            case .failure(let errorMessage):
                VStack {
                    Text("Failed to load coin data")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .task {
            await viewModel.fetchCoinData()
        }
    }
}

struct PriceChangeView: View {
    let change: Double
    let percentage: Double
    
    var body: some View {
        let formattedChange = String(format: "%+.2f", change)
        let formattedPercent = String(format: "%.2f", percentage)
        
        return Text("\(formattedChange) (\(formattedPercent)%)")
            .font(.title3)
            .bold()
            .foregroundColor(change >= 0 ? .green : .red)
    }
}

#Preview {
    CoinHeaderView()
}
