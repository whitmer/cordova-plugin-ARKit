//
//  ViewController.swift
//  WebViewTest
//
//  Created by Eugene Bokhan on 11/01/2019.
//  Copyright © 2019 Eugene Bokhan. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    // MARK: - Interface Actions
    
    @IBAction func loadModelA(_ sender: UIButton) {
        loadModel(name: "Planes_4CAE")
    }
    
    @IBAction func loadModelB(_ sender: UIButton) {
        loadModel(name: "firetruck")
    }
    
    // MARK: - Properties
    
    let getUrlAtDocumentStartScript = "GetUrlAtDocumentStart"
    let getUrlAtDocumentEndScript = "GetUrlAtDocumentEnd"
    
    var webView: WKWebView!
    
    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        webView.load(URLRequest(url: Bundle.main.url(forResource: "webassets/index",
                                                     withExtension: "html")!))
    }
    
    func addWebView() {
        // Setup Configuration
        let configuration = WKWebViewConfiguration()
        configuration.addScript(script: WKUserScript.getUrlScript(scriptName: getUrlAtDocumentStartScript),
                                scriptHandlerName:getUrlAtDocumentStartScript,
                                scriptMessageHandler: self,
                                injectionTime: .atDocumentStart)
        configuration.addScript(script: WKUserScript.getUrlScript(scriptName: getUrlAtDocumentEndScript),
                                scriptHandlerName:getUrlAtDocumentEndScript,
                                scriptMessageHandler: self,
                                injectionTime: .atDocumentEnd)
        configuration.preferences.setValue(true,
                                           forKey: "allowFileAccessFromFileURLs")
        // Setup Frame
        let frame = CGRect(origin: .zero,
                           size: CGSize(width: view.frame.width,
                                        height: view.frame.height - 90))
        // Init Web View
        webView = WKWebView(frame: frame,
                            configuration: configuration)
        webView.scrollView.isScrollEnabled = false;
        webView.navigationDelegate = self
        // Setup Web View Appearance
        webView.layer.masksToBounds = true
        webView.layer.cornerRadius = 10
        view.addSubview(webView)
    }
    
    // MARK: - Model Loading
    
    func loadModel(name: String) {
        guard let modelOneURL = Bundle.main.url(forResource: name,
                                                withExtension: "obj") else { return }
        let json = """
        {
            url : "\(modelOneURL.absoluteString)",
            scale : [1, 1, 1],
            eulerAngles : [0, 0, 0],
            position : [0, 0, 0]
        }
        """
        self.webView.evaluateJavaScript("var event = new CustomEvent('model', {detail: \(json)}); document.dispatchEvent(event);",
                                        completionHandler: nil)
    }

}

extension ViewController: WKNavigationDelegate { }

extension WKUserScript {
    class func getUrlScript(scriptName: String) -> String {
        return "webkit.messageHandlers.\(scriptName).postMessage(document.URL)"
    }
}

extension WKWebViewConfiguration {
    func addScript(script: String,
                   scriptHandlerName:String,
                   scriptMessageHandler: WKScriptMessageHandler,
                   injectionTime:WKUserScriptInjectionTime) {
        let userScript = WKUserScript(source: script,
                                      injectionTime: injectionTime,
                                      forMainFrameOnly: false)
        userContentController.addUserScript(userScript)
        userContentController.add(scriptMessageHandler,
                                  name: scriptHandlerName)
    }
}


