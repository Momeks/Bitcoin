//
//  APIKeyProvider.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import Foundation

final class APIKeyProvider {
    static let shared = APIKeyProvider()
    private init() {}

    var coinGeckoAPIKey: String {
        let keyBytes: [UInt8] = [113, 119, 67, 31, 125, 4, 93, 70, 23, 31, 104, 3, 91, 118, 6, 10, 87, 39, 6, 116, 0, 48, 1, 10, 65, 98, 35]
        return QrdlWPgAD4V0cSHcjTWvCQ.shared.wsM03n0ifeFVaSF1kvquZw(key: keyBytes)
    }
}
