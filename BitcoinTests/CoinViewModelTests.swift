//
//  CoinViewModelTests.swift
//  BitcoinTests
//
//  Created by Mohammad Komeili on 4/25/25.
//

import XCTest
import Combine

@testable import Bitcoin
@testable import CoinKit
@testable import NetworkKit

final class CoinViewModelTests: XCTestCase {
    
    func testFetchCoinDataSuccess() async throws {
        let mockService = MockNetworkService()
        mockService.mockData = Coin.sample
        
        let viewModel = CoinViewModel(networkService: mockService)
        
        let expectation = XCTestExpectation(description: "Wait for state update")
        var cancellables = Set<AnyCancellable>()
        
        viewModel.$state
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { state in
                if case let .success(coin) = state {
                    XCTAssertEqual(coin.id, "bitcoin")
                    XCTAssertEqual(coin.symbol, "btc")
                    XCTAssertEqual(coin.marketData.currentPrice["usd"], 62842.56)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected success state but got \(state)")
                }
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testFetchCoinDataFailure() async {
        let mockService = MockNetworkService()
        mockService.shouldThrowError = true
        mockService.errorToThrow = .invalidResponse
        
        let viewModel = CoinViewModel(networkService: mockService)
        
        let expectation = XCTestExpectation(description: "Wait for failure state")
        var cancellables = Set<AnyCancellable>()
        
        viewModel.$state
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { state in
                if case let .failure(message) = state {
                    XCTAssertTrue(message.contains("Invalid response received from the server"))
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure state but got \(state)")
                }
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
}
