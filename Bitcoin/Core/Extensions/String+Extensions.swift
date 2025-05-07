//
//  String+Extensions.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 06.05.25.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.date(from: self)
    }
}
