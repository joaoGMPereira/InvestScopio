//
//  INVSCEIWorker.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 27/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit
//import SwiftSoup
import Firebase
import Alamofire

typealias Item = (text: String, html: String)

typealias SuccessDownloadMarketInfoHandler = (MarketModel) -> ()
typealias ErrorSDownloadMarketInfoHandler = (_ messageError:String) -> ()


protocol INVSStartWorkerProtocol {
    func downloadMarketInfo(successCompletionHandler: @escaping(SuccessDownloadMarketInfoHandler), errorCompletionHandler:@escaping(ErrorSDownloadMarketInfoHandler))
}

class INVSStartWorker: NSObject,INVSStartWorkerProtocol {
    
    func downloadMarketInfo(successCompletionHandler: @escaping (SuccessDownloadMarketInfoHandler), errorCompletionHandler: @escaping (ErrorSDownloadMarketInfoHandler)) {
        //service.apiKey = FirebaseApp.app()?.options.apiKey
        //apiVersion()
        //selicIPCATax()
        //IBOVTax()
        //parseBanksCSV()
        
//        dispatchGroup.notify(queue: .main) {
//            if let error = self.market.error {
//                errorCompletionHandler(error)
//                return
//            }
//            successCompletionHandler(self.market)
//        }
    }
    
