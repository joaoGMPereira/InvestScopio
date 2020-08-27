//
//  ChartDataBaseBridge.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 25/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation


public class ChartDataBaseBridge: ObservableObject {
    @Published var interativeData: ChartInterativeDataBridge
    @Published var informationData: ChartInformationDataBridge
    @Published var hasBallonMarker: Bool
    
    public init(interativeData: ChartInterativeDataBridge = ChartInterativeDataBridge(), informationData: ChartInformationDataBridge = ChartInformationDataBridge(), hasBallonMarker: Bool = true) {
        self.interativeData = interativeData
        self.informationData = informationData
        self.hasBallonMarker = hasBallonMarker
    }
}
