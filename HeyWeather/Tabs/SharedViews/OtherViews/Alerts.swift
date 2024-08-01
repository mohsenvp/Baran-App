//
//  ChooseLanguageAlert.swift
//  HeyWeather
//
//  Created by Kamyar on 10/26/21.
//

import Foundation
import SwiftUI


struct Alerts {
    
    static func freePlanMaxCitiesAlert(onDefaultTapped: @escaping () -> Void) -> Alert {
        return generalAlert(title: nil,
                            message: Text("You can add only one city in a free plan, to add more cities & enjoy the full-featured app please subscribe to a plan.", tableName: "Alerts"),
                            defaultBt: Text("GO PREMIUM!", tableName: "Widgets"), onDefaultTapped: onDefaultTapped)
    }
    
    static func maxCitiesAlert() -> Alert {
        return generalAlert(title: Text("City Limit", tableName: "Alerts"),
                            message: Text("You've reached the maximum numbers of cities, you have to remove a city to add another one.", tableName: "Alerts"),
                            defaultBt: Text("OK", tableName: "Alerts"), onDefaultTapped: {})
    }
    
    
    static func generalAlert(title: Text?, message: Text?, defaultBt: Text, cancelBtn: Text? = nil,onDefaultTapped: @escaping () -> Void) -> Alert {
        return Alert(title: title ?? .init(""),
                     message: message ?? .init(""),
                     primaryButton: .default(defaultBt) { onDefaultTapped() },
                     secondaryButton: cancelBtn != nil ? .cancel(cancelBtn!) : .cancel())
    }
    
    
    static func simpleAlert(title: Text, errorMessage: Text? = .init("")) -> Alert {
        return Alert(title: title,
                     message: errorMessage ?? .init(""),
                     primaryButton: .default(Text("OK", tableName: "Alerts")) { },
                     secondaryButton: .cancel())
    }
    
}
