//
//  TutorialEditPopupView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/1/23.
//

import SwiftUI
 
struct TutorialEditPopupView: View {
    @Binding var isShown: Bool
    @State var myOpacity =  0.0
    @State var myHighlightOpacity = 0.0
    var body: some View {
        
        VStack(spacing: 0){
            HStack {
                Text("Edit Widget", tableName: "WidgetTutorials")
                    .fonted(.callout, weight: .regular)
                    .lineLimit(1)
                Spacer()
                Image(systemName: Constants.SystemIcons.infoCircle)
            }
            .padding(12)
            .background(
                Rectangle()
                    .fill(Color.accentColor)
                    .opacity(myHighlightOpacity)
                    .animation(Constants.isWidthCompact ? nil : .linear(duration: 1).repeatForever(autoreverses: true), value: myHighlightOpacity)
            )
            
            Rectangle().fill(.gray.opacity(0.2)).frame(height: 6)
            HStack {
                Text("Edit Home Screen", tableName: "WidgetTutorials")
                    .fonted(.callout, weight: .regular)
                    .lineLimit(1)
                Spacer()
                Image(systemName: Constants.SystemIcons.appsIphone)
            }.padding(12)
            
            Divider()
            HStack {
                Text("Remove Widget", tableName: "WidgetTutorials")
                    .fonted(.callout, weight: .regular)
                    .foregroundColor(.red)
                    .lineLimit(1)
                Spacer()
                Image(systemName: Constants.SystemIcons.minusCircle)
                    .foregroundColor(.red)
            }.padding(12)
        }.background(
            ZStack {
                Rectangle().fill(.background.opacity(0.8))
                Blur()
            }
        )
        .dynamicTypeSize(...DynamicTypeSize.large)
        .cornerRadius(12)
        .shadow(radius: 3)
        .frame(width: 220)
        .opacity(myOpacity)
        .animation(Constants.isWidthCompact ? nil : .linear(duration: 0.2), value: myOpacity)
        .onChange(of: isShown) { shown in
            if shown {
                myOpacity = 1
                myHighlightOpacity = 0.5
            }else {
                myOpacity = 0
            }
        }
        
        
    }
}
