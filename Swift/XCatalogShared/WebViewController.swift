//
//  WebViewController.swift
//  XCatalog
//
//  Created by Michael L Mehr on 8/18/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import Foundation

class WebViewController: XViewController, XWebViewDelegate, XTextFieldDelegate {
    // MARK: Properties
    
    @IBOutlet weak var webView: XWebView!
    
    @IBOutlet weak var addressTextField: XTextField!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebView()
        addressTextField.delegate = self
        loadAddressURL()
    }

    // NOTE: Irreconcilable differences in OS behavior cause this use of #if
    #if os(iOS)
    override func viewWillDisappear(animated: Bool)
    {
    super.viewWillDisappear(animated)
    
    XApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    #else
    override func viewWillDisappear()
    {
        super.viewWillDisappear()
        
        XApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    #endif
    
    // MARK: Convenience
    
    func loadAddressURL() {
        if let requestURL = NSURL(string: addressTextField.text) {
            let request = NSURLRequest(URL: requestURL)
            webView.loadRequest(request)
        }
    }
    
    // MARK: Configuration
    
    func configureWebView() {
        webView.backgroundColor = XColor.whiteColor()
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .All
    }
    
    // MARK: XWebViewDelegate
    
    func webViewDidStartLoad(webView: XWebView) {
        XApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: XWebView) {
        XApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: XWebView, didFailLoadWithError error: NSError) {
        // Report the error inside the web view.
        let localizedErrorMessage = NSLocalizedString("An error occured:", comment: "")
        
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">\(localizedErrorMessage) \(error.localizedDescription)</div></body></html>"
        
        webView.loadHTMLString(errorHTML, baseURL: nil)
        
        XApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    // MARK: XTextFieldDelegate
    
    /// Dismisses the keyboard when the "Done" button is clicked.
    func textFieldShouldReturn(textField: XTextField) -> Bool {
        textField.resignFirstResponder()
        
        loadAddressURL()
        
        return true
    }
}
