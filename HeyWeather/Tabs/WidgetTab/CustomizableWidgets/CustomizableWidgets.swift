//
//  CustomizableWidgets.swift
//  HeyWeather
//
//  Created by Kamyar on 1/26/22.
//

import SwiftUI


struct CustomizableWidgets: View {
    @StateObject var viewModel: CustomizableWidgetsViewModel
    @EnvironmentObject var premium : Premium
    
    var body: some View {
        VStack {
            
            SegmentedPicker(
                items: [.small, .medium, .large],
                titles: [
                    Text("Small", tableName: "WidgetTab"),
                    Text("Medium", tableName: "WidgetTab"),
                    Text("Large", tableName: "WidgetTab")
                ],
                selected: $viewModel.customizingWidgetFamily,
                background: .init(.secondarySystemBackground),
                selectedBackground: .init(.systemBackground)
            ) {
                viewModel.tabIndex = 0
            }
            .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                switch viewModel.customizingWidgetFamily {
                case .small:
                    LazyVGrid(columns: [
                        GridItem(.fixed(Constants.smallWidgetSize.width + 8)), GridItem(.fixed(Constants.smallWidgetSize.width + 8))
                    ], spacing: 16) {
                        ForEach(0..<8) { index in
                            SmallWidgetWrapperView(widgetIndex: index, viewModel: viewModel)
                        }
                    }.padding(.vertical, 20)
                case .medium:
                    VStack(spacing: 16){
                        ForEach(0..<8) { index in
                            MediumWidgetWrapperView(widgetIndex: index, viewModel: viewModel)
                        }
                    }.padding(.vertical, 20)
                default:
                    VStack(spacing: 16){
                        ForEach(0..<6) { index in
                            LargeWidgetWrapperView(widgetIndex: index, viewModel: viewModel)
                        }
                    }.padding(.vertical, 20)
                }
                
            }
            .navigationDestination(isPresented: $viewModel.isCustomizeActive, destination: {
                SingleCustomize(viewModel: .init(
                    weatherData: viewModel.weatherData,
                    widgetIndex: viewModel.customizingWidgetIndex,
                    widgetFamily: viewModel.customizingWidgetFamily
                ), isPresented: $viewModel.isCustomizeActive)
            })
        }
        .padding(.top)
        .navigationTitle(Text("Customizable Widgets", tableName: "Widgets"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.onAppear() }
        
    }
}


//#if DEBUG
//struct CustomizeWidget_Previews: PreviewProvider {
//
//    static var previews: some View {
//        CustomizeWidgetPreviewsContainer()
//    }
//}
//#endif
