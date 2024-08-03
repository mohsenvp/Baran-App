//
//  DataModelSheet.swift
//  HeyWeather WatchOS
//
//  Created by Mohammad Yeganeh on 8/8/23.
//

import SwiftUI

struct DataModeSheet: View {
    var selectedMode: WatchDataMode
    var onModeSelected: (WatchDataMode) -> Void
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                ForEach(WatchDataMode.allCases, id: \.self) { mode in
                    Button {
                        onModeSelected(mode)
                    } label: {
                        HStack {
                            mode.title
                            Spacer(minLength: 0)
                            Image(mode.icon)
                                .renderingMode(.template)
                                .resizable()
                                .foregroundStyle(.primary)
                                .frame(width: 20, height: 20)

                        }
                        .padding(.horizontal)
                    }

                }
            }
        }
      
    }
}
