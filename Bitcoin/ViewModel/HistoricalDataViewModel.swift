//
//  HistoricalDataViewModel.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import Foundation
import CoinKit
import NetworkKit

protocol HistoricalDataProtocol: ObservableObject {
    var state: HistoricalDataViewModel.ViewState { get }
    func fetchHistoricalData(from date: String) async
}

class HistoricalDataViewModel: HistoricalDataProtocol {
    enum ViewState {
        case idle
        case loading
        case success(HistoricalDisplayData)
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
    func fetchHistoricalData(from date: String) async {
        cancelTask()
        
        state = .loading
        
        let endpoint = endpointProvider.endpoint(for: .historicalData(id: AppConfig.coin, date: date))
        currentTask = Task {
            do {
                try Task.checkCancellation()
                
                let historicalData: HistoricalData = try await networkService.fetch(from: endpoint)
                
                try Task.checkCancellation()
                
                state = .success(makeDisplayData(from: historicalData))
                
            } catch is CancellationError {
                return
            } catch let error as NetworkError {
                state = .failure(error.userMessage)
            } catch {
                state = .failure(error.localizedDescription)
            }
        }
    }
    
    private func cancelTask() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    private func makeDisplayData(from data: HistoricalData) -> HistoricalDisplayData {
        let rawPrices = data.marketData?.currentPrice ?? [:]

        let formattedPrices = rawPrices.reduce(into: [Currency: String]()) { dict, pair in
            if let currency = Currency(rawValue: pair.key.lowercased()) {
                let formatted = pair.value.formatted(.currency(code: currency.id.uppercased()))
                dict[currency] = formatted
            }
        }

        return HistoricalDisplayData(
            name: data.name,
            symbol: data.symbol.uppercased(),
            pricesByCurrency: formattedPrices
        )
    }
}
