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
        VStack(alignment: .leading) {
            switch viewModel.state {
            case .idle:
                EmptyView()
                
            case .loading:
                LoadingHeaderView()
                
            case .success(let coin):
                VStack(alignment: .leading, spacing: 5) {
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
                    
                    Text(coin.toCurrencyString(for: AppConfig.currency))
                        .font(.largeTitle)
                        .bold()
                    
                    PriceChangeView(change: coin.marketData.priceChange24H,
                                    percentage: coin.marketData.priceChangePercentage24H)
                    
                    Text("Last Updated: \(coin.toDateString())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
            case .failure(let errorMessage):
                ErrorView(errorMessage: errorMessage)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
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
