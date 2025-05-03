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
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: Date())
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func testFetchHistoricalDataSuccess() async {
        let mockService = MockNetworkService()
        mockService.mockData = HistoricalData.sample
        
        let viewModel = HistoricalDataViewModel(networkService: mockService)
        
        let expectation = XCTestExpectation(description: "Wait for success state")
        
        viewModel.$state
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .first {
                guard case .success = $0 else { return false }
                return true
            }
            .sink { state in
                if case let .success(data) = state {
                    XCTAssertEqual(data.id, "bitcoin")
                    XCTAssertEqual(data.marketData!.currentPrice["usd"], 93605.45)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected .success but got \(state)")
                }
            }
            .store(in: &cancellables)
        
        await viewModel.fetchHistoricalData(from: formattedDate)
        await fulfillment(of: [expectation], timeout: 3.0)
    }
    
    func testFetchHistoricalDataFailure() async {
        let mockService = MockNetworkService()
        mockService.shouldThrowError = true
        mockService.errorToThrow = .invalidResponse
        
        let viewModel = HistoricalDataViewModel(networkService: mockService)
        
        let expectation = XCTestExpectation(description: "Wait for failure state")
        
        viewModel.$state
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .first {
                guard case .failure = $0 else { return false }
                return true
            }
            .sink { state in
                if case let .failure(message) = state {
                    XCTAssertTrue(message.contains("Invalid response received from the server"))
                    expectation.fulfill()
                } else {
                    XCTFail("Expected .failure but got \(state)")
                }
            }
            .store(in: &cancellables)
        
        await viewModel.fetchHistoricalData(from: formattedDate)
        await fulfillment(of: [expectation], timeout: 3.0)
    }
}
