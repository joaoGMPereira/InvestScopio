//
//  INVSCEIWorker.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 27/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SwiftSoup

typealias Item = (text: String, html: String)
class INVSCEIWorker: NSObject {
    // current document
    var document: Document = Document.init("")
    // item founds
    var items: [Item] = []
    var viewController = UIViewController()
    let webView = WKWebView(frame: .zero)
    
    //Download HTML
    func downloadHTML(withURL url: URL) {
        // url string to URL
        
        do {
            // content of url
            let html = try String.init(contentsOf: url)
            // parse it into a Document
            document = try SwiftSoup.parse(html)
            // parse css query
            parse()
        } catch let error {
            // an error occurred
            UIAlertController.showAlert("Error: \(error)", viewController)
        }
        
    }
    
    //Parse CSS selector
    func parse() {
        do {
            //empty old items
            items = []
            // firn css selector
            
            let elements: Elements = try document.select("")
            //transform it into a local object (Item)
            for element in elements {
                let text = try element.text()
                let html = try element.outerHtml()
                items.append(Item(text: text, html: html))
            }
            
        } catch let error {
            UIAlertController.showAlert("Error: \(error)", viewController)
        }
    }
    
    
    func setupHomePage() {
        let url = URL(string: "https://cei.b3.com.br/CEI_Responsivo/")!
        let request = URLRequest(url: url)
        webView.load(request)
    }

    
}

extension UIAlertController {
    static public func showAlert(_ message: String, _ controller: UIViewController) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
