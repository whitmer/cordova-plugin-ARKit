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
    
    let getUrlAtDocumentStartScript = "GetUrlAtDocumentStart"
    let getUrlAtDocumentEndScript = "GetUrlAtDocumentEnd"
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        webView.load(URLRequest(url: Bundle.main.url(forResource: "index",
                                                     withExtension: "html")!))
    }
    
    func addWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.addScript(script: WKUserScript.getUrlScript(scriptName: getUrlAtDocumentStartScript),
                                scriptHandlerName:getUrlAtDocumentStartScript,
                                scriptMessageHandler: self,
                                injectionTime: .atDocumentStart)
        configuration.addScript(script: WKUserScript.getUrlScript(scriptName: getUrlAtDocumentEndScript),
                                scriptHandlerName:getUrlAtDocumentEndScript,
                                scriptMessageHandler: self,
                                injectionTime: .atDocumentEnd)
        
        let frame = CGRect(origin: .zero,
                           size: CGSize(width: view.frame.width,
                                        height: view.frame.height - 90))
        
        webView = WKWebView(frame: frame,
                            configuration: configuration)
        webView.navigationDelegate = self

        webView.layer.masksToBounds = true
        webView.layer.cornerRadius = 10
        view.addSubview(webView)
        
    }


}

extension ViewController: WKNavigationDelegate {
    
}


extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        switch message.name {
            
        case getUrlAtDocumentStartScript:
            print("start: \(message.body)")
            
        case getUrlAtDocumentEndScript:
            print("end: \(message.body)")
            
        default:
            break;
        }
    }
}

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


