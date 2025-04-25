//
//  CoinViewModelTests.swift
//  BitcoinTests
//
//  Created by Mohammad Komeili on 4/25/25.
//

import XCTest

@testable import Bitcoin
@testable import CoinKit
@testable import NetworkKit

final class CoinViewModelTests: XCTestCase {
    
    func testFetchCoinDataSuccess() async {
        let mockService = MockNetworkService()
        mockService.mockData = Coin.sample
        
        let viewModel = CoinViewModel(networkService: mockService)
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        if case let .success(coin) = viewModel.state {
            XCTAssertEqual(coin.id, "bitcoin")
            XCTAssertEqual(coin.symbol, "btc")
            XCTAssertEqual(coin.marketData.currentPrice["usd"], 62842.56)
        } else {
            XCTFail("Expected success state but got \(viewModel.state)")
        }
    }

    func testFetchCoinDataFailure() async {
        let mockService = MockNetworkService()
        mockService.shouldThrowError = true
        mockService.errorToThrow = .invalidResponse

        let viewModel = CoinViewModel(networkService: mockService)
        
        try? await Task.sleep(nanoseconds: 500_000_000)

        if case let .failure(message) = viewModel.state {
            XCTAssertTrue(message.contains("Invalid response received from the server"))
        } else {
            XCTFail("Expected failure state but got \(viewModel.state)")
        }
    }
}

