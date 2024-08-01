//
//  WatchState.swift
//  HeyWeather WatchOS
//
//  Created by Mohammad Yeganeh on 9/9/23.
//

import Foundation
class WatchState: ObservableObject {
    
    @Published var shouldReload: Bool = false

    static let shared = WatchState()
}
