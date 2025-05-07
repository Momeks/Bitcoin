//
//  Date+Extensions.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 06.05.25.
//

import Foundation

extension Date {
    func coinGeckoFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }

    func navigationTitleFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: self)
    }
}
