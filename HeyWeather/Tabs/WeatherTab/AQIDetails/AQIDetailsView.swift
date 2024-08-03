//
//  AQIDetailsView.swift
//  HeyWeather
//
//  Created by Kamyar on 12/13/21.
//

import SwiftUI

struct AQIDetailsView: View {
    @StateObject var viewModel: AQIDetailsViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            ScrollView(showsIndicators: false) {
                VStack {
                    let index = viewModel.aqiData.current.index
                    
                   
                    VStack{

                        HStack {
                            Spacer()
                            Button {
                                isPresented.toggle()
                            } label: {
                                Image(systemName: Constants.SystemIcons.xmark)
                            }
                            .padding(20)
                            .tint(.init(.label))
                        }
                        
                        VStack {
                            Image(Constants.Icons.getIconName(for: index))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                            
                            Text(viewModel.aqiData.current.status)
                                .fonted(.title2, weight: .regular)
                        }
                        .foregroundColor(.black)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text("air quality is \(viewModel.aqiData.current.status)", tableName: "Accessibility"))
                        .padding()
                        .padding(.vertical)
                        .frame(height: 150)
                        
                        AQIBar(progress: viewModel.aqiData.current.progress, aqi: viewModel.aqiData.current.value)
                            .frame(height: 17.5)
                            .padding(.bottom, 70)
                            .accessibilityElement(children: .combine)
                            .environment(\.layoutDirection, .leftToRight)
                        
                    }
                    .background(Constants.aqiColors[index].ignoresSafeArea(.all, edges: [.top]))

                    
                    ScrollViewReader { scrollReader in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top) {
                                TextCard(title: Text("Health Implications", tableName: "AQI"), description: viewModel.aqiData.current.healthImplications)
                                TextCard(title: Text("Cautionary Statement", tableName: "AQI"), description: viewModel.aqiData.current.cautionaryStatement)
                            }
                            .padding()
                        }
                        .onAppear {
                            scrollReader.scrollTo(0, anchor: LocalizeHelper.shared.currentLanguage.isRTL ? .trailing : .leading)
                        }
                    }
                    
                    
                    Text("Pollutants", tableName: "AQI")
                        .fonted(.title3, weight: .medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.leading, 4)
                    VStack(spacing: 10){
                        ForEach(viewModel.aqiData.current.details, id: \.self.name) { detail in
                            PollutantsCard(showAqiValue: viewModel.showAqiValue, detail: detail)
                            if detail != viewModel.aqiData.current.details.last{
                                Divider()
                                    .padding(.leading)
                            }
                        }
                        .onTapGestureForced {
                            withAnimation {
                                viewModel.showAqiValue.toggle()
                            }
                        }
                    }.padding(.vertical,10)
                    .weatherTabShape(horizontalPadding: false).cornerRadius(20).padding(.horizontal)
                    
                    Text("Upcoming hours", tableName: "AQI")
                        .fonted(.title3, weight: .medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .padding(.leading, 4)
                    
                    
                    HourlyAQIForecastCard(viewModel: viewModel)
                    
                    
                    Text("Upcoming days", tableName: "AQI")
                        .fonted(.title3, weight: .medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .padding(.leading, 4)
                        .padding(.top, 6)
                    
                    DailyAQIForecastCard(viewModel: viewModel)
                }
                .padding(.bottom)
                .navigationTitle(Text("Air Quality", tableName: "AQI"))
                .navigationBarTitleDisplayMode(.inline)
            }
            .ignoresSafeArea(.all, edges: [.top])
        }
        .dynamicTypeSize(...Constants.maxDynamicType)
        .environment(\.layoutDirection, LocalizeHelper.shared.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        .sheet(isPresented: $viewModel.isSubscriptionViewPresented, content: {
            SubscriptionView(viewModel: .init(premium: viewModel.premium), isPresented: $viewModel.isSubscriptionViewPresented)
                .environmentObject(viewModel.premium)
            
        })
//        .onReceive(Constants.premiumPurchaseWasSuccessfulPublisher) { _ in
//            isPresented = false
//        }
    }
    
    struct AQIBar: View {
        let progress: Int
        let aqi: Int
        var body: some View {
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    let progress = min(max(1.0, aqi.aqiValueToProgress()), 93) / 100
                    GradientBar(colors: Constants.aqiColors)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 17.5, height: 17.5)
                        .offset(x: (proxy.size.width) * progress)
                        .brightness(1)
                    
                    Pointer(aqi: aqi, proxy: proxy)
                        .padding(.horizontal, -20)
                        .offset(x: (proxy.size.width) * progress, y: 35)
                    
                }
            }
            .padding(.horizontal, 50)
        }
        
        struct Pointer: View {
            let aqi: Int
            let proxy: GeometryProxy
            var body: some View {
                
                let x = 35.0
                let sideLength = 5.0
                
                Path { path in
                    path.move(to: .init(x: x - sideLength, y: sideLength))
                    path.addLine(to: .init(x: x, y: 0))
                    path.addLine(to: .init(x: x + sideLength, y: sideLength))
                    path.addLine(to: .init(x: x - sideLength, y: sideLength))
                }
                .fill(.white)
                .offset(y: -4.5)
                .zIndex(1)
                
                
                HStack {
                    
                    Text("AQI", tableName: "AQI")
                        .fonted(.body, weight: .light)
                        .opacity(0.3)
                        .padding(.trailing, -5)
                    
                    Text(aqi.localizedNumber)
                        .fonted(.body, weight: .regular)
                    
                }
                .foregroundColor(.black)
                .fonted(.subheadline, weight: .regular)
                .padding(5)
                .background(Color.white)
                .clipShape(Rectangle())
                .cornerRadius(5)
                .dynamicTypeSize(...DynamicTypeSize.large)
                
            }
            
        }
        
    }
    
    struct GradientBar: View {
        let colors: [Color]
        var body: some View {
            Capsule()
                .fill(getGradient())
                .frame(height: 25)
        }
        func getGradient() -> LinearGradient {
            return LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
        }
    }
    
    struct Bar: View {
        let backgroundColor: Color
        let fillColor: Color
        let progress: Int
        var body: some View {
            ZStack(alignment: .leading) {
                GeometryReader { proxy in
                    Capsule()
                        .fill(backgroundColor)
                    Capsule()
                        .fill(fillColor)
                        .frame(width: proxy.size.width * CGFloat(progress)/100.0, alignment: .leading)
                }
            }.frame(height: 8)
        }
    }
    
    struct PollutantsCard: View {
        @Environment(\.dynamicTypeSize) var typeSize
        
        var showAqiValue: Bool
        let detail: PollutantsDetail
        
        var body: some View {
            VStack {
                HStack(spacing: 3) {
                    Text(verbatim: "\(detail.name.uppercased()):")
                        .fonted(.body, weight: .medium)
                    
                    Text(showAqiValue ? Double(detail.aqi_value).localizedNumber() : Double(detail.value).localizedNumber())
                        .fonted(.callout, weight: .regular)
                    
                    if !showAqiValue{
                        Text("µg/m³")
                            .fonted(.caption, weight: .regular)
                            .foregroundColor(Constants.lighTheme.darkInnerShadowColor)
                    }
                    Spacer()
                    ZStack {
                        Text(detail.status)
                            .fonted(.callout, weight: .regular)
                            .foregroundColor(Constants.aqiColors[detail.index])
                            .padding(.vertical,2)
                            .padding(.horizontal,4)
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                    }.background(.gray.opacity(0.08)).cornerRadius(4)
                }
                
                
                Bar(backgroundColor: Color(.tertiaryLabel).opacity(Constants.primaryOpacity),
                    fillColor: Constants.aqiColors[detail.index],
                    progress: detail.progress)

            }
            .frame(height: typeSize < .xxxLarge ? 60 : 90)
            .accessibilityElement(children: .combine)
            .padding(.horizontal)
        }
    }
    
    struct TextCard: View {
        let title: Text
        let description: String
        var body: some View {
            let width = description.widthOfString(usingFont: .systemFont(ofSize: 18))
            
            VStack(alignment: .leading) {
                title
                    .fonted(.headline, weight: .semibold)
                    .padding(.vertical, 2.5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text(description)
                    .fonted(.body, weight: .regular)
                    .frame(minHeight: width > 250 ? width/10 : 30, alignment: .top)
                Spacer(minLength: 0)
            }
            .accessibilityElement(children: .combine)
            .frame(minWidth: 120, maxWidth: 300, maxHeight: Constants.screenHeight / 4, alignment: .topLeading)
            .weatherTabShape()
            .padding(.trailing, 5)
        }
    }
    
    
    
}


