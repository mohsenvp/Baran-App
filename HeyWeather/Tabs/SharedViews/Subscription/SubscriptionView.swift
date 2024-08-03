//
//  SubscriptionView.swift
//  HeyWeather
//
//  Created by Kamyar on 10/30/21.
//

import SwiftUI
import AnimateText



struct SubscriptionView: View {
    @StateObject var viewModel: SubscriptionViewModel
    @EnvironmentObject var premium: Premium
    @Binding var isPresented: Bool
    @State var isDismissable: Bool = true
    
    var body: some View {
        VStack(spacing: 0){
            if (viewModel.premium.isLifetime) {
                LifeTimeUserView(viewModel: viewModel, isPresented: $isPresented)
            }else {
                SelectSubscriptionPlanView(viewModel: viewModel, isPresented: $isPresented, isDismissable: $isDismissable)
                    .isLoading($viewModel.isLoading)
            }
        }
        .dynamicTypeSize(...Constants.maxDynamicType)
        .environment(\.layoutDirection, LocalizeHelper.shared.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        .onChange(of: viewModel.premium) { newPremium in
            changePremiumEnvObject(with: newPremium)
            AppState.shared.premium = newPremium
        }.onReceive(viewModel.premiumPurchaseWasSuccessful) { _ in
            isPresented = false
        }
        .alert(isPresented: $viewModel.isAlertPresented, content: {
            switch viewModel.alertType {
            case .purchaseFailed:
                return Alerts.simpleAlert(title: Text("Purchase unsuccessful!", tableName: "Alerts"), errorMessage: Text(viewModel.failResponse?.localizedDescription ?? ""))
            case .restoreFailed:
                return Alerts.generalAlert(title: Text("Purchase restore failed!", tableName: "Alerts"), message: Text("We where unable to find a valid purchased plan in your transaction history or the plan that you purchased is expired!", tableName: "Alerts"), defaultBt: Text("OK", tableName: "Alerts")) {}
            case .restoreSuccessful:
                return Alerts.generalAlert(title: Text("Your purchase has been restored successfully!", tableName: "Alerts"), message: Text("Thank you for using HeyWeather!", tableName: "Alerts"), defaultBt: Text("OK", tableName: "Alerts")) {}
            }
        })
        .sheet(isPresented: $viewModel.isModalPresented) {
            switch viewModel.modalType {
            case .privacyPolicy:
                WebView(url: .constant(Constants.privacyURL))
            case .termsAndConditions:
                WebView(url: .constant(Constants.termURL))
            }
        }
    }
    
    
}
struct LifeTimeUserView: View {
    @StateObject var viewModel: SubscriptionViewModel
    @Binding var isPresented: Bool
    
    @State var crownOpacity = 0.0
    @State var footerOpacity = 0.0
    @State var helloText = ""
    
    @State var text1 = ""
    @State var text2 = ""
    @State var text3 = ""
    @State var text4 = ""
    @State var text5 = ""
    @State var text6 = ""
    @State var text7 = ""
    @State var text8 = ""
    @State var text9 = ""
    @State var text10 = ""
    
