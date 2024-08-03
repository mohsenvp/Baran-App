//
//  AppPlan.swift
//  WeatherApp
//
//  Created by RezaRg on 9/14/20.
//

import Foundation
import StoreKit
import SwiftyJSON

struct AppPlan : Codable, Identifiable {
    var id: String = "1_Month"
    var duration : String = ""
    var title: String = ""
    var extraDetails: String? = ""
    var formattedPrice : String = ""
    var price : Double = 0
    var pricePerMonth : Double = 0
    var formattedPricePerMonth: String = "0"
    var perWhat: String = "year"
    var type : AppPlanType = .none
    var discount: Discount?
    
    init(json: JSON) {
        self.id = json["id"].string!
        if let _ = json["discount"].dictionary {
            self.discount = Discount(json: json["discount"])
        }
    }
    
    init() {}
    
    mutating func fillDetails(product: SKProduct) {
        
        formattedPrice = product.localizedPrice!
        
        let numUnits = product.subscriptionPeriod?.numberOfUnits ?? -1
        let period:String = {
            switch product.subscriptionPeriod?.unit {
            case .day: return (numUnits > 1) ? String(localized: "days", table: "General") :  String(localized: "day", table: "General")
            case .week: return String(localized: "week", table: "General")
            case .month: return (numUnits > 1) ? String(localized: "Months", table: "General") : String(localized: "Month", table: "General")
            case .year: return String(localized: "year", table: "General")
            case .none: return ""
            case .some(_): return ""
            }
        }()
        
        if let numUnits = product.subscriptionPeriod?.numberOfUnits {
            duration = String(numUnits) + Constants.space + period
            perWhat = (numUnits > 1 ? String(numUnits) : "") + period
        }else {
            duration = "lifetime"
        }
        
        


        
        if (product.introductoryPrice?.subscriptionPeriod) != nil {
            title = String(localized: "Try Premium", table: "Premium")
            extraDetails = String(localized: "After free trial, auto-renewal at", table: "Premium")
            type = .freetry
        } else if product.productIdentifier.contains("Lifetime") {
            title = String(localized: "Lifetime Premium", table: "Premium")
            extraDetails = String(localized: "One payment, lifetime access", table: "Premium")
            type = .lifetime
        } else if product.isFamilyShareable {
            title = String(localized: "Family Premium", table: "Premium")
            extraDetails = String(localized: "Subscribe and share with family!", table: "Premium")
            type = .familypremium
        }else {
            title = String(localized: "Premium",table: "Premium")
            //todo - didnt localized since design gonna change
            extraDetails = "Auto-renews each \(perWhat) until cancelled"
            type = .premium
        }
        
        
        let period1 : Int = {
            switch product.subscriptionPeriod?.unit {
            case .month: return 1
            case .year: return 12
            default : return 0
            }
        }()
        let numUnits1 = product.subscriptionPeriod?.numberOfUnits ?? 0
        let pricePerMonth = Double(truncating: product.price) / Double(numUnits1 * period1)
        

        price = Double(truncating: product.price)
        
        let currencySymbol = product.priceLocale.currencySymbol
        formattedPricePerMonth = (currencySymbol ?? "$") + String(format: "%.2f", pricePerMonth)
    }
    
    private static func unitName(unitRawValue:UInt) -> String {
        switch unitRawValue {
        case 0: return "days"
        case 1: return "week"
        case 2: return "months"
        case 3: return "years"
        default: return ""
        }
    }
}

struct Discount: Codable, Identifiable {
    var id: String
    var discountPercent: Int
    var endDateTimeStamp: Double
    var formattedPrice : String
    
    init(json: JSON) {
        self.id = json["id"].string!
        self.discountPercent = json["discount_percent"].int!
        self.endDateTimeStamp = json["expire_at"].double!
        self.formattedPrice = "$1.99"
    }
    // MARK: Test Init
    init() {
        self.id = "Lifetime_Premium_HeyWeather"
        self.discountPercent = 25
        self.endDateTimeStamp = 1651332822
        self.formattedPrice = "$1.99"
    }
}


enum AppPlanType : String, Codable {
    case none
    case lifetime
    case freetry
    case premium
    case familypremium
}
