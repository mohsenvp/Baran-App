//
//  SubscriptionViewPresentationKey.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 5/9/23.
//

import SwiftUI
//todo move this to AppState
private struct SubscriptionViewPresentationKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
    
}


extension EnvironmentValues {
    var isSubscriptionViewPresented: Binding<Bool> {
        get { self[SubscriptionViewPresentationKey.self] }
        set { self[SubscriptionViewPresentationKey.self] = newValue }
    }
    
}
