//
//  MarketChartTests.swift
//  BitcoinTests
//
//  Created by Mohammad Komeili on 4/25/25.
//

import XCTest

@testable import Bitcoin
@testable import CoinKit
@testable import NetworkKit

final class MarketChartTests: XCTestCase {
    
    func testMarketChartsForTwoWeeks() {
        let list = HistoricalPrice.sampleList
        
        XCTAssertEqual(list.count, 14, "Expected 14 items in sample list")
        
        for i in 1..<list.count {
            XCTAssertLessThanOrEqual(list[i - 1].date, list[i].date, "Dates should be sorted in ascending order")
        }
    }
    
    func testFetchMarketChartSuccess() async {
        let mockService = MockNetworkService()
        
        let samplePrices = HistoricalPrice.sampleList
        let doublePrices: [[Double]] = samplePrices.map {
            [ $0.date.timeIntervalSince1970 * 1000, $0.price ]
        }
        
        let marketChart = MarketChart(prices: doublePrices)
        mockService.mockData = marketChart
        
        let viewModel = MarketChartViewModel(networkService: mockService)
        
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        if case let .success(chart) = viewModel.state {
            XCTAssertEqual(chart.prices.count, 14)
            XCTAssertTrue(chart.prices.first![1] >= 70000)
        } else {
            XCTFail("Expected success state but got \(viewModel.state)")
        }
    }
}
