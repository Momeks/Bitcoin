//
//  Cryptocurrency.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import Foundation

/*
 To support additional cryptocurrencies, add their corresponding IDs from the following source:
 https://docs.google.com/spreadsheets/d/1wTTuxXt8n9q7C4NDXqQpI3wpKu1_5bGVmP9Xz0XGSyU/edit#gid=0
 */

enum Cryptocurrency: String {
    case bitcoin = "bitcoin"
    case ethereum = "ethereum"
}

extension Cryptocurrency {
    var id: String {
        return self.rawValue
    }
}
