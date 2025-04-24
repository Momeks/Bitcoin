//
//  CurrencyView.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct CurrencyView: View {
    var currency: Currency
    var price: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(currency.flag)
                    .font(.largeTitle)
                
                Text(currency.description)
                    .font(.title3)
                    .fontWeight(.medium)
            }
            
            Text(price.formatted(.currency(code: currency.id)))
                .bold()
                .font(.title3)
                .foregroundStyle(.secondary)
        }

    }
}

#Preview {
    CurrencyView(currency: .euro, price: 87932.20)
}
