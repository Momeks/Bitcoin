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
            VStack {
                CoinHeaderView()
                    .frame(height: 170)
            }
        }
    }
}

#Preview {
    MainView()
}
