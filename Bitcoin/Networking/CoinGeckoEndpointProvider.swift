//
//  CoinGeckoEndpointProvider.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import Foundation
import NetworkKit

protocol EndpointProvider {
    func endpoint(for path: CoinGeckoPath) -> Endpoint
}

class CoinGeckoEndpointProvider: EndpointProvider {
    private let apiKey: String

    init(apiKey: String = APIKeyProvider.shared.coinGeckoAPIKey) {
        self.apiKey = apiKey
    }

    func endpoint(for path: CoinGeckoPath) -> Endpoint {
        return CoinGeckoEndpoint(pathType: path, apiKey: apiKey)
    }
}
