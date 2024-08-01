//
//  CurrentCompactView.swift
//  HeyWeather WatchOS
//
//  Created by Mohammad Yeganeh on 9/11/23.
//

import SwiftUI

struct CurrentCompactView: View {
    @ObservedObject var viewModel: WatchViewModel

    var body: some View {
        HStack(spacing: 4){
            
            ConditionIcon(
                iconSet: Constants.default3DIconSet,
                condition: viewModel.weatherData.today.condition
            )
            .frame(width: 40, height: 40)
            
            
            VStack(alignment: .leading){
                Text(viewModel.city?.name ?? "")
                    .fonted(size: 14, weight: .regular)
                    .lineLimit(1)
                    .foregroundColor(viewModel.textColor)
                
                Text("\(viewModel.weatherData.today.temperature.max?.localizedTemp ?? "")↑ ↓\(viewModel.weatherData.today.temperature.min?.localizedTemp ?? "")")
                    .fonted(size: 12, weight: .regular)
                    .foregroundColor(viewModel.textColor)
                
            }
            Spacer(minLength: 0)
            
            
            Text(viewModel.weatherData.today.temperature.now?.localizedTemp ?? "")
                .foregroundColor(viewModel.textColor)
                .fonted(.title3, weight: .semibold)
                .lineLimit(1)
            
        }
        .padding(.horizontal, 18)
    }
}

#Preview {
    CurrentCompactView(viewModel: .init())
}
