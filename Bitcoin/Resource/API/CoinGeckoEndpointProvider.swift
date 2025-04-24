//
//  CoinGeckoEndpointProvider.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//
import Foundation
import NetworkKit

protocol EndpointProvider {
    func coinDetailsEndpoint(for id: String) -> Endpoint
    func marketChartEndpoint(for id: String, currency: String, days: String) -> Endpoint
    func historicalEndpointData(for id: String, date: String) -> Endpoint
}

class CoinGeckoEndpointProvider: EndpointProvider {
    private let apiKey: String
    
    init(apiKey: String = APIKeyProvider.shared.coinGeckoAPIKey) {
        self.apiKey = apiKey
    }
    
    func coinDetailsEndpoint(for id: String) -> Endpoint {
        return CoinGeckoEndpoint(
            pathType: .coin(id: id),
            apiKey: apiKey
        )
    }
    
    func marketChartEndpoint(for id: String, currency: String, days: String) -> Endpoint {
        return CoinGeckoEndpoint(
            pathType: .marketChart(id: id, currency: currency, days: days),
            apiKey: apiKey
        )
    }
    
    func historicalEndpointData(for id: String, date: String) -> Endpoint {
        return CoinGeckoEndpoint(
            pathType: .historicalData(id: id, date: date),
            apiKey: apiKey
        )
    }
}
