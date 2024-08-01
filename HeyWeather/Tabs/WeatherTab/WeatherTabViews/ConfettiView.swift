//
//  ConfettiView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 5/31/23.
//

import SwiftUI
import ConfettiSwiftUI

struct ConfettiView: View {
    @State private var confettiCounter: Int = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
            Blur().edgesIgnoringSafeArea(.all)
            VStack {
                Image(Constants.Icons.bestUserCrown)
                Text("HOORAY!", tableName: "Premium")
                    .fonted(.title, weight: .ultraLight)
                Text("You Are Premium", tableName: "Premium")
                    .fonted(.largeTitle, weight: .black)
                Text("Thank you for suporting HeyWeather\nWe really appreciate it", tableName: "Premium")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .foregroundColor(.white)
            .confettiCannon(counter: $confettiCounter, num: 100, confettiSize: 10, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 300 , repetitions: 2, repetitionInterval: 1)
            .onAppear {
                if !Constants.motionReduced {
                    confettiCounter += 1
                }
            }
        }.unredacted()
    }
}

struct ConfettiView_Previews: PreviewProvider {
    static var previews: some View {
        ConfettiView()
    }
}