    func apiVersion() {
        //dispatchGroup.enter()
//        INVSConector.connector.request(withURL: INVSConector.getVersion()) { (response) in
//            print(response)
//            do {
//                let decoder = JSONDecoder()
//                let version = try decoder.decode(INVSVersionModel.self, from: response.data!)
//                print(version)
//            } catch {
//
//            }
//            self.dispatchGroup.leave()
//        }
    }
    
//    func selicIPCATax() {
//        dispatchGroup.enter()
//        let range = "Carteira!Q2:R3"
//        let query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetId, range:range)
//        service.executeQuery(query) { (ticket, result, error) in
//            if let error = error {
//                self.market.error = error.localizedDescription
//                self.dispatchGroup.leave()
//                return
//            }
//            if let result = result as? GTLRSheets_ValueRange {
//                self.parseSelic(withResult: result)
//                self.parseIPCA(withResult: result)
//                if let rows = result.values {
//                    if rows.isEmpty {
//                        self.market.error = "Sem Resultados de Selic e IPCA"
//                        self.dispatchGroup.leave()
//                        return
//                    }
//                }
//            }
//            self.dispatchGroup.leave()
//        }
//    }
//
//    private func parseSelic(withResult result: GTLRSheets_ValueRange) {
//        if let rows = result.values {
//            if rows.count > 1 {
//                let names = rows[0]
//                let values = rows[1]
//                if values.count > 0 && names.count > 0 {
//                    if let selicName = names[0] as? String, let selicValue = values[0] as? String {
//                        if selicName.lowercased() == "selic" {
//                            market.selic = TaxModel(name: selicName, signal: selicValue.checkSignal(), value: selicValue.convertFormattedToDouble())
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    private func parseIPCA(withResult result: GTLRSheets_ValueRange) {
//        if let rows = result.values {
//            if rows.count > 1 {
//                let names = rows[0]
//                let values = rows[1]
//                if values.count > 1 && names.count > 1 {
//                    if let ipcaName = names[1] as? String, let ipcaValue = values[1] as? String {
//                        if ipcaName.lowercased() == "ipca" {
//                            market.ipca = TaxModel(name: ipcaName, signal: ipcaValue.checkSignal(), value: ipcaValue.convertFormattedToDouble())
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func IBOVTax() {
//        dispatchGroup.enter()
//        let range2 = "Carteira!S22:T22"
//        let query2 = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetId, range:range2)
//        service.executeQuery(query2) { (ticket, result, error) in
//            if let error = error {
//                self.market.error = error.localizedDescription
//                self.dispatchGroup.leave()
//                return
//            }
//            if let result = result as? GTLRSheets_ValueRange {
//                self.parseIBOV(withResult: result)
//                if let rows = result.values {
//                    if rows.isEmpty {
//                        self.market.error = "Sem Resultados do IBOV"
//                        self.dispatchGroup.leave()
//                        return
//                    }
//                }
//            }
//            self.dispatchGroup.leave()
//        }
//    }
//
//    private func parseIBOV(withResult result: GTLRSheets_ValueRange) {
//        if let rows = result.values {
//            if rows.count > 0 {
//                let ibov = rows[0]
//                if ibov.count > 1 {
//                    if let ibovName = ibov[0] as? String, let ibovValue = ibov[1] as? String {
//                        if ibovName.lowercased() == "ibov" {
//                            market.ibov = TaxModel(name: ibovName, signal: ibovValue.checkSignal(), value: ibovValue.convertFormattedToDouble())
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    private func parseBanksCSV() {
//        guard let filepath = Bundle.main.path(forResource: "ParticipantesSTRport", ofType: "csv")
//            else {
//                return
//        }
//        do {
//            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
//            csvBanks(data: contents)
//        } catch {
//            print("File Read Error for file \(filepath)")
//            return
//        }
//    }
//    func csvBanks(data: String) -> [BankModel] {
//        var banks: [BankModel] = []
//        let rows = data.components(separatedBy: "\r\n").filter({$0 != ""})
//        for row in rows {
//            let columns = row.components(separatedBy: ";")
//            if columns.count == 3 {
//                let reducedName: String = columns[0]
//                let code: String = columns[1]
//                let completeName: String = columns[2]
//                let bank = BankModel(reducedName: reducedName, completeName: completeName, code: code)
//                banks.append(bank)
//            }
//        }
//        return banks
//    }
}
    
//    //Download HTML
//    func downloadCeiHTML(withURL url: URL) {
//        // url string to URL
//
//        do {
//            // content of url
//            let html = try String.init(contentsOf: url)
//            // parse it into a Document
//            document = try SwiftSoup.parse(html)
//            // parse css query
//            parse()
//        } catch let error {
//            // an error occurred
//            //UIAlertController.showAlert("Error: \(error)", viewController)
//        }
//
//    }
//
//    //Parse CSS selector
//    func parse() {
//        do {
//            //empty old items
//            items = []
//            // firn css selector
//
//            let elements: Elements = try document.select("")
//            //transform it into a local object (Item)
//            for element in elements {
//                let text = try element.text()
//                let html = try element.outerHtml()
//                items.append(Item(text: text, html: html))
//            }
//
//        } catch let error {
//            //UIAlertController.showAlert("Error: \(error)", viewController)
//        }
//    }
//
//
//    func setupHomePage2() {
//        let url = URL(string: "https://cei.b3.com.br/CEI_Responsivo/")!
//        let request = URLRequest(url: url)
//        webView.load(request)
//    }
//
//    func setupHomePage1() {
//        webView.navigationDelegate = self
//        let url = URL(string: "https://cei.b3.com.br/CEI_Responsivo/")!
//        let request = URLRequest(url: url)
//        webView.load(request)
//    }
//
//    func getDailyTokenHTML() {
//        webView.evaluateJavaScript("document.getElementById('ctl00_ContentPlaceHolder1_txtLogin').value='43054225810'", completionHandler: nil)
//        webView.evaluateJavaScript("document.getElementById('ctl00_ContentPlaceHolder1_txtSenha').value='Jg@22151515'", completionHandler: nil)
//        webView.evaluateJavaScript("document.getElementById('ctl00_ContentPlaceHolder1_btnLogar').click()", completionHandler: nil)
//
//    }

//
//extension INVSMarketWorker: WKNavigationDelegate {
//    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//
//        if let webViewURL = webView.url?.absoluteString {
//            if webViewURL == "https://cei.b3.com.br/CEI_Responsivo/home.aspx" {
//                webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
//                                           completionHandler: { (html: Any?, error: Error?) in
//                                            print(html)
//                })
//            } else {
//                self.getDailyTokenHTML()
//            }
//        }
//    }
//}
