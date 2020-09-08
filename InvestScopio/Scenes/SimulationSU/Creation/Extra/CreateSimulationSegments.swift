//
//  CreateSimulationSegments.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 07/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation

public protocol SegmentedPickerViewElementTraits: Hashable {
    var localizedText: String { get }
}

enum CreateSimulationSegments: Int, CaseIterable {
    case simply
    case completed
    
    static var allLocalizedText: [String] {
        return allCases.map { $0.localizedText }
    }
}

extension CreateSimulationSegments: SegmentedPickerViewElementTraits {
    var localizedText: String {
        switch self {
        case .simply:
            return "Simplificada"
        case .completed:
            return "Completa"
        }
    }
}
