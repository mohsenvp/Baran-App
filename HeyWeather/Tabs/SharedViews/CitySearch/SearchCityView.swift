//
//  SearchCityView.swift
//  HeyWeather
//
//  Created by Kamyar on 10/30/21.
//

import SwiftUI

struct SearchCityView: View {
    @StateObject var viewModel: SearchCityViewModel
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: Constants.SystemIcons.magnifyingGlass)
                        .padding(.leading)
                    
                    TextField(String(localized: "Search for a city", table: "CityList"), text: $viewModel.query)
                        .onChange(of: viewModel.query) { newValue in
                            guard newValue.count > 2 || newValue.isEmpty else { return }
                            viewModel.search(currentValue: newValue)
                        }
                }
                .frame(height: 50)
                .padding(.trailing)
                .background(Color(.secondaryLabel).opacity(0.1))
                .clipShape(Capsule())
                .padding(.horizontal)
                ScrollView {
                    VStack(spacing:3) {
                        CurrentLocationCell() { viewModel.chooseCurrentLocation() }
                        content
                    }.padding(.horizontal)
                }
            }
            .alert(isPresented: $viewModel.isAlertPresented, content: {
                switch viewModel.alertType {
                case .locationPermission:
                    return Alerts.generalAlert(title: Text("We do not have access to your location, tap Grant Access to go to settings and enable location access for HeyWeather", tableName: "Alerts"), message: nil, defaultBt: Text("Grant Access!", tableName: "Alerts")){
                        AppState.shared.navigateToAppSettingPage()
                    }
                case .cityLimit:
                    return  Alerts.maxCitiesAlert()
                }
            })
            .onAppear { viewModel.logView() }
            .navigationTitle(Text("Add City", tableName: "CityList"))
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
        .dynamicTypeSize(...Constants.maxDynamicType)
        .environment(\.layoutDirection, LocalizeHelper.shared.currentLanguage.isRTL ? .rightToLeft : .leftToRight)

    }
    
     @ViewBuilder private var content: some View {
         if viewModel.isSearching {
             ForEach(0...10, id: \.self) { index in
                 CityCell(city: City()).redacted(isRedacted: viewModel.isSearching, supportInvalidation: false)
             }
         }else if viewModel.cities.count == 0 {
             Text("No Results", tableName: "CityList")
                 .padding()
         }else {
             ForEach(viewModel.cities) { city in
                 CityCell(city: city) { viewModel.chooseCity(city: city) }
             }
         }
     }
    struct CurrentLocationCell: View {
        var onTap: (() -> ())?
        var body: some View {
            Button { onTap?() } label: {
                HStack {
                    Image(Constants.Icons.location)
                        .resizable()
                        .padding(5)
                        .frame(width: 30, height: 30)
                    Text("Current Location", tableName: "CityList")
                        .fonted(.body, weight: .medium)
                        .padding(.leading, 5)
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .foregroundColor(.init(.label))
            .weatherTabShape()
            .padding(.vertical, 2)
        }
    }
    
    struct CityCell: View {
        let city: City
        var onTap: (() -> ())?
        var body: some View {
            Button { onTap?() } label: {
                HStack {
                    DownloadableImage(urlString: city.flagURLString, sampleImageName: Constants.Icons.unknownFlag)
                        .frame(width: 24, height: 24)
                        .scaledToFill()
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(city.name)
                            .fonted(.callout, weight: .medium)
                        
                        HStack(spacing:0) {
                            if (city.state != "") {
                                Text(city.state + Constants.commaAndSpace)
                            }
                            Text(city.country)
                                
                        }.fonted(.footnote, weight: .light)
                            .opacity(0.7)
                    }
                    .padding(.leading, 4)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 12)
                .padding(.leading, 16)
                
            }
            .foregroundColor(.init(.label))
            .weatherTabShape(horizontalPadding: false, verticalPadding: false)
            .padding(.vertical, 2)
        }
    }
}

#if DEBUG
struct SearchCityView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SearchCityViewModel(isPresented: .constant(true), chosenCity: .constant(City()))
        SearchCityView(viewModel: viewModel)
    }
}
#endif
