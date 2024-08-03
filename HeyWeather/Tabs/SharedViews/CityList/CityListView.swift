//
//  CityListView.swift
//  HeyWeather
//
//  Created by Kamyar on 10/27/21.
//

import SwiftUI

struct CityListView: View {
    @EnvironmentObject var premium: Premium
    @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented
    @StateObject var viewModel: CityListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.weatherDatas) { weatherData in
                cityRowView(weatherData: weatherData)
            }
            .onMove(perform: { from, to in
                viewModel.moveCity(from: from, to: to)
            })
        }
        .listStyle(.plain)
        .background(Color(.systemGroupedBackground))
        .background(Color.mint.edgesIgnoringSafeArea(.all))
        .alert(isPresented: $viewModel.isMaxCitiesAlertPresented) {
            viewModel.maxCitiesAlert()
        }
        .onChange(of: viewModel.isSubscriptionViewPresented) { isPresented in
            isSubscriptionViewPresented.wrappedValue = isPresented
        }
        .onAppear {
            self.viewModel.initialize(isPremium: premium.isPremium)
        }
        .sheet(isPresented: $viewModel.isCitySearchModalPresented) {
            guard let addedCity = viewModel.addedCity else { return }
            viewModel.addCity(city: addedCity)
            if (addedCity.isCurrentLocation && viewModel.mainCity.isCurrentLocation) {
                viewModel.setMainCity(city: addedCity)
            }
        } content: {
            SearchCityView(viewModel: SearchCityViewModel(isPresented: $viewModel.isCitySearchModalPresented, chosenCity: $viewModel.addedCity))
        }
        .navigationTitle(Text("Cities", tableName: "CityList"))
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    guard premium.isPremium || viewModel.weatherDatas.count < 2 else {
                        viewModel.isMaxCitiesAlertPresented = true
                        return
                    }
                    guard viewModel.weatherDatas.count < 9 else {
                        viewModel.isMaxCitiesAlertPresented = true
                        return
                    }
                    
                    viewModel.onAddCityTapped()
                } label: {
                    Image(systemName: Constants.SystemIcons.plus)
                        .fonted(.body, weight: .semibold)
                    
                }
            }
        }
    }
    
    @ViewBuilder
    private func cityRowView(weatherData: WeatherData) -> some View {
        let index = viewModel.weatherDatas.firstIndex(of: weatherData) ?? 0
        let allowedToDelete = !weatherData.location.isCurrentLocation && weatherData.location != viewModel.mainCity
        let allowedToSelect = premium.isPremium || index < 2
        let isRedacted = !weatherData.today.isAvailable
        
        SwipeToDeleteView(onDelete: {
            withAnimation {
                viewModel.removeCity(index: index)
            }
        }, content: {
            CityItem(weatherData: weatherData,
                     selectedCity: $viewModel.mainCity,
                     allowedToSelect: allowedToSelect,
                     isRedacted: isRedacted)
            .onTapGesture {
                if allowedToSelect {
                    viewModel.setMainCity(city: weatherData.location)
                } else {
                    viewModel.presentSubscriptionView()
                }
            }
            
        }, allowedToDelete: allowedToDelete)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .padding(.vertical , 2)
        .deleteDisabled(!allowedToDelete)
    }
}


#if DEBUG
struct CityListView_Previews: PreviewProvider {
    static let premium = Premium()
    static var previews: some View {
        CityListView(viewModel: .init(isCityListOpen: .constant(true)))
            .environmentObject(premium)
    }
}
#endif



struct SwipeToDeleteView<Content: View>: View {
    @GestureState private var tempSwipeOffset: CGFloat = 0
    @State private var swipeOffset: CGFloat = 0
    let content: () -> Content
    let onDelete: () -> Void
    let allowedToDelete: Bool
    
    
    init(onDelete: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content , allowedToDelete : Bool) {
        self.content = content
        self.onDelete = onDelete
        self.allowedToDelete = allowedToDelete
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            self.content()
                .frame(maxWidth: .infinity)
                .offset(x: allowedToDelete ? swipeOffset + tempSwipeOffset : 0)
                .animation(.spring, value: swipeOffset + tempSwipeOffset)
                .gesture(
                    allowedToDelete ?
                    DragGesture()
                        .updating($tempSwipeOffset) { gesture, state, _ in
                            if gesture.translation.width + self.swipeOffset < 0 {
                                state = max(-95, gesture.translation.width)
                            }
                        }
                        .onEnded { gesture in
                            withAnimation(.spring) {
                                if -gesture.translation.width + self.swipeOffset > 50 {
                                    self.swipeOffset = max(-95, gesture.translation.width)
                                } else {
                                    self.swipeOffset = 0
                                }
                            }
                        } : nil
                )
            
            if allowedToDelete && swipeOffset + tempSwipeOffset < 0 {
                DeleteButton(offset: swipeOffset + tempSwipeOffset, onDelete: onDelete)
            }
        }
    }
}



struct DeleteButton: View {
    var offset: CGFloat
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var onDelete: (() -> ())?
    var body: some View {
        Button { onDelete?() } label: {
            Image(systemName: Constants.SystemIcons.trash)
                .fonted(.title2, weight: .regular)
                .scaleEffect(-offset < 90 ? (-offset/90) + 0.01 : 1)
                .opacity(-offset < 90 ? -offset/90 : 1)
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .foregroundColor(.red)
        .padding()
        .frame(width: -offset < 90 ? -offset/1.2 : 85)
        .frame(maxHeight: .infinity)
        .background(Color.red.opacity(0.08))
        .cornerRadius(Constants.weatherTabRadius)
        .padding(.trailing)
    }
}
