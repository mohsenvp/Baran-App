//
//  SwiftUIView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 5/24/23.
//

import SwiftUI


struct OnBoardingView: View {
    @StateObject var viewModel: OnBoardingViewModel = .init()
    @State private var index = 0
    var body: some View {
        ZStack {
            VStack{
                TabView(selection: $index) {
                    ForEach((0..<3), id: \.self) { index in
                        VStack {
                            Spacer()
                            
                            OnBoardingImage(index: index)
                            
                            Spacer()
                            
                            OnBoardingText(index: index)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                HStack(spacing: 6) {
                    ForEach((0..<3), id: \.self) { index in
                        Circle()
                            .strokeBorder(Color.white,lineWidth: 1)
                            .background(Circle().foregroundColor(index == self.index ? .white : .clear))
                            .frame(width: 12, height: 12)
                        
                    }
                }
                .padding()
                
                HStack {
                    Button {
                        index = 3
                    } label: {
                        Text("Skip", tableName: "General")
                            .fonted(.body, weight: .medium)
                            .textCase(.uppercase)
                            .frame(maxWidth: .infinity)
                            .opacity(0.8)
                    }
                    
                    Button {
                        index += 1
                    } label: {
                        Group {
                            if index == 2 {
                                Text("Done", tableName: "General")
                            }else{
                                Text("Next", tableName: "General")
                            }
                        }
                        .fonted(.body, weight: .bold)
                        .textCase(.uppercase)
                        .frame(maxWidth: .infinity)
                    }
                }.accentColor(.white)
                    .padding(.bottom, 20)
            }
            
            
            
            ChooseCityView(viewModel: viewModel)
                .opacity(index == 3 ? 1 : 0)
                .animation(.linear, value: index)
        }
        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
        .background(
            Constants.accentColorDark.edgesIgnoringSafeArea(.all)
        ).sheet(isPresented: $viewModel.isCitySearchModalPresented) {
            guard let city = viewModel.chosenCity else { return }
            viewModel.setMainCity(city: city)
            viewModel.navigateMainTab()
        } content: {
            SearchCityView(viewModel: SearchCityViewModel(isPresented: $viewModel.isCitySearchModalPresented, chosenCity: $viewModel.chosenCity))
        }.isLoading($viewModel.isLoading)
    }
}

fileprivate struct ChooseCityView: View {
    @ObservedObject var viewModel: OnBoardingViewModel
    
    var body: some View {
        VStack(spacing: 6){
            Spacer()
            
            Image(Constants.Icons.onBoardingCityPin)
            
            
            Text("You can either allow HeyWeather to access your location to update your city or choose your city manually", tableName: "General")
                .fonted(.body, weight: .regular)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 40)
                .padding(.horizontal, 20)
            
            ZStack {
                Text("Next", tableName: "General")
                    .fonted(.body, weight: .medium)
                HStack {
                    Spacer()
                    Image(systemName: Constants.SystemIcons.arrowRight)
                        .fonted(.body, weight: .medium)
                        .flipsForRightToLeftLayoutDirection(true)
                }
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.white)
            .cornerRadius(Constants.weatherTabRadius)
            .padding()
            .onTapGesture {
                viewModel.startLocatingUser()
            }
            
            Spacer()
            
        }
        .frame(maxWidth: 500)
        .background(
            Constants.accentColorDark.edgesIgnoringSafeArea(.all)
        )
            
        
    }
    
}
struct OnBoardingText: View{
    var index: Int
    let texts = [
        Text("Check weather from multiple cities\non your home screen", tableName: "General"),
        Text("Check live and forecasted\nweather data at ease", tableName: "General"),
        Text("View live and forecasted\natmosphere status on the map", tableName: "General"),
    ]
    var body: some View{
        texts[index]
            .fonted(.body, weight: .regular)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
    }
}
struct OnBoardingImage: View{
    var index: Int
    let images = [
        Constants.Icons.onBoardingPageOne,
        Constants.Icons.onBoardingPageTwo,
        Constants.Icons.onBoardingPageThree
    ]
    var body: some View{
        Image(images[index])
            .scaledToFit()
    }
}
struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
