//
//  MainView.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                CoinHeaderView()
                
                MarketChartListView()
            }
            .fontDesign(.rounded)
        }
    }
}

#Preview {
    MainView()
}
