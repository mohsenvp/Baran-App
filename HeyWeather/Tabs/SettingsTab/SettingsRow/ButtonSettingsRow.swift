//
//  ButtonSettingsRow.swift
//  HeyWeather
//
//  Created by Kamyar on 11/16/21.
//

import SwiftUI
import MessageUI

struct ButtonSettingsRow: View {
    let rowType: SettingsRowType
    let canSendMail = MFMailComposeViewController.canSendMail()
    @State private var modalType: ModalType
    @State private var isModalPresented: Bool = false
    @State private var isActionSheetPresented: Bool = false
    @State private var mailType: Constants.MailType = .featureRequest
    @State private var isAlertPresented: Bool = false
    
    var body: some View {
        VStack {
            Button {
                self.onTap()
            } label: {
                SettingsRowLabel(rowType: rowType)
            }
            .sheet(isPresented: $isModalPresented) {
                switch modalType {
                case .mail:
                    MailView(mailType: $mailType)
                case .webView:
                    WebView(url: .constant(Constants.aboutUsURL))
                case .share:
                    ActivityViewController(activityItems: [URL(string: Constants.appStoreURL)!])
                }
            }
            
            .actionSheet(isPresented: $isActionSheetPresented) {
                return ActionSheet(title: Text("Contact us", tableName: "SettingsTab"), message: Text("Please choose the proper contact form.", tableName: "SettingsTab"), buttons: [
                    .default(Text("Feature Request", tableName: "SettingsTab"), action: onSendMailTapped(mailType: .featureRequest)),
                    .default(Text("Bug Report", tableName: "SettingsTab"), action: onSendMailTapped(mailType: .bugReport)),
                    .default(Text("Purchase Problem", tableName: "SettingsTab"), action: onSendMailTapped(mailType: .purchaseProblem)),
                    .default(Text("General", tableName: "SettingsTab"), action: onSendMailTapped(mailType: .general)),
                    .default(Text("Help HeyWeather Translation", tableName: "SettingsTab"), action: onSendMailTapped(mailType: .helpToTranslate)),
                    .cancel()
                ]
                )}
            .alert(isPresented: $isAlertPresented) {
                Alert(title: Text("Failed to send mail", tableName: "Alerts"), message: Text("Seems like you didn't set your mail in your device.", tableName: "Alerts"), dismissButton: .default(Text("OK", tableName: "Alerts")))
            }
        }
    }

    private func onSendMailTapped(mailType: Constants.MailType) -> (() -> Void)? {
        let handler: (() -> Void)? = {
            self.mailType = mailType
            
            if canSendMail {
                self.isModalPresented = true
            }else {
                let text = """
                
                <br><br><br><br><br>
                -----------------
                <br>
                App version: \(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)
                <br>
                Device Model: \(NetworkManager.getDeviceModel())
                <br>
                Device Type: \(UIDevice.current.model)
                <br>
                iOS version: \(ProcessInfo().operatingSystemVersion.getFullVersion())
                <br>
                Debug Id: \(NetworkManager.getDeviceId())
                """
                if let emailUrl = URLGenerator.createEmailUrl(to: "Hello@HeyWeatherApp.com", subject: mailType.rawValue.replace("_", withString: " ").capitalized, body: "<p>\(text)</p>") {
                    UIApplication.shared.open(emailUrl)
                }
            }
        }
        return handler
    }
    
    private func onTap() {
        if rowType == .review {
            AppStoreAgent.openInStoreReview()
        } else if rowType == .contactUs {
            self.isActionSheetPresented = true
        } else if rowType == .reddit {
            UIApplication.shared.open(URLGenerator.createRedditUrl())
        } else if rowType == .twitter {
            UIApplication.shared.open(URLGenerator.createTwitterUrl())
        } else {
            self.isModalPresented = true
        }
    }
    
    private enum ModalType {
        case mail
        case webView
        case share
    }
    
    internal init(rowType: SettingsRowType) {
        self.rowType = rowType
        switch rowType {
        case .aboutUs:
            self.modalType = .webView
        case .contactUs:
            self.modalType = .mail
        case .share:
            self.modalType = .share
        default:
            self.modalType = .webView
        }
    }
}
