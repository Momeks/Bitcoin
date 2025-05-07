//
//  HistoricalDisplayData.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 05.05.25.
//

import Foundation
import SwiftUI

struct HistoricalDisplayData {
    let name: String
    let symbol: String
    let pricesByCurrency: [Currency: String]
}

#if DEBUG
extension HistoricalDisplayData {
    static let sample = HistoricalDisplayData(
        name: "Bitcoin",
        symbol: "BTC",
        pricesByCurrency: [
            .usd: "$93,605.45",
            .euro: "€82,601.29",
            .pound: "£73,300.00"
        ]
    )
}
#endif

