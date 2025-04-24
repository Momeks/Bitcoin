//
//  CoinViewModel.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import Foundation
import CoinKit
import NetworkKit

class CoinViewModel: ObservableObject {
    enum ViewState {
        case idle
        case loading
        case success(Coin)
        case failure(String)
    }
    
    @Published private(set) var state: ViewState = .idle
    private let networkService: NetworkService
    private let endpointProvider: EndpointProvider
    private var currentTask: Task<Void, Never>?
    
    init(networkService: NetworkService = URLSessionNetworkService(),
         endpointProvider: EndpointProvider = CoinGeckoEndpointProvider()) {
        self.networkService = networkService
        self.endpointProvider = endpointProvider
    }
    
    @MainActor
    func fetchCoinData() async {
        cancelTask()
        
        state = .loading
        
        let endpoint = endpointProvider.coinDetailsEndpoint(for: CryptoConfig.default)
        currentTask = Task {
            do {
                try Task.checkCancellation()
                
                let coin: Coin = try await networkService.fetch(from: endpoint)
                
                try Task.checkCancellation()
                
                state = .success(coin)
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
