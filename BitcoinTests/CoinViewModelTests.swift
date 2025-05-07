//
//  CoinViewModelTests.swift
//  BitcoinTests
//
//  Created by Mohammad Komeili on 4/25/25.
//

import CoinKit
import Combine
import NetworkKit
import XCTest

@testable import Bitcoin

final class CoinViewModelTests: XCTestCase {
    private var mockService: MockNetworkService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        cancellables = []
    }
    
    func test_FetchCoinData_Success() async throws {
        mockService.mockData = Coin.sample
        let viewModel = CoinViewModel(networkService: mockService)
        
        let expectation = expectation(description: "Wait for success state")
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case let .success(coin) = state {
                    XCTAssertEqual(coin.symbol, "BTC")
                    XCTAssertEqual(coin.name, "Bitcoin")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    func test_FetchCoinData_Failure() async throws {
        mockService.shouldThrowError = true
        mockService.errorToThrow = .invalidResponse
        
        let viewmodel = CoinViewModel(networkService: mockService)
        
        let expectation = expectation(description: "Wait for Failure state")
        
        viewmodel.$state
            .dropFirst()
            .sink { state in
                if case let .failure(errorMessage) = state {
                    XCTAssertTrue(errorMessage.contains("Something went wrong. Please try again."))
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
