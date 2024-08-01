//
//  WidgetsTutorialView.swift
//  HeyWeather
//
//  Created by Mojtaba on 10/21/23.
//

import SwiftUI

enum TutorialType: String, CaseIterable, RawRepresentable {
    case homeScreen = "Home Screen"
    case lockScreen = "Lock Screen"
    case liveActivity = "Live Activity"
}

struct WidgetsTutorialView: View {
    @State private var selected = TutorialType.homeScreen
    var images = [Constants.TutorialImages.homeScreenTutorialFirstPage, Constants.TutorialImages.homeScreenTutorialSecondPage, Constants.TutorialImages.homeScreenTutorialThirdPage, Constants.TutorialImages.homeScreenTutorialFourthPage]
    var texts = ["**TAP** and **HOLD** on the lock screen to enter **Customize Mode**", "Tap on the **+ icon** that appears on the top left side of the screen", ]
    @State var pageNumber = 1
    var body: some View {
        NavigationView {
            VStack {
                SegmentedPicker(items: TutorialType.allCases,titles: [
                    Text("Home Screen", tableName: "WidgetTutorials"),
                    Text("Lock Screen", tableName: "WidgetTutorials"),
                    Text("Live Activity", tableName: "WidgetTutorials")
                ], selected: $selected) {
                }
                .padding([.leading, .trailing])
                Spacer()
                switch selected {
                case .homeScreen:
                    TabView {
                        GeometryReader { geo in
                            ZStack {
                                GeometryReader(content: { geometry in
                                    ZStack(alignment: .topLeading){
                                        Image(images[pageNumber - 1])
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                        if pageNumber == 2 {
                                            ZStack {
                                                PulseView(pulseColor: .purple, showImage: false, pulseShapeType: .capsule)
                                                    .frame(width: geometry.size.width * 0.13,
                                                           height: geometry.size.width * 0.06)
                                                
                                                Text("+")
                                                    .monospaced()
                                                    .foregroundStyle(.white)
                                            }
                                            .offset(x: geometry.size.width * 0.14,
                                                    y: geometry.size.width * 0.05)
                                        }
                                    }
                                })
                                .frame(width: geo.size.width * 0.7,
                                       height: (geo.size.width * 0.7) * 2.12)
                                
                                
                                VStack {
                                    Spacer()
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(maxWidth: .infinity,
                                                   maxHeight: geo.size.height * 0.3)
                                            .padding([.leading, .trailing])
                                            .foregroundStyle(.primary)
                                            .colorInvert()
                                            .shadow(color: .gray.opacity(0.4), radius: 10, x: 2, y: 2)
                                        Text ("**TAP** and **HOLD** on the lock screen to enter **Customize Mode**")
                                            .multilineTextAlignment(.center)
//                                            .foregroundStyle(Color.secondary)
                                            .padding()
                                            .padding([.leading, .trailing])
                                        VStack {
                                            Spacer()
                                            HStack (alignment: .center){
                                                Button(action: {
                                                    if pageNumber > 1 {
                                                        pageNumber -= 1
                                                    }
                                                }, label: {
                                                    Image(systemName: "arrow.left")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 15, height: 15)
//                                                        .foregroundColor(Color.primary)
                                                        .padding()
                                                        .clipShape(Circle())
                                                })
                                                .padding()
                                                .padding(.leading)
                                                Spacer()
                                                PageDottedIndicatorView(selectedPage: pageNumber, color: .purple)
                                                    .frame(height: 10)
                                                Spacer()
                                                Button(action: {
                                                    if pageNumber < 4 {
                                                        pageNumber += 1
                                                    }
                                                }, label: {
                                                    Image(systemName: pageNumber == 4 ? Constants.SystemIcons.checkmark : Constants.SystemIcons.arrowRight)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 15, height: 15)
                                                        .foregroundColor(.white)
                                                        .padding()
                                                        .background(.purple)
                                                        .clipShape(Circle())
                                                })
                                                .padding()
                                                .padding(.trailing)
                                                
                                            }
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.3)
                                    }
                                    .padding(.bottom)
                                }
                                if pageNumber == 1 {
                                    ZStack {
                                        PulseView(pulseColor: .purple, showImage: false)
                                            .frame(width: 30, height: 30)
                                        Image("pointer")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .offset(CGSize(width: 0, height: 15))
                                    }
                                }
                            }
                            .background(Color(.systemGroupedBackground).ignoresSafeArea())
                        }
                    }
                        
                    
                case .lockScreen:
                    EmptyView()
                        .background(Color(.systemGroupedBackground).ignoresSafeArea())
                default:
                    EmptyView()
                        .background(Color(.systemGroupedBackground).ignoresSafeArea())
                }
                
            }
            .navigationTitle(Text("Widgets Tutorial", tableName: "WidgetTutorials"))
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

#Preview {
    WidgetsTutorialView()
}
