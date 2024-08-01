//
//  WeatherExtraDetailsView.swift
//  HeyWeather
//
//  Created by MYeganeh on 4/9/23.
//

import SwiftUI

struct WeatherExtraDetailsView: View {
    @StateObject var viewModel: WeatherExtraDetailsViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading){
                HStack {
                    Spacer()
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: Constants.SystemIcons.xmark)
                    }
                    .padding()
                    .accentColor(.init(.label))
                    
                }
                
                HStack {
                    VStack(alignment: .leading){
                        Strings.WeatherDetails.getWeatherDetailsTitle(for: viewModel.type)
                            .fonted(.title3, weight: .light)
                        Text(viewModel.todayData)
                            .fonted(.title, weight: .semibold)
                    }
                    Spacer()
                    
                    if viewModel.type == .wind{
                        WindDirectionCompass(windDegree: viewModel.weatherData.today.details.windDegree)
                    }else{
                        ZStack {
                            Constants.accentColor.cornerRadius(16)
                                .frame(width: 100, height: 100)
                            
                            Image(Constants.Icons.getIconName(for: viewModel.type))
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 48, height: 48)
                                .foregroundColor(.white)
                        }
                    }
                    
                    
                    
                }.padding()
                
                
                if viewModel.getChartData(dataType: .daily).count > 0 {
                    Text("Next 10 days", tableName: "WeatherTab")
                        .fonted(.title3, weight: .semibold)
                        .padding()
                    
                    ExtraDetailsChartView(chartData: viewModel.getChartData(dataType: .daily), dataType: .daily, unit: viewModel.chartUnit)
                    
                }
                
                if viewModel.getChartData(dataType: .hourly).count > 0 {
                    Text("Next 10 hours", tableName: "WeatherTab")
                        .fonted(.title3, weight: .semibold)
                        .padding()
                    
                    ExtraDetailsChartView(chartData: viewModel.getChartData(dataType: .hourly), dataType: .hourly, unit: viewModel.chartUnit)
                }
                
                Group {
                    Text("About", tableName: "WeatherTab") + Text(" ") + Strings.WeatherDetails.getWeatherDetailsTitle(for: viewModel.type)
                }
                .fonted(.title3, weight: .semibold)
                .padding()
                
                
                Strings.WeatherDetails.getWeatherDetailsText(for: viewModel.type)
                    .fonted(.body, weight: .regular)
                    .foregroundColor(.init(.secondaryLabel))
                    .padding(.horizontal)
                
                Spacer(minLength: 50)
            
            }
        }
        .environment(\.layoutDirection, LocalizeHelper.shared.currentLanguage.isRTL ? .rightToLeft : .leftToRight)

    }
    fileprivate struct WindDirectionCompass: View {
        let windDegree: Int?
        var body: some View {
            ZStack {
                Circle()
                    .fill(Color(.secondarySystemBackground))
                Image(systemName: Constants.SystemIcons.arrowUp)
                    .fonted(.title, weight: .semibold)
                    .rotationEffect(.degrees(Double((windDegree ?? 180) - 180))) // TODO: Handle This
                    .cornerRadius(Constants.weatherTabRadius)
                Circle()
                    .stroke(Color.gray ,style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [25], dashPhase: -15))
                    .padding(17.5)
                    .opacity(Constants.secondaryOpacity/4)
                
                VStack {
                    Text("N")
                        .opacity(Constants.secondaryOpacity)
                        .fonted(.caption, weight: .regular)
                        .background(Color.clear)
                    Spacer()
                    Text("S")
                        .opacity(Constants.secondaryOpacity)
                        .fonted(.caption, weight: .regular)
                        .background(Color.clear)
                }
                .padding(.vertical, 7.5)
                
                HStack {
                    Text("W")
                        .opacity(Constants.secondaryOpacity)
                        .fonted(.caption, weight: .regular)
                    Spacer()
                    Text("E")
                        .opacity(Constants.secondaryOpacity)
                        .fonted(.caption, weight: .regular)
                }
                .padding(.horizontal, 7.5)
                
            }
            .dynamicTypeSize(...Constants.maxDynamicType)
            .frame(width: 100, height: 100)
        }
    }
#if DEBUG
struct WeatherExtraDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WindDirectionCompass(windDegree: 0)
            .previewLayout(.sizeThatFits)

    }
}
#endif

    
}
