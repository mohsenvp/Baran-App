//
//  AdaptiveStack.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/8/23.
//

import SwiftUI

public struct AdaptiveStack<Content: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    public typealias ConditionHandler = (UserInterfaceSizeClass?,
                                         DynamicTypeSize) -> Bool
    
    private let horizontalAlignment: HorizontalAlignment
    private let horizontalSpacing: CGFloat?
    private let verticalAlignment: VerticalAlignment
    private let verticalSpacing: CGFloat?
    private let condition: ConditionHandler
    private let content: Content
    
    public init(horizontalAlignment: HorizontalAlignment = .center,
                horizontalSpacing: CGFloat? = nil,
                verticalAlignment: VerticalAlignment = .center,
                verticalSpacing: CGFloat? = nil,
                condition: @escaping ConditionHandler,
                @ViewBuilder content: () -> Content) {
        self.horizontalAlignment = horizontalAlignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalAlignment = verticalAlignment
        self.verticalSpacing = verticalSpacing
        self.condition = condition
        self.content = content()
    }
    
    public var body: some View {
        if condition(horizontalSizeClass, dynamicTypeSize) {
            VStack(alignment: horizontalAlignment, spacing: verticalSpacing) { content }
        } else {
            HStack(alignment: verticalAlignment, spacing: horizontalSpacing) { content }
        }
      }
}
