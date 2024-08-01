//
//  AstronomyDetailsViewModel.swift
//  HeyWeather
//
//  Created by Kamyar on 12/8/21.
//

import Foundation

class MoonDetailsViewModel: ObservableObject {
    let moons: [MoonDataModel]
    @Published var selectedMoon: MoonDataModel
    
    var selectedDate: Date {
        let now = Date()
        let index = moons.firstIndex(of: selectedMoon)!
        return now.addingTimeInterval(TimeInterval(index * 86400))
    }
    
    func selectMoon(_ moon: MoonDataModel) {
        self.selectedMoon = moon
    }
    
    
    init(moons: [MoonDataModel]) {
        self.moons = moons
        self.selectedMoon = moons.first!
    }
}
