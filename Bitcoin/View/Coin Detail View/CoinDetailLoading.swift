//
//  CoinDetailLoading.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct CoinDetailLoading: View {
    @State private var isLoading = false
    
    var body: some View {
        List(0..<3) { _ in
            CurrencyView(currency: .usd, price: 99999.99)
        }
        .listStyle(.plain)
        .redacted(reason: .placeholder)
        .opacity(isLoading ? 0.5 : 1)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                isLoading.toggle()
            }
        }
    }
}

#Preview {
    CoinDetailLoading()
}
