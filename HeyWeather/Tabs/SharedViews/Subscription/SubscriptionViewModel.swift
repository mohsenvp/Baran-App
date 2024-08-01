//
//  SubscriptionViewModel.swift
//  HeyWeather
//
//  Created by Kamyar on 10/30/21.
//

import Foundation
import SwiftUI

class SubscriptionViewModel: ObservableObject {
    let premiumPurchaseWasSuccessful = Constants.premiumPurchaseWasSuccessfulPublisher
    
    @Published var plans: [AppPlan] = []
    @Published var premium: Premium
    @Published var isLoading: Bool = false
    @Published var loadingScale = 0.0
    @Published var isRedacted = true
    @Published var restoreError: RestoreError?
    @Published var failResponse: NetworkFailResponse?
    
    @Published var modalType: SubscriptionModalType = .privacyPolicy
    @Published var isModalPresented: Bool = false
    
    @Published var alertType: SubscriptionAlertType = .purchaseFailed
    @Published var isAlertPresented = false
    
    
    var nonLifetimePlans: [AppPlan] {
        get {
            return plans.filter { plan in
                return plan.id != "Lifetime_Premium_HeyWeather"
            }
        }
    }
    var lifetimeplan: AppPlan {
        get {
            return plans.filter { plan in
                return plan.id == "Lifetime_Premium_HeyWeather"
            }.first ?? AppPlan()
        }
    }
    
    let benefits = [
        Text("Unlock all widgets, styles, and customization.", tableName: "Premium"),
        Text("Get premium forecast sources for accurate updates.", tableName: "Premium"),
        Text("Stay updated with live precipitation activity.", tableName: "Premium"),
        Text("Explore forecast layers on maps & radar.", tableName: "Premium"),
        Text("Enjoy extended 15-day and 360-hour forecasts.", tableName: "Premium"),
        Text("Access AQI forecast and widgets.And much more!", tableName: "Premium")

    ]
    func logView() {
        let viewTitle = Constants.ViewTitles.settingsTab
        EventLogger.logViewEvent(view: viewTitle)
    }
    
    func buyProduct(product: AppPlan) {
        self.isLoading = true
        AppStoreAgent.buyPlan(plan: product) { isSuccessful, failResponse in
            if isSuccessful {
                self.checkPurchase(isRestoring: false)
            }else {
                self.failResponse = failResponse
                self.alertType = .purchaseFailed
                self.isAlertPresented.toggle()
                self.isLoading = false
            }
        }
    }
    
    func restorePurchases() {
        self.isLoading = true
        AppStoreAgent.restorePurchases { isSuccessful, restoreError in
            if isSuccessful {
                self.checkPurchase(isRestoring: true)
                return
            }
            
            if let error = restoreError {
                self.restoreError = error
            }
            self.isLoading = false
            self.alertType = .restoreFailed
            self.isAlertPresented.toggle()
        }
    }
    
    private func getPlans() {
        AppStoreAgent.getPlans { plans in
            self.plans = plans
            self.isRedacted = false
        } failResponseCompletionHandler: { failResponse in
            self.failResponse = failResponse
        }
    }
    
    private func checkPurchase(isRestoring: Bool) {
        Task { [weak self] in
            do {
                let premium = try await Repository().checkPremiumStatus(verifyReceipt : true)
                self?.isLoading = false
                if isRestoring, !premium.isPremium{
                    self?.alertType = .restoreFailed
                    self?.isAlertPresented.toggle()
                }
                self?.premium = premium
                DispatchQueue.main.async {
                    if premium.isPremium {
                        NotificationCenter.default.post(name: NSNotification.Name(Constants.premiumPurchaseWasSuccessfulName), object: nil)
                        NavigationUtil.popToRootView()
                        AppState.shared.navigateToTab = .weather
                    }
                }
            } catch {
                self?.failResponse = error as? NetworkFailResponse
                self?.alertType = .restoreFailed
                self?.isAlertPresented = true
                self?.isLoading = false
            }
        }
    }
    
    func openModal(type: SubscriptionModalType){
        modalType = type
        isModalPresented = true
    }
    

    init(premium: Premium) {
        
        var p0 = AppPlan()
        p0.id = "Lifetime_Premium_HeyWeather"
        p0.type = .lifetime
        p0.title = String(localized: "Lifetime Premium", table: "Premium")
        p0.extraDetails = String(localized: "One payment, lifetime access", table: "Premium")
        
        var p1 = AppPlan()
        p1.id = "HeyWeather_1"
        p1.type = .familypremium
        p1.title = String(localized: "Family Premium", table: "Premium")
        p1.extraDetails = String(localized: "Subscribe and share with family!", table: "Premium")
        
        var p2 = AppPlan()
        p2.id = "HeyWeather_2"
        p2.type = .freetry
        p2.title = String(localized: "Try Premium", table: "Premium")
        p2.extraDetails = String(localized: "After free trial, auto-renewal at", table: "Premium")
        
        var p3 = AppPlan()
        p3.id = "HeyWeather_3"
        p3.type = .premium
        p3.title = String(localized: "Premium", table: "Premium")
        p3.extraDetails = String(localized: "Auto-renews each", table: "Premium")
        
        self.plans = [p0, p1, p2, p3]
        self.premium = premium
        self.getPlans()
    }
    
}
