//
//  CoinView.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct CoinView: View {
    @StateObject private var viewModel = CoinViewModel()

    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                Text("Idle...").foregroundColor(.gray)
                
            case .loading:
                ProgressView("Fetching data...")
                
            case .success(let coin):
                VStack {
                    CoinHeaderView(coin: coin)
                }
                
            case .failure(let errorMessage):
                VStack {
                    Text("Failed to load data")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .task {
            await viewModel.fetchCoinData()
        }
    }
}

#Preview {
    CoinView()
}
