//
//  CoinHeaderView.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct CoinHeaderView<ViewModel: CoinViewModelProtocol>: View  {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            switch viewModel.state {
            case .idle:
                EmptyView()
                
            case .loading:
                CoinHeaderLoadingView()
                
            case .success(let displayData):
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 10) {
                        AsyncImage(url: displayData.imageUrl) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(displayData.name)
                            .font(.largeTitle)
                            .bold()
                        
                        Text(displayData.symbol)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text(displayData.priceText)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(displayData.priceChangeText)
                        .font(.title3)
                        .bold()
                        .foregroundColor(displayData.priceChangeColor)
                    
                    Text("Last Updated: \(displayData.lastUpdatedText)")
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

#Preview {
    CoinHeaderView(viewModel: CoinViewModel())
}
