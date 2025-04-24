//
//  CoinDetailLoading.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct CoinDetailLoading: View {
    @State private var isFading = false
    
    var body: some View {
        List(0..<3) { _ in
            CurrencyView(currency: .euro, price: 99999.99)
        }
        .listStyle(.plain)
        .redacted(reason: .placeholder)
        .opacity(isFading ? 0.5 : 1)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                isFading.toggle()
            }
        }
    }
}

#Preview {
    CoinDetailLoading()
}
