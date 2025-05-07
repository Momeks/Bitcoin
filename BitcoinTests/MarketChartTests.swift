//
//  MarketChartTests.swift
//  BitcoinTests
//
//  Created by Mohammad Komeili on 4/25/25.
//

import CoinKit
import Combine
import NetworkKit
import XCTest

@testable import Bitcoin

final class MarketChartTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var mockService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        cancellables = []
    }
    
    func test_MarketCharts_ForTwoWeeks() {
        let list = HistoricalPrice.sampleList
        
        XCTAssertEqual(list.count, 14, "Expected 14 items in sample list")
        
        let isSorted = zip(list, list.dropFirst()).allSatisfy { $0.date <= $1.date }
        XCTAssertTrue(isSorted, "Dates should be sorted in ascending order")
    }
    
    func test_FetchMarketChart_Success() async {
        let samplePrices = HistoricalPrice.sampleList
        let doublePrices: [[Double]] = samplePrices.map {
            [$0.date.timeIntervalSince1970 * 1000, $0.price]
        }
        
        let marketChart = MarketChart(prices: doublePrices)
        mockService.mockData = marketChart
        
        let viewModel = MarketChartViewModel(networkService: mockService)
        
        let expectation = XCTestExpectation(description: "Wait for success state")
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case let .success(chart) = state {
                    XCTAssertEqual(chart.count, 14)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected success state but got \(state)")
                }
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 3.0)
    }
    
    func test_PriceText_IsCurrencyFormatted() {
        let sample = MarketChartDisplayData.sample
        XCTAssertTrue(sample.priceText.contains("$") || sample.priceText.contains("€"), "Price should include a currency symbol")
    }
    
    override func tearDown() {
        super.tearDown()
        mockService = nil
    }
}
