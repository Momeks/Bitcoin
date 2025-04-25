//
//  HistoricalDataTests.swift
//  BitcoinTests
//
//  Created by Mohammad Komeili on 4/25/25.
//

import XCTest

@testable import Bitcoin
@testable import CoinKit
@testable import NetworkKit

final class HistoricalDataTests: XCTestCase {
    
    func testFetchHistoricalDataSuccess() async {
        let mockService = MockNetworkService()
        mockService.mockData = HistoricalData.preview
        
        let viewModel = HistoricalDataViewModel(networkService: mockService)
        
        await viewModel.fetchHistoricalData(from: "24-04-2025")
        
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        if case let .success(data) = viewModel.state {
            XCTAssertEqual(data.id, "bitcoin")
            XCTAssertEqual(data.marketData!.currentPrice["usd"], 93605.45)
        } else {
            XCTFail("Expected .success but got \(viewModel.state)")
        }
    }
    
    func testFetchHistoricalDataFailure() async {
        let mockService = MockNetworkService()
        mockService.shouldThrowError = true
        mockService.errorToThrow = .invalidResponse
        
        let viewModel = HistoricalDataViewModel(networkService: mockService)
        
        await viewModel.fetchHistoricalData(from: "24-04-2025")
        
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        if case let .failure(message) = viewModel.state {
            XCTAssertTrue(message.contains("Invalid response received from the server"))
        } else {
            XCTFail("Expected .failure but got \(viewModel.state)")
        }
    }
}
