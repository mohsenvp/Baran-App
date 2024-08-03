//
//  Redacted.swift
//  HeyWeather
//
//  Created by Kamyar on 1/11/22.
//

import Foundation
import SwiftUI

private struct RedactedModifier: ViewModifier {
    var isRedacted: Bool
    var supportInvalidation: Bool
    func body(content: Content) -> some View {
        if #available(iOS 17, *), supportInvalidation{
            content
                .redacted(reason: isRedacted ? .invalidated : [])
                .disabled(isRedacted)
        }else {
            content
                .redacted(reason: isRedacted ? .placeholder : [])
                .disabled(isRedacted)
        }
    }
}


extension View {
    func redacted(isRedacted: Bool, supportInvalidation: Bool = true) -> some View {
        return self.modifier(RedactedModifier(isRedacted: isRedacted, supportInvalidation: supportInvalidation))
    }
}
