//
//  ViewController+WKScriptMessageHandler.swift
//  WebViewTest
//
//  Created by Eugene Bokhan on 11/01/2019.
//  Copyright © 2019 Eugene Bokhan. All rights reserved.
//

import WebKit

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
