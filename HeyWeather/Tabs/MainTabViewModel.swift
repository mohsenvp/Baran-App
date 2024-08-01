//
//  MainTabViewModel.swift
//  HeyWeather
//
//  Created by Kamyar on 10/27/21.
//

import Foundation
import SwiftUI

class MainTabViewModel: ObservableObject {
    @Published var premium: Premium = Premium()
    @Published var isSubscriptionViewPresented: Bool = false
    @Published var failResponse: NetworkFailResponse?
    @Published var currentPhase: ScenePhase = .active
    
    init() {
        checkPremiumOnLaunch()
    }
    
    func updateCurrentPhaseToNewPhase(_ newPhase : ScenePhase) {
        if (currentPhase == .background && newPhase == .active) {
            checkPremiumOnLaunch()
        }
        if (currentPhase == .active && (newPhase == .inactive || newPhase == .background)) {
            AppState.shared.syncWithWatch()
        }
        if (newPhase == .background || newPhase == .active) {
            currentPhase = newPhase
        }
    }
    
    func checkPremiumOnLaunch() {

        Task { [weak self] in
            self?.premium = try await Repository().checkPremiumStatus()
            AppState.shared.premium = self?.premium ?? .init()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            AppState.shared.syncWithWatch()
        }
        
    }
}
