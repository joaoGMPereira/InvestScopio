//
//  TalkWithUsService.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 29/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation

protocol TalkWithUsServiceProtocol {
    func load(nps: LoadableSubject<HTTPResponse<NPSModel>>, request: NPSModel)
    func get(nps: LoadableSubject<HTTPResponse<NPSModel>>, versionApp: String)
}

struct TalkWithUsService: TalkWithUsServiceProtocol {
    let repository: TalkWithUsRepositoryProtocol
    
    init(repository: TalkWithUsRepositoryProtocol) {
        self.repository = repository
    }
    
    func load(nps: LoadableSubject<HTTPResponse<NPSModel>>, request: NPSModel) {
        let cancelBag = CancelBag()
        nps.wrappedValue = .isLoading(last: nps.wrappedValue.value, cancelBag: cancelBag)
        self.repository.sendNPS(request: request)
            .sinkToLoadable { response in
                guard (response.value != nil) else {
                    nps.wrappedValue = .failed(APIError.default)
                    return
                }
                nps.wrappedValue = response
            }
            .store(in: cancelBag)
    }
    
    func get(nps: LoadableSubject<HTTPResponse<NPSModel>>, versionApp: String) {
        let cancelBag = CancelBag()
        nps.wrappedValue = .isLoading(last: nps.wrappedValue.value, cancelBag: cancelBag)
        self.repository.getNPS(versionApp: versionApp)
            .sinkToLoadable { response in
                guard (response.value != nil) else {
                    nps.wrappedValue = .failed(APIError.default)
                    return
                }
                nps.wrappedValue = response
            }
            .store(in: cancelBag)
    }
}
