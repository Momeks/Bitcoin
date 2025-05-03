//
//  MarketChartTests.swift
//  BitcoinTests
//
//  Created by Mohammad Komeili on 4/25/25.
//

import XCTest
import Combine

@testable import Bitcoin
@testable import CoinKit
@testable import NetworkKit

final class MarketChartTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func testMarketChartsForTwoWeeks() {
        let list = HistoricalPrice.sampleList
        
        XCTAssertEqual(list.count, 14, "Expected 14 items in sample list")
        
        let isSorted = zip(list, list.dropFirst()).allSatisfy { $0.date <= $1.date }
        XCTAssertTrue(isSorted, "Dates should be sorted in ascending order")
    }
    
    func testFetchMarketChartSuccess() async {
        let mockService = MockNetworkService()
        
        let samplePrices = HistoricalPrice.sampleList
        let doublePrices: [[Double]] = samplePrices.map {
            [ $0.date.timeIntervalSince1970 * 1000, $0.price]
        }
        
        let marketChart = MarketChart(prices: doublePrices)
        mockService.mockData = marketChart
        
        let viewModel = MarketChartViewModel(networkService: mockService)
        
        let expectation = XCTestExpectation(description: "Wait for success state")
        
        viewModel.$state
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { state in
                if case let .success(chart) = state {
                    XCTAssertEqual(chart.prices.count, 14)
                    XCTAssertTrue(chart.prices.first![1] >= 70000)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected success state but got \(state)")
                }
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 3.0)
    }
}
