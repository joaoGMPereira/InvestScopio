//
//  ChartInterativeDataBridge.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 25/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation

public class ChartInterativeDataBridge: ObservableObject {
    @Published var dragEnabled: Bool
    @Published var scaleEnabled: Bool
    @Published var pinchZoomEnabled: Bool
    
    public init(dragEnabled: Bool = true, scaleEnabled: Bool = true, pinchZoomEnabled: Bool = true) {
        self.dragEnabled = dragEnabled
        self.scaleEnabled = scaleEnabled
        self.pinchZoomEnabled = pinchZoomEnabled
    }
}
