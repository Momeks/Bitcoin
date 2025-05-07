//
//  CoinDisplayData.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 05.05.25.
//

import Foundation
import SwiftUI

struct CoinDisplayData {
    let name: String
    let symbol: String
    let imageUrl: URL?
    let priceText: String
    let priceChangeText: String
    let priceChangeColor: Color
    let lastUpdatedText: String
}

#if DEBUG
extension CoinDisplayData {
    static var sample: CoinDisplayData {
        CoinDisplayData(
            name: "Bitcoin",
            symbol: "BTC",
            imageUrl: URL(string: "https://assets.coingecko.com/coins/images/1/small/bitcoin.png"),
            priceText: "$62,842.56",
            priceChangeText: "+192.80 (0.21%)",
            priceChangeColor: .green,
            lastUpdatedText: "May 5, 2025 at 3:12 PM"
        )
    }
}
#endif
