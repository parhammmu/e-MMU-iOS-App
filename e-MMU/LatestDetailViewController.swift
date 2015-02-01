//
//  LatestDetailViewController.swift
//  e-MMU
//
//  Created by Parham Majdabadi on 29/01/2015.
//  Copyright (c) 2015 Parham Majdabadi. All rights reserved.
//

import UIKit

class LatestDetailViewController: UIViewController, UIWebViewDelegate {
    
    
    @IBOutlet weak var latestWebView: UIWebView!
    var latestUrl : NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.latestWebView.delegate = self
        
        self.latestWebView.scalesPageToFit = true

        if let url = self.latestUrl {
            let request = NSURLRequest(URL: url)
            self.latestWebView.loadRequest(request)
        }
    }

    // MARK: - WebView Delegate methods
    func webViewDidStartLoad(webView: UIWebView) {
        AppUtility.showProgressViewForView(self.navigationController!.view, isDimmed: true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        AppUtility.hideProgressViewFromView(self.navigationController!.view)
    }

}
