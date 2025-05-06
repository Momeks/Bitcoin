//
//  HistoricalDataTests.swift
//  BitcoinTests
//
//  Created by Mohammad Komeili on 4/25/25.
//

import XCTest
import Combine

@testable import Bitcoin
@testable import CoinKit
@testable import NetworkKit

final class HistoricalDataTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var mockService: MockNetworkService!
    
    override func setUp() {
        mockService = MockNetworkService()
        cancellables = []
    }
    
    func test_FetchHistoricalData_Success() async {
        mockService.mockData = HistoricalData.sample
        let viewModel = HistoricalDataViewModel(networkService: mockService, date: Date())
        
        let expectation = XCTestExpectation(description: "Wait for success state")
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case let .success(data) = state {
                    XCTAssertEqual(data.symbol, "BTC")
                    XCTAssertEqual(data.name, "Bitcoin")
                    XCTAssertEqual(data.pricesByCurrency.count, 2)
                    XCTAssertEqual(data.pricesByCurrency[.usd], "$93,605.45")
                    XCTAssertEqual(data.pricesByCurrency[.euro], "€82,601.29")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 3.0)
    }
    
    override func tearDown() {
        super.tearDown()
        mockService = nil
    }
}
