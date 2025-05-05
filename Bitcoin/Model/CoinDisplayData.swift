//
//  CoinDisplayData.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 05.05.25.
//

import Foundation
import SwiftUI

struct CoinDisplayData {
    let name: String
    let symbol: String
    let imageUrl: URL?
    let priceText: String
    let priceChangeText: String
    let priceChangeColor: Color
    let lastUpdatedText: String
}
