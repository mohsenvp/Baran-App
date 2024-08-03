//
//  MailSheet.swift
//  HeyWeather
//
//  Created by Kamyar on 11/17/21.
//

import SwiftUI
import UIKit
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Binding var mailType: Constants.MailType
    @Environment(\.presentationMode) var presentation
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var presentation: PresentationMode
        
        init(presentation: Binding<PresentationMode>) {
            _presentation = presentation
        }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            presentation.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
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
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["Hello@HeyWeatherApp.com"])
        vc.setSubject(mailType.rawValue.replace("_", withString: " ").capitalized)
        vc.setMessageBody("<p>\(text)</p>", isHTML: true)
        return vc
        
    }
    
   
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {}
}
