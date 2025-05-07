//
//  ErrorView.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct ErrorView: View {
    var errorMessage: String
    
    var body: some View {
        ContentUnavailableView("Error",
                               systemImage: "exclamationmark.triangle",
                               description: Text(errorMessage).foregroundStyle(.secondary)
        )
    }
}

#Preview {
    ErrorView(errorMessage: "Something Wrong")
}
