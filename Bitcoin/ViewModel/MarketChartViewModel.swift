//
//  MarketChartViewModel.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import Foundation
import CoinKit
import NetworkKit

class MarketChartViewModel: ObservableObject {
    enum ViewState {
        case idle
        case loading
        case success(MarketChart)
        case failure(String)
    }
    
    @Published private(set) var state: ViewState = .idle
    private let networkService: NetworkService
    private let currency: Currency
    private let endpointProvider: EndpointProvider
    private var currentTask: Task<Void, Never>?
    
    init(networkService: NetworkService = URLSessionNetworkService(),
         endpointProvider: EndpointProvider = CoinGeckoEndpointProvider(),
         currency: Currency = .euro) {
        self.networkService = networkService
        self.endpointProvider = endpointProvider
        self.currency = currency
        
        Task {
            await fetchMarketChartData()
        }
    }
    
    @MainActor
    func fetchMarketChartData() async {
        cancelTask()
        
        state = .loading
        
        let endpoint = endpointProvider.marketChartEndpoint(for: CryptoConfig.default, currency: Currency.euro.rawValue, days: "14")
        currentTask = Task {
            do {
                try Task.checkCancellation()
                
                let marketChart: MarketChart = try await networkService.fetch(from: endpoint)
                
                try Task.checkCancellation()
                
                state = .success(marketChart)
                
            } catch is CancellationError {
                return
            } catch {
                state = .failure(error.localizedDescription)
            }
        }
    }
    
    private func cancelTask() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    deinit {
        cancelTask()
    }
}
