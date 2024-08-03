//
//  EmailURLGenerator.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 6/7/23.
//

import Foundation
import SwiftUI

struct URLGenerator {
    static func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let nonHtmlBodyEncoded = stripHtmlTags(html: body).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(nonHtmlBodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    static func stripHtmlTags(html: String) -> String{
        return html
            .replace("<br>", withString: "\n")
            .replace("<p>", withString: "")
            .replace("</p>", withString: "")
    }
    
    static func createTwitterUrl() -> URL{
        let appURL = URL(string: Constants.twitterAccountApp)!
        let webURL = URL(string: Constants.twitterAccountUrl)!
        
        if UIApplication.shared.canOpenURL(appURL as URL) {
            return appURL
        } else {
            return webURL
        }
    }
    
    static func createRedditUrl() -> URL{
        let appURL = URL(string: Constants.redditAccountApp)!
        let webURL = URL(string: Constants.redditAccountUrl)!
        
        if UIApplication.shared.canOpenURL(appURL as URL) {
            return appURL
        } else {
            return webURL
        }
    }
}
