//
//  SimulationCreationViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 27/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit

class SimulationCreationViewModel: ObservableObject {
    @Published var step = SimulationCreationViewType.initialStep
    @Published var textHeight: CGFloat = 44
    @Published var passed: Int = 0
    @Published var progress: Int = 0
    @Published var quantity: CGFloat = 7
    
    @Published var close: Bool = false
    @Published var text: String = String()
    
    @Published var selectedIndex: Int = 0 {
        didSet {
            segmentSelected = CreateSimulationSegments(rawValue: selectedIndex) ?? .simply
        }
    }
    
    private var segmentSelected: CreateSimulationSegments = .simply {
        didSet {
            if segmentSelected == .simply {
                setSimplySteps()
            } else {
                setCompleteSteps()
            }
        }
    }

    @Published var isOpened: Bool = false {
        didSet {
            if oldValue == false || isOpened == false {
                cleanStep()
            }
        }
    }
    @Published var showHeader: Bool = false
    @Published var showTextField: Bool = false
    @Published var showBottomButtons: Bool = false
    
    func cleanStep() {
        segmentSelected = .simply
        step = .initialStep
        showHeader = false
        showTextField = false
        showBottomButtons = true
    }
    
    func setFirstStep() {
        self.passed = 0
        self.progress = 1
        self.step = .firstStep
        self.showHeader = true
        self.showTextField = true
        self.showBottomButtons = false
    }
    
    func setSimplySteps() {
        setFirstStep()
        self.quantity = 4
    }
    
    func setCompleteSteps() {
        setFirstStep()
        self.quantity = 7
    }
}
