//
//  InfiniteImageView2.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 5/23/23.
//

import SwiftUI

struct InfiniteImageView: View {
    @State var offset: CGFloat = 0.0

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: -0.1){
                Image(Constants.Icons.onBoardingWidgets)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 1134)
                Image(Constants.Icons.onBoardingWidgets)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 1134)
            }
            .offset(x: offset)
            .animation(.linear(duration: 14).repeatForever(autoreverses: false), value: offset)
            .onAppear {
                offset = -1134
            }
        }
        .allowsHitTesting(false)
        .frame(height: 360)
        .environment(\.layoutDirection, .leftToRight)
         
    }
}

struct InfiniteImageView_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteImageView()
    }
}
