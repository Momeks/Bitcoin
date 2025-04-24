//
//  CoinGeckoEndpoint.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import Foundation
import NetworkKit

enum CoinGeckoPath {
    case coin(id: String)
    case marketChart(id: String, currency: String, days: String)

    var id: String {
        switch self {
        case .coin(let id), .marketChart(let id, _, _):
            return id
        }
    }

    var path: String {
        switch self {
        case .coin(let id):
            return "coins/\(id)"
        case .marketChart(let id, _, _):
            return "coins/\(id)/market_chart"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .coin:
            return []
        case .marketChart(_, let currency, let days):
            return [
                URLQueryItem(name: "vs_currency", value: currency),
                URLQueryItem(name: "days", value: days)
            ]
        }
    }
}

struct CoinGeckoEndpoint: Endpoint {
    let pathType: CoinGeckoPath
    let apiKey: String

    var id: String {
        pathType.id
    }

    var baseURL: URL {
        URL(string: "https://api.coingecko.com/api/v3")!
    }

    var path: String {
        pathType.path
    }

    var method: HTTPMethod {
        .get
    }

    var headers: [String: String]? {
        nil
    }

    var queryItems: [URLQueryItem]? {
        var items = pathType.queryItems
        items.append(URLQueryItem(name: "x_cg_demo_api_key", value: apiKey))
        return items
    }

    var body: Data? {
        nil
    }
}