private struct HourlyAQIForecastCard: View {
    @ObservedObject var viewModel: AQIDetailsViewModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack {
                Spacer(minLength: 16)
                ForEach(viewModel.aqiData.hourlyForecast) { aqi in
                    SingleAQIBar(aqi: aqi)
                }
                Spacer(minLength: 16)
            }
        }
        .frame(height: 220)
        .weatherTabShape(horizontalPadding: false)
        .isPremium(viewModel.premium.isPremium,title: Text("Get Air Quality Forecasts with Premium!", tableName: "AQI"), subtitle: nil, isSubscriptionViewPresented: $viewModel.isSubscriptionViewPresented)
        .padding(.horizontal)
        
    }
    struct SingleAQIBar: View {
        var aqi: AQI
        var body: some View {
            VStack {
                Spacer()
                Image(Constants.Icons.getIconName(for: aqi.index))
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(.init(.label))
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .opacity(Constants.secondaryOpacity)
                
                Text(aqi.value.description)
                    .fonted(.caption, weight: .regular)
                    .opacity(Constants.primaryOpacity)
                
                Rectangle()
                    .fill(Constants.aqiColors[aqi.index])
                    .cornerRadius(8)
                    .frame(width: 25, height: CGFloat((aqi.index + 1)) * 20)
                
                Circle()
                    .fill(Constants.aqiColors[aqi.index])
                    .frame(width: 5, height: 5)
                
                Text(aqi.localDate.atHour)
                    .lineLimit(1)
                    .fonted(.footnote, weight: .regular)
                    .minimumScaleFactor(0.9)
                
            }
            .padding(.vertical)
            .padding(.horizontal, 6)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(aqi.date.shortLocalizedString)
                .accessibilityValue(aqi.value.description)
            
        }
    }
}

private struct DailyAQIForecastCard: View {
    @ObservedObject var viewModel: AQIDetailsViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack {
                Spacer(minLength: 6)
                ForEach(viewModel.dailyForecast) { aqi in
                    AQIDashView(name: aqi.localDate.isTodayReal() ? Text("Today (Now)", tableName: "General") : Text(aqi.localDate.weekday), value: CGFloat(aqi.value), aqiIndex: aqi.index, lineWidth: 6, lineSpacing: 10, textToBarSpacing: 6, colored: true,titleFontSize: 14,
                                valueFontSize: 14)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 6)
                }
                Spacer(minLength: 6)
            }
        }
        .weatherTabShape()
        .isPremium(viewModel.premium.isPremium,title: Text("Get Air Quality Forecasts with Premium!", tableName: "AQI"), subtitle: nil, isSubscriptionViewPresented: $viewModel.isSubscriptionViewPresented)
        .padding(.horizontal)
    }
}

struct AQIDetailsView_Previews: PreviewProvider {
    @State static var presented: Bool = false
    static var previews: some View {
        AQIDetailsView(viewModel: .init(aqiData: .init(), premium: .init()), isPresented: $presented)
    }
}
