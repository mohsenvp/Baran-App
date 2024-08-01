//
//  SnackBar.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 10/29/23.
//

import SwiftUI

struct Snackbar: View {
    
    @Binding var isShowing: Bool
    private let presenting: AnyView
    private let title: Text
    private let actionText: Text
    private let action: (() -> Void)?
    private let viewOffset: CGFloat = 6
    private let dismissOnTap: Bool
    private let dismissAfter: Double?
    private let extraBottomPadding: CGFloat
    private let isShowingYesButton: Bool
    @State var done: Bool = false
    
    internal init<Presenting>(isShowing: Binding<Bool>, presenting: Presenting, title: Text, actionText: Text, action: (() -> Void)? = nil, dismissOnTap: Bool = true, dismissAfter: Double? = 4, extraBottomPadding: CGFloat = 0,
                              isShowingYesButton: Bool) where Presenting: View {
        _isShowing = isShowing
        self.presenting = AnyView(presenting)
        self.title = title
        self.actionText = actionText
        self.action = action
        self.dismissOnTap = dismissOnTap
        self.dismissAfter = dismissAfter
        self.extraBottomPadding = extraBottomPadding
        self.isShowingYesButton = isShowingYesButton
    }
    
    internal var body: some View {
        ZStack {
            presenting
            
            VStack {
                Spacer()
                snackbar
            }
        }
    }
    
    private var snackbar: some View {
        VStack {
            Spacer()
            if isShowing {
                HStack {
                    
                    Button {
                        withAnimation {
                            self.isShowing = false
                        }
                    } label: {
                        Image(systemName: Constants.SystemIcons.xmark)
                            .fonted(.footnote)
                    }
                    .accentColor(textColor)
                        title
                            .fonted(.subheadline, weight: .medium)
                            .foregroundColor(textColor)
                
                    
                    Spacer()
                    if isShowingYesButton {
                        Button {
                            action?()
                            done = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                withAnimation {
                                    isShowing = false
                                }
                                done = false
                            })
                        } label: {
                            ZStack {
                                actionText
                                    .fonted(.callout, weight: .medium)
                                    .opacity(done ? 0 : 1)
                                    .animation(.linear, value: done)
                                
                                Image(systemName: Constants.SystemIcons.checkmarkCircle)
                                    .opacity(done ? 1 : 0)
                                    .animation(.linear, value: done)
                                    .fonted(.title3, weight: .bold)
                                    .complexModifier({ v in
                                        if #available(iOS 17.0, *) {
                                            v.symbolEffect(.bounce, value: done)
                                        }
                                    })
                            }
                        }
                    }
                    
                }
                .padding(.top, 10)
                .padding(.horizontal, 14)
                .padding(.bottom, 10)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: Constants.weatherTabRadius))
                .padding(.horizontal)
                .padding(.bottom, 90 + extraBottomPadding)
                .animation(.bouncy)
                .transition(.move(edge: .bottom))
                .onAppear {
                    if let dismissAfter = dismissAfter {
                        DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
                            if !done {
                                withAnimation {
                                    self.isShowing = false
                                }
                            }
                        }
                    }
                }
                .onTapGesture {
                    if dismissOnTap {
                        isShowing = false
                    }
                }
            }
            
        }
        .ignoresSafeArea()
        
    }
    
    private var textColor: Color = .init(.label)
}

extension View {
    func snackbar(isShowing: Binding<Bool>, title: Text, actionText: Text, dismissOnTap: Bool = true, dismissAfter: Double? = 4,extraBottomPadding: CGFloat = 0, action: (() -> Void)? = nil, isShowingYesButton: Bool = true) -> some View {
        Snackbar(isShowing: isShowing, presenting: self, title: title, actionText: actionText, action: action, dismissOnTap: dismissOnTap, dismissAfter: dismissAfter, extraBottomPadding: extraBottomPadding, isShowingYesButton: isShowingYesButton)
    }
}
