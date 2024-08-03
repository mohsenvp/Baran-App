//
//  AppSettingAgent.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 12/2/23.
//

import Foundation
import SwiftyJSON

struct AppSettingAgent {
    
    static func sync(){
        Task {
            do {
                let appSettings: JSON = AppSettings().toServerJson()
                _ = try await Repository().sendUserConfig(json: appSettings)
            }catch {
                
            }
        }
    }
    
}
