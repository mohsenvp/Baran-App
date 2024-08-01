//
//  SunDetailsViewModel.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/27/23.
//

import Foundation

class SunDetailsViewModel: ObservableObject {
    let suns: [SunDataModel]

    
    init(suns: [SunDataModel]) {
        self.suns = suns
    }
}
