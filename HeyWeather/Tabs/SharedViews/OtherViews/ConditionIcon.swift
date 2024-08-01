//
//  ConditionIcon.swift
//  HeyWeather
//
//  Created by Kamyar on 10/20/21.
//

import SwiftUI

struct ConditionIcon: View {
    let iconSet: String
    let condition: WeatherCondition
    var ratio: ContentMode = .fit
    var customForegroundColor: Color? = nil
    
    var body: some View {
        if customForegroundColor != nil {
            Image(IconManager.getIconName(for: condition, iconSet: iconSet))
                .resizable()
                .renderingMode(.template)
                .foregroundColor(customForegroundColor)
                .aspectRatio(contentMode: ratio)
        }else {
            Image(IconManager.getIconName(for: condition, iconSet: iconSet))
                .resizable()
                .aspectRatio(contentMode: ratio)
        }
        
    }
}

#if DEBUG
struct ConditionIcon_Previews: PreviewProvider {
    static var previews: some View {
        ConditionIcon(iconSet: Constants.defaultIconSet, condition: WeatherCondition())
    }
}
#endif
