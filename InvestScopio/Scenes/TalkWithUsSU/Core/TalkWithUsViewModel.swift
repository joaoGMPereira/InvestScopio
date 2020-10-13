//
//  TalkWithUsViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 28/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import MessageUI
import SwiftUI
import JewFeatures

class TalkWithUsViewModel: ObservableObject {
    //MARK: - Rating
    @Published var ratings = ["Péssimo", "Ruim", "OK", "Bom", "Ótimo"]
    @Published var sendingRating: Bool = false
    @Published var selectedRating: Int? {
        didSet {
            if hasCheckedNPS {
                sendNPS()
            }
        }
    }
    @Published var npsLoadable: Loadable<HTTPResponse<NPSModel>> {
        didSet {
            build(state: npsLoadable)
        }
    }
    @Published var checkNpsLoadable: Loadable<HTTPResponse<NPSModel>> {
        didSet {
            buildCheckNPS(state: checkNpsLoadable)
        }
    }
    @Published var message = String()
    var hasCheckedNPS = false
    let talkWithUsService: TalkWithUsServiceProtocol
    var completion: ((AppPopupSettings) -> Void)?
    
    //MARK: - Feedback
    @Published var feedbacks = ["Sugestão", "Reclamação", "Elogio", "Feedback"]
    @Published var selectedFeedback: String? {
        didSet {
            setupMailItems()
        }
    }
    @Published var isShowingMailView: Bool = false
    @Published var result: Result<MFMailComposeResult, Error>? = nil
    @Published var subject = String()
    @Published var recipients = String()
    @Published var messageBody = String()
    
    init(service: TalkWithUsServiceProtocol) {
        self._npsLoadable = .init(initialValue: .notRequested)
        self._checkNpsLoadable = .init(initialValue: .notRequested)
        self.talkWithUsService = service
    }
    
    func checkNPS() {
        guard hasCheckedNPS else {
            switch npsLoadable {
            case .notRequested, .loaded(_), .failed(_):
                talkWithUsService.get(nps: loadableSubject(\.checkNpsLoadable), versionApp: Self.getAppVersion())
            case .isLoading(_, _): break
            }
            return
        }
    }
    
    func sendNPS() {
        if let selectedRating = selectedRating {
            switch checkNpsLoadable {
            case .notRequested, .loaded(_), .failed(_):
                talkWithUsService.load(nps: loadableSubject(\.npsLoadable), request: NPSModel.init(rate: selectedRating, versionApp: Self.getAppVersion(), versionSO: UIDevice.current.systemVersion))
            case .isLoading(_, _): break
            }
        }
    }
    
    func build(state: Loadable<HTTPResponse<NPSModel>>) {
        switch state {
        case .notRequested:
            break
        case .isLoading(_, _):
            break
        case .loaded(let response):
            self.message = response.message ?? String()
            self.completion?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWDarkDefault()), position: .top, show: true))
        case .failed(let error):
            if let apiError = error as? APIError {
                self.message = apiError.errorDescription ?? String()
                self.completion?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            }
        }
    }
    
    func buildCheckNPS(state: Loadable<HTTPResponse<NPSModel>>) {
        switch state {
        case .notRequested, .isLoading:
            break
        case .loaded(let response):
            selectedRating = response.data.rate
            hasCheckedNPS = true
            break
        case .failed:
            hasCheckedNPS = true
        }
    }
    
    func setupMailItems() {
        subject = "\(selectedFeedback ?? String()) para a versão \(Self.getAppVersion()) do App, iOS \(UIDevice.current.systemVersion)"
        recipients = "investscopio.s.a@gmail.com"
        messageBody = "<p>A InvestScopio agradece seu(ua) \(selectedFeedback ?? String())!</p>"
    }
    
    static func getAppVersion() -> String {
        if let nsObject: AnyObject = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject? {
            if let version = nsObject as? String {
                return version
            }
        }
        return ""
    }
}
