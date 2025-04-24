//
//  LoadingHeaderView.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct LoadingHeaderView: View {
    @State private var isFading = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Text("Bitcoin")
                    .font(.largeTitle)
                    .bold()
                
                Text("btc")
                    .font(.title3)
            }
            
            Text("€ 81,965.00")
                .font(.largeTitle)
                .bold()
            
            Text("−816,69 (0,99 %")
                .font(.title3)
                .bold()
            
            Text("Last Updated: Thursday, April 24, 2025")
        }
        .redacted(reason: .placeholder)
        .opacity(isFading ? 0.4 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                isFading.toggle()
            }
        }
    }
}

#Preview {
    LoadingHeaderView()
}
