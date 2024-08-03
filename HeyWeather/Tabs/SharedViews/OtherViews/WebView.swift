//
//  WebView.swift
//  HeyWeather
//
//  Created by Kamyar on 11/17/21.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    var webview = WKWebView()
    @Binding var url: String
    @State var showLoader = true
    
    class Coordinator: NSObject, WKUIDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // Delegate methods go here
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            // alert functionality goes here
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let request = URLRequest(url: URL(string: self.url) ?? URL(string: "https://www.google.com/")!)
        webview.uiDelegate = context.coordinator
        webview.load(request)
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let newRequest = URLRequest(url: URL(string: self.url) ?? URL(string: "https://www.google.com/")!)
        uiView.load(newRequest)
    }
    
}
