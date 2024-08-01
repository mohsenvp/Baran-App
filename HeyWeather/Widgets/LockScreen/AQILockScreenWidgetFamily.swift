//
//  AQiLockScreenWidgetFamily.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/22/23.
//

import SwiftUI
import WidgetKit

struct LockScreenAQIWidgetFamily: View {
    var aqi : AQI = .init(value: 12, index: 1, progress: 30)
    var widgetSize : WidgetFamily
    var id = 0
    
    var body: some View {
        switch widgetSize {
        case .accessoryCircular:
            CircularView(aqi: aqi, id: id)
        case .accessoryRectangular:
            RectangularView(aqi: aqi, id: id)
        case .accessoryInline:
            InlineView(aqi: aqi)
        case .accessoryCorner:
            if #available(iOS 17.0, *) {
                CornerView(aqi: aqi)
            }
        default:
            EmptyView()
        }
        
    }
}
private struct InlineView: View {
    let aqi : AQI
    var id = 0
    
    var body: some View {
        HStack {
            Image(Constants.Icons.getIconName(for: aqi.index))
            Text("AQI: \(aqi.value.localizedNumber) - \(aqi.status.capitalized)", tableName: "AQI")
                .contentTransition(.numericText())

        }
    }
    
}

private struct RectangularView: View {
    let aqi : AQI
    var id = 0
    
    var body: some View {
        #if os(watchOS)
        let vspacing = -4.0
        #else
        let vspacing = 0.0
        #endif
        VStack(alignment: .leading, spacing: vspacing){
            HStack(spacing: 4){
                Image(Constants.Icons.getIconName(for: aqi.index))
                    .resizable()
                    .frame(width: 22, height: 22)
                    
                
                VStack(alignment: .leading){
                    Text("Air Quality", tableName: "AQI")
                        .fonted(size: 12, weight: .regular)
                    Text(aqi.status.uppercased())
                        .fonted(size: 14, weight: .semibold)
                }
                
                Spacer(minLength: 0)
            }
            .widgetAccentable()
            
            Spacer(minLength: 2)
            HStack {
                #if os(watchOS)
                let valueFontSize = 24.0
                let lineSpacing = 6.0
                let lineWidth = 6.0
                let textToBarSpacing = 4.0
                #else
                let valueFontSize = 16.0
                let lineSpacing = 4.0
                let lineWidth = 3.0
                let textToBarSpacing = 1.0
                #endif
                AQIDashView(name: Text("AQI", tableName: "AQI"), value: CGFloat(aqi.value), aqiIndex: aqi.index, lineWidth: lineWidth, lineSpacing: lineSpacing, textToBarSpacing: textToBarSpacing, titleFontSize: 14, valueFontSize: valueFontSize)
                    .fontWeight(.semibold)
                
                
                if let pm25 = aqi.getPM25() {
                    AQIDashView(name: Text(pm25.name), value: Double(pm25.value), aqiIndex: pm25.index, lineWidth: lineWidth, lineSpacing: lineSpacing,textToBarSpacing: textToBarSpacing, titleFontSize: 14, valueFontSize: valueFontSize)
                        .fontWeight(.semibold)
                }
                
            }
            .padding(.horizontal, 4)
        }
        .padding(.vertical, 10)
        .complexModifier({ myView in
            #if os(watchOS)
            myView.containerBackground(Constants.aqiColors[aqi.index], for: .widget)
            #else
            myView.widgetBackground(Color.clear, hasPadding: false)
            #endif
        })
    }
    
}

private struct CircularView: View {
    let aqi : AQI
    var id = 0
    
    var body: some View {
        Gauge(value: CGFloat(aqi.value.aqiValueToProgress()), in: CGFloat(0)...CGFloat(100)) {
            Text("\(aqi.value)")
                .fonted(.body, weight: .bold)
                .foregroundStyle(Constants.aqiColors[aqi.index])
                .widgetAccentable()
                .contentTransition(.numericText())
        } currentValueLabel: {
            Image(Constants.Icons.getIconName(for: aqi.index))
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(.bottom, 8)
                .foregroundStyle(Constants.aqiColors[aqi.index])
                .widgetAccentable()
        }
        .tint(Constants.aqiColors[aqi.index])
        .gaugeStyle(.accessoryCircular)
        .widgetBackground(Color.clear, hasPadding: false)
    }
}

@available(iOS 17.0, *)
private struct CornerView: View {
    let aqi : AQI
    
    var body: some View {
        Image(Constants.Icons.getIconName(for: aqi.index))
            .renderingMode(.template)
            .scaleEffect(2)
            .foregroundStyle(Constants.aqiColors[aqi.index])
            .widgetAccentable()
            .widgetLabel {
                Text("\(aqi.value.localizedNumber): \(aqi.status)")
                    .foregroundStyle(Constants.aqiColors[aqi.index])
            }
            .widgetBackground(Color.clear)
    }
}

#if DEBUG
struct LockScreenAQIWidgetFamily_Previews: PreviewProvider {
    static var previews: some View {
        RectangularView(
            aqi: .init(value: 23, index: 0, progress: 20)
        ).previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        
    }
}
#endif
