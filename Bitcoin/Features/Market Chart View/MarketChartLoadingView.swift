//
//  MarketChartLoadingView.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct MarketChartLoadingView: View {
    @State private var isLoading = false
    
    var body: some View {
        List(0..<14) { _ in
            VStack(alignment: .leading, spacing: 5) {
                Text("April 14, 2025")
                    .bold()
                    .foregroundStyle(.secondary)
                Text("€82.228,08")
                    .bold()
            }
            .redacted(reason: .placeholder)
            .opacity(isLoading ? 0.5 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    isLoading.toggle()
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    MarketChartLoadingView()
}
