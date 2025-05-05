//
//  MarketChartDisplayData.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 05.05.25.
//


import Foundation
import CoinKit

struct MarketChartDisplayData: Identifiable {
    let id = UUID()
    let dateText: String
    let priceText: String
}

#if DEBUG
extension MarketChartDisplayData {
    static let sample = MarketChartDisplayData(
        dateText: "Apr 24, 2024",
        priceText: "$72,134.54"
    )
    
    static let sampleList: [MarketChartDisplayData] = HistoricalPrice.sampleList.map {
        MarketChartDisplayData(
            dateText: $0.date.formatted(date: .abbreviated, time: .omitted),
            priceText: $0.price.formatted(.currency(code: AppConfig.currency.uppercased()))
        )
    }
}
#endif
