//
//  WebView.swift
//  curved-screen
//
//  Created by unboxers on 2/15/24.
//

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView  {
        let wkwebView = WKWebView()
        wkwebView.configuration.preferences.isElementFullscreenEnabled = true
        let request = URLRequest(url: url)
        wkwebView.load(request)
        return wkwebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
