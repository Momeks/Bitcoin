//
//  MarketChartViewModel.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import Foundation
import CoinKit
import NetworkKit

protocol MarketChartProtocol: ObservableObject {
    var state: MarketChartViewModel.ViewState { get }
    func fetchMarketChartData() async
    func refreshData()
}

class MarketChartViewModel: MarketChartProtocol {
    enum ViewState {
        case idle
        case loading
        case success([MarketChartDisplayData])
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
        
        let endpoint = endpointProvider.marketChartEndpoint(for: AppConfig.coin, currency: AppConfig.currency, days: "14")
        currentTask = Task {
            do {
                try Task.checkCancellation()
                
                let marketChart: MarketChart = try await networkService.fetch(from: endpoint)
                
                try Task.checkCancellation()
                
                state = .success(makeDisplayData(from: marketChart))
                
            } catch is CancellationError {
                return
            } catch let error as NetworkError {
                state = .failure(error.userMessage)
            } catch {
                state = .failure(error.localizedDescription)
            }
        }
    }
    
    func refreshData() {
        Task {
            await fetchMarketChartData()
        }
    }
    
    private func cancelTask() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    private func makeDisplayData(from chart: MarketChart) -> [MarketChartDisplayData] {
        chart.toHistoricalPrices().map {
            MarketChartDisplayData(
                dateText: $0.date.formatted(date: .abbreviated, time: .omitted),
                priceText: $0.price.formatted(.currency(code: AppConfig.currency))
            )
        }
    }
}