    var body: some View {
        ZStack{
            Color.accentColor.edgesIgnoringSafeArea(.all)
            ScrollView(showsIndicators: false){
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            isPresented.toggle()
                        } label: {
                            Image(systemName: Constants.SystemIcons.xmark)
                        }
                        .padding(40)
                        .accentColor(.white)
                    }
                    Image(Constants.Icons.bestUserCrown)
                        .opacity(crownOpacity)
                        .animation(Constants.isWidthCompact ? nil : .linear(duration: 1), value: crownOpacity)
                        .animation(Constants.isWidthCompact ? nil : .spring(), value: crownOpacity)
                        .onAppear {
                            crownOpacity = 1
                        }
                    
                    if Constants.motionReduced || LocalizeHelper.shared.currentLanguage.isRTL {
                        Text(helloText)
                            .fonted(size: 48, weight: .ultraLight)
                            .foregroundColor(.white)
                    }else {
                        AnimateText<ATHangEffect>($helloText, type: .letters)
                            .fonted(size: 48, weight: .ultraLight)
                            .foregroundColor(.white)
                    }
                    
                    
                    Spacer(minLength: 40)
                    
                    VStack(alignment: .leading){
                        if Constants.motionReduced || LocalizeHelper.shared.currentLanguage.isRTL {
                            Group {
                                Text(text1)
                                Text(text2)
                                Text(text3)
                                Text(text4)
                                Text(text5)
                            }
                            .frame(maxWidth: Constants.screenWidth, alignment: .leading)
                            .padding(.leading, 60)
                            .fonted(size: 36, weight: .ultraLight)
                            .foregroundColor(.white)
                        }else {
                            Group {
                                AnimateText<ATChimeBellEffect>($text1, type: .letters)
                                AnimateText<ATChimeBellEffect>($text2, type: .letters)
                                AnimateText<ATChimeBellEffect>($text3, type: .letters)
                                AnimateText<ATChimeBellEffect>($text4, type: .letters)
                                AnimateText<ATChimeBellEffect>($text5, type: .letters)
                            }
                            .frame(maxWidth: Constants.screenWidth, alignment: .leading)
                            .padding(.leading, 60)
                            .fonted(.largeTitle, weight: .ultraLight)
                            .foregroundColor(.white)
                        }
                    }
                    
                    
                    Spacer(minLength: 30)
                    
                    VStack(alignment: .trailing){
                        if Constants.motionReduced || LocalizeHelper.shared.currentLanguage.isRTL {
                            Group {
                                Text(text6)
                                Text(text7)
                                Text(text8)
                                Text(text9)
                                Text(text10)
                            }
                            .frame(maxWidth: Constants.screenWidth, alignment: .trailing)
                            .fonted(.largeTitle, weight: .ultraLight)
                            .padding(.trailing, 60)
                            .foregroundColor(.white)
                        }else {
                            Group {
                                AnimateText<ATBlurEffect>($text6, type: .letters)
                                AnimateText<ATBlurEffect>($text7, type: .letters)
                                AnimateText<ATBlurEffect>($text8, type: .letters)
                                AnimateText<ATBlurEffect>($text9, type: .letters)
                                AnimateText<ATBlurEffect>($text10, type: .letters)
                            }
                            .frame(maxWidth: Constants.screenWidth, alignment: .trailing)
                            .fonted(.largeTitle, weight: .ultraLight)
                            .padding(.trailing, 60)
                            .foregroundColor(.white)
                        }
                        
                    }
                    
                    Group {
                        Divider().padding(20)
                        Text("SUBSCRIPTION.LONG.TEXT", tableName: "Premium")
                            .fonted(.caption, weight: .regular)
                            .frame(alignment: .center)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                        
                        HStack(alignment: .center, spacing: 0) {
                            Button(String(localized: "Terms and Conditions", table: "General")) {
                                viewModel.openModal(type: .termsAndConditions)
                            }
                            Spacer()
                            
                            Button(String(localized: "Privacy Policy", table: "General")) {
                                viewModel.openModal(type: .privacyPolicy)
                            }
                        }
                        .padding(40)
                        .accentColor(.white)
                    }
                    .opacity(footerOpacity)
                    .animation(.linear(duration: Constants.motionReduced ? 0 : 1), value: footerOpacity)
                    
                    
                }
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    helloText = String(localized: "Hello Master", table: "Premium")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    text1 = String(localized: "You are the", table: "Premium")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    text2 = String(localized: "ultimate user", table: "Premium")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    text3 = String(localized: "that an app", table: "Premium")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                    text4 = String(localized: "can get in", table: "Premium")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    text5 = String(localized: "this world", table: "Premium")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5){
                    text6 = String(localized: "You will always", table: "Premium")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                    text7 = String(localized: "be welcomed", table: "Premium")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.5){
                    text8 = String(localized: "on the first class", table: "Premium")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                    text9 = String(localized: "seat of", table: "Premium")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.5){
                    text10 = "HeyWeather"
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 6){
                    footerOpacity = 1
                }
            }
        }
    }
}
struct SelectSubscriptionPlanView: View {
    @StateObject var viewModel: SubscriptionViewModel
    @Binding var isPresented: Bool
    @Binding var isDismissable: Bool
    @State var closeButtonOpacity: CGFloat = 1.0
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing : 0)  {
                HStack {
                    Spacer()
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: Constants.SystemIcons.xmark)
                    }
                    .padding(20)
                    .accentColor(.init(.label))
                    .opacity(closeButtonOpacity)
                    .animation(.linear(duration: 0.2), value: closeButtonOpacity)
                }
                
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        Text("HeyWeather").fonted(.subheadline, weight: .semibold).foregroundColor(.init(.secondary))
                        Text("Premium Plan", tableName: "Premium")
                            .fonted(.title2, weight: .bold)
                            .foregroundColor(.init(.label))
                            .padding(.trailing, 120)
                        
                    }.padding(.top, 20)
                        .accessibilityElement(children: .combine)
                    
                    HStack {
                        Spacer()
                        Image(Constants.Icons.logoart)
                            .resizable()
                            .foregroundColor(Constants.accentColor)
                            .frame(width: 120, height: 120)
                            .accessibilityHidden(true)
                            .unredacted()
                    }
                    
                }
                .padding(.horizontal, 20)
                
                if viewModel.premium.isPremium {
                    PremiumRow(premium: viewModel.premium)
                }else {
                    BenefitsRow(benefits: viewModel.benefits)
                }
                
                Spacer()
                
                VStack(spacing : 0)  {
                    
                    
                    ForEach(viewModel.plans.filter { $0.type == .freetry }) { plan in
                        Button {
                            viewModel.buyProduct(product: plan)
                        } label: {
                            PlanItem(plan: plan)
                        }
                    }
                    
                    OrView()
                    
                    ForEach(viewModel.plans.filter { $0.type == .premium || $0.type == .familypremium }) { plan in
                        Button {
                            viewModel.buyProduct(product: plan)
                        } label: {
                            PlanItem(plan: plan)
                        }
                    }
                    
                    ForEach(viewModel.plans.filter { $0.type == .lifetime }) { plan in
                        Button {
                            viewModel.buyProduct(product: plan)
                        } label: {
                            PlanItem(plan: plan)
                        }
                    }
                    
                }
                .padding(.top, 6)
                .redacted(isRedacted: viewModel.isRedacted)
            }
            
            
            Divider().padding(20)
            
            Text("SUBSCRIPTION.LONG.TEXT", tableName: "Premium")
                .fonted(.caption, weight: .regular)
                .frame(alignment: .center)
                .padding(.horizontal, 20)
            
            Button {
                viewModel.restorePurchases()
            } label: {
                RestoreButton()
            }
            
            HStack () {
                Button(String(localized: "Terms and Conditions", table: "General")) {
                    viewModel.openModal(type: .termsAndConditions)
                }
                Spacer()
                Button(String(localized: "Privacy Policy", table: "General")) {
                    viewModel.openModal(type: .privacyPolicy)
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 8)
            
        }
        .interactiveDismissDisabled(!isDismissable || viewModel.isLoading)
        .onAppear {
            if !isDismissable {
                closeButtonOpacity = 0.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: {
                    self.isDismissable = true
                    self.closeButtonOpacity = 0.3
                })
            }
        }
        
    }
  
    
    private struct PlanItem: View {
        var plan: AppPlan
        let gradient = Gradient(colors: [
            .init(.label),
            .init(.label).opacity(0.4),
            .init(.label).opacity(0.4),
            .init(.label).opacity(0.4),
            Constants.accentColor,
            Constants.accentColor
        ])
        var body: some View {
            
            HStack{
                
                VStack(alignment: .leading, spacing : 0){
                    Text(LocalizedStringKey(plan.title))
                        .fonted(.title3, weight: .semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 2)
                    
                    
                    if plan.type == .freetry {
                        Group {
                            Text(LocalizedStringKey(plan.extraDetails ?? "")) + Text(" " + plan.formattedPrice + Constants.slash) + Text(LocalizedStringKey(plan.perWhat))
                        }
                        .fonted(.caption, weight: .medium)
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                    }else {
                        Text(LocalizedStringKey(plan.extraDetails ?? ""))
                            .fonted(.caption, weight: .medium)
                            .opacity(0.5)
                            .multilineTextAlignment(.leading)
                    }
                    
                }
                .accessibilityElement(children: .combine)
                .padding(.leading, 14)
                .padding(.vertical, 10)
                .foregroundColor(.init(.label))
                
                Spacer()
                if plan.type == .freetry {
                    Text("FREE!", tableName: "Premium")
                        .fonted(.title3 , weight: .bold)
                        .foregroundColor(Constants.accentColor)
                        .padding(.trailing, 14)
                }else {
                    Group {
                        Text(plan.formattedPrice) + Text(plan.type == .lifetime ? "" : Constants.spaceSlashSpace) + Text(plan.type == .lifetime ? "" : LocalizedStringKey(plan.perWhat))
                    }
                    .fonted(.headline, weight: .medium)
                    .foregroundColor(Constants.accentColor)
                    .padding(.trailing, 14)
                }
                
                
            }
            
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            gradient: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .accessibilityElement(children: .combine)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }
    
    private struct RestoreButton: View {
        
        var body: some View {
            HStack{
                VStack(alignment: .leading){
                    Group {
                        Text("Subscribed Before?", tableName: "Premium")
                            .fonted(.footnote, weight: .thin)
                        
                        Text("Restore Purchase", tableName: "Premium")
                            .fonted(.body, weight: .medium)
                    }.foregroundColor(Constants.accentColor)
                    
                }
                .accessibilityElement(children: .combine)
                .padding(.vertical, 4)
                .foregroundColor(.init(.label))
                Spacer()
            }
            .accessibilityElement(children: .combine)
            .padding(.horizontal, 20)
        }
    }
    
    private struct BenefitsRow: View {
        @Environment(\.dynamicTypeSize) var typeSize
        
        var benefits: [Text]
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Discover limitless possibilities with Premium!:", tableName: "Premium")
                        .fonted(.caption, weight: .regular)
                        .foregroundColor(.init(.secondary))
                    ForEach(0..<benefits.count, id: \.self) { index in
                        HStack(spacing : 8) {
                            Image(Constants.Icons.premium)
                                .resizable()
                                .scaledToFit()
                                .frame(width: typeSize < .xxxLarge ? 18 : 24, height: typeSize < .xxxLarge ? 18 : 24)
                                .foregroundColor(Color.accentColor)
                            
                            benefits[index]
                                .fonted(.body, weight: .medium)
                        }
                    }
                }
                .padding(.leading, 20)
                Spacer()
            }
            .accessibilityElement(children: .combine)
        }
    }
    
    private struct OrView: View {
        var body: some View {
            HStack {
                Rectangle()
                    .fill(Color.secondary)
                    .frame(height: 1)
                Text("or", tableName: "General").foregroundColor(Color.secondary)
                    .fonted(.caption, weight: .regular)
                    .unredacted()
                    .accessibilityHidden(true)
                Rectangle()
                    .fill(Color.secondary)
                    .frame(height: 1)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
        }
    }
    
    private struct PremiumRow: View {
        @State var premium: Premium
        var body: some View {
            HStack {
                Image(Constants.Icons.premium)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .padding(20)
                    .accessibilityHidden(true)
                VStack(alignment: .leading) {
                    Text("You Are Premium", tableName: "Premium")
                        .fonted(.title3, weight: .semibold)
                    if premium.isPremium {
                        Group {
                            (premium.autoRenew ? Text("Renew at", tableName: "Premium") : Text("Expire at", tableName: "Premium"))
                            +
                            Text(Constants.colonAndSpace) +
                            (premium.isLifetime ? Text("Never", tableName: "Premium") : Text(premium.expireAt).fontWeight(.medium))
                            
                        }
                        .fonted(.callout, weight: .light)
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                        .opacity(Constants.secondaryOpacity)
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .background(Constants.accentGradient)
            .cornerRadius(20)
            .padding(.horizontal, 20)
        }
    }
}



// MARK: - View Functions

extension SubscriptionView {
    func changePremiumEnvObject(with newPremium: Premium) {
        premium.autoRenew = newPremium.autoRenew
        premium.expireAt = newPremium.expireAt
        premium.isPremium = newPremium.isPremium
        premium.expireAtTimestamp = newPremium.expireAtTimestamp
    }
}


#if DEBUG
struct SubscriptionView_Preview: PreviewProvider {
    static var previews: some View {
        SubscriptionViewPreviewsContainer()
    }
}
#endif

struct SubscriptionViewPreviewsContainer : View {
    let premium = Premium()
    @State var isPresented: Bool = false
    
    var body: some View {
        SubscriptionView(viewModel: .init(premium: premium), isPresented: $isPresented, isDismissable: true)
            .environmentObject(premium)
    }
}
