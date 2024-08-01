//
//  TimeTravelDatePickerView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/22/23.
//

import SwiftUI

struct TimeTravelDatePickerView : View {
    @ObservedObject var viewModel: TimeTravelViewModel
    
    var body: some View {
        VStack(spacing: 2){
            
            dateSelectorTitle
            
            datePicker
            
        }
    }
    
    
    @ViewBuilder var dateSelectorTitle: some View {
        Line()
            .stroke(style: StrokeStyle(lineWidth: 0.5))
            .foregroundColor(Constants.TimeTravelPrimary)
            .frame(height: 1)
            .padding(.top, 8)
            .accessibilityHidden(true)
        
        Text("Select a point in time to go to", tableName: "TimeTravel")
            .font(.custom(Constants.AmericanTypewriteFontName, size: 16))
            .foregroundColor(Constants.TimeTravelPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom, 10)
            .padding(.top, 8)
        
        Line()
            .stroke(style: StrokeStyle(lineWidth: 0.5))
            .foregroundColor(Constants.TimeTravelPrimary)
            .frame(height: 1)
            .accessibilityHidden(true)
    }
    
    @ViewBuilder var datePicker: some View {
        
        let minDate = Calendar.current.date(byAdding: .year, value: -40, to: Date.now)!
        let maxDate = Calendar.current.date(byAdding: .day, value: -10, to: Date.now)!

        DatePicker(selection: $viewModel.selectedDate,in: minDate...maxDate, displayedComponents: .date) {
            
        }
        .foregroundColor(.red)
        .labelsHidden()
        .datePickerStyle(.wheel)
        .padding(.top)
        .colorInvert()
        .colorMultiply(Constants.TimeTravelPrimary)
    }
}
