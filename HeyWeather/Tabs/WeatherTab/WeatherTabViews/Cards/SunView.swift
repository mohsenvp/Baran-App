//
//  SunView.swift
//  HeyWeather
//
//  Created by Kamyar on 11/28/21.
//

import SwiftUI

struct SunView: View {
    var sun: SunDataModel
    
    @State var appearSun : Bool = false
    
    var body: some View {
        let dayProgress = sun.dayProgress
        let sunAlwaysUpOrDown = sun.alwaysDown || sun.alwaysUp
        let sunAlwaysUp = sun.alwaysUp
        let dayTime = sun.getDayTimePercentage()
        
        VStack {
            
            if appearSun {
                if (dayProgress > 0.0 && dayProgress < 1.0) || sunAlwaysUp {
                    SinGraphView(daylightPercentage: sunAlwaysUp ? 0.4 : dayTime, dayProgress: sunAlwaysUp ? 0.5 : dayProgress)
                        .frame(maxWidth: 400)
                        .padding([.bottom])
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                }
            }
            
            HStack {
                HStack {
                    Image(Constants.Icons.sunrise)
                        .resizable()
                        .foregroundColor(Constants.accentColor)
                        .frame(width: 25, height: 25)
                        .unredacted()
                    if !sunAlwaysUpOrDown {
                        VStack(alignment: .center, spacing: 0) {
                            Text("Sunrise", tableName: "Sun")
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .fonted(.footnote, weight: .regular)
                                .opacity(Constants.primaryOpacity)
                                .padding(.horizontal, 12)
                                .minimumScaleFactor(0.6)
                            
                            Text((sun.sunrise ?? Date()).toUserTimeFormatWithMinuets().lowercased())
                                .fonted(.headline, weight: .bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                    }
                }
                
                if (dayProgress <= 0.0 || dayProgress >= 1.0) && !sunAlwaysUpOrDown {
                    ZStack(alignment: dayProgress <= 0 ? .leading : .trailing) {
                        if dayProgress <= 0.0 {
                            Image(systemName: Constants.SystemIcons.sunMin)
                                .fonted(.title, weight: .regular)
                                .foregroundColor(.orange.opacity(0.6))
                                .zIndex(1)
                                
                            Line()
                                .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, dash: [2.5]))
                                .fill(Color(.secondaryLabel))
                                .opacity(Constants.secondaryOpacity)
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                                .padding(.leading)
                        }
        
                        if dayProgress >= 1.0 {
                            Line()
                                .stroke(Color.gray, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                .opacity(dayProgress >= 1.0 ? 1 : Constants.primaryOpacity)
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                                .padding(.trailing)
                            Image(systemName: Constants.SystemIcons.sunMin)
                                .fonted(.title, weight: .regular)
                                .zIndex(1)
//                                .rotationEffect(.degrees(22.5), anchor: .center)
                                .foregroundColor(.gray.opacity(0.6))
                                
                        }
                    }
                    .padding(.trailing, 5)
                    .frame(maxWidth: .infinity)
                }
                if sunAlwaysUpOrDown {
                    HStack {
                        Spacer()
                        Group {
                            if sun.alwaysUp {
                                Text("Sun Always Up", tableName: "Sun")
                            }else{
                                Text("Sun Always Down", tableName: "Sun")
                            }
                        }
                        .fonted(.headline, weight: .regular)
                        Spacer()
                    }
                } else {
                    Spacer(minLength: 0)
                }
                
                HStack {
                    if !sunAlwaysUpOrDown {
                        VStack(alignment: .center, spacing: 0) {
                            Text("Sunset", tableName: "Sun")
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .fonted(.footnote, weight: .regular)
                                .opacity(Constants.primaryOpacity)
                                .padding(.horizontal, 12)
                                .minimumScaleFactor(0.6)
                            
                            Text ((sun.sunset ?? Date()).toUserTimeFormatWithMinuets().lowercased())
                                .fonted(.headline, weight: .bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                    }
                    Image(Constants.Icons.sunset)
                        .resizable()
                        .foregroundColor(Constants.accentColor)
                        .frame(width: 25, height: 25)
                        .unredacted()
                }
                
            }
            .frame(maxWidth: 420)
            .onAppear {
                DispatchQueue.main.async {
                    appearSun.toggle()
                }
            }
            .onDisappear {
                appearSun.toggle()
            }
            
            
            
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("the sun rises at \((sun.sunset ?? Date()).toUserTimeFormatWithMinuets()), the sun sets at \((sun.sunset ?? Date()).toUserTimeFormatWithMinuets())", tableName: "Accessibility"))
        .frame(maxWidth : .infinity)
        .environment(\.layoutDirection, .leftToRight)
        .weatherTabShape()
        
    }
}


#if DEBUG
struct SunView_Previews: PreviewProvider {
    static var previews: some View {
        SunView(sun: SunDataModel()) .frame(height: 120)
    }
}
#endif


