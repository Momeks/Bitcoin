//
//  MarketChartListView.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import SwiftUI

struct MarketChartListView: View {
    @ObservedObject private var viewModel: MarketChartViewModel
    
    init(viewModel: MarketChartViewModel = MarketChartViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
                
            case .loading:
                MarketChartLoadingView()
                
            case .success(let chartDataList):
                Section {
                    List {
                        ForEach(chartDataList) { data in
                            NavigationLink(destination: CoinDetailView(date: parseDate(from: data.dateText))) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(data.dateText)
                                        .bold()
                                        .foregroundStyle(.secondary)
                                    Text(data.priceText)
                                        .bold()
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                } header: {
                    Label("Last 14 Days", systemImage: "calendar")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
                
            case .failure(let errorMessage):
                ErrorView(errorMessage: errorMessage)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .refreshData)) { _ in
            viewModel.refreshData()
        }
    }
}

extension MarketChartListView {
    private func parseDate(from dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.date(from: dateString) ?? Date()
    }
}

#Preview {
    MarketChartListView()
}
