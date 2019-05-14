//
//  INVSSimulatorPresenter.swift
//  
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation

protocol INVSSimulatorPresenterProtocol {
    func presentSimulationProjection()
    func presentErrorSimulationProjection(with messageError:String)
}

class INVSSimulatorPresenter: NSObject,INVSSimulatorPresenterProtocol {
   
    weak var controller: INVSSimutatorViewControlerProtocol?
    
    func presentSimulationProjection() {
        
    }
    
    func presentErrorSimulationProjection(with messageError: String) {
        controller?.displayErrorSimulationProjection(with: messageError)
        
    }
    
}