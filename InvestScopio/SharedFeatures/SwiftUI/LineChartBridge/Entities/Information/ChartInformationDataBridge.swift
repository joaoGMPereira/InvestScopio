//
//  ChartInformationDataBridge.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 25/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import UIKit
import Charts

public class ChartInformationDataBridge: ObservableObject {
    @Published var chartDescription: ChartDescriptionBridge
    @Published var rightAxis: RightAxisBridge
    @Published var leftAxis: LeftAxisBridge
    @Published var xAxis: XAxisBridge
    @Published var gradient: ChartGradientBridge
    @Published var drawGridBackgroundEnabled: Bool
    
    public init(chartDescription: ChartDescriptionBridge = ChartDescriptionBridge(), rightAxis: RightAxisBridge = RightAxisBridge(), leftAxis: LeftAxisBridge = LeftAxisBridge(), xAxis: XAxisBridge = XAxisBridge(), gradient: ChartGradientBridge = ChartGradientBridge(), drawGridBackgroundEnabled: Bool = false) {
        self.chartDescription = chartDescription
        self.rightAxis = rightAxis
        self.leftAxis = leftAxis
        self.xAxis = xAxis
        self.gradient = gradient
        self.drawGridBackgroundEnabled = drawGridBackgroundEnabled
    }
}

public struct ChartDescriptionBridge {
    public var enabled: Bool
    
    public init(enabled: Bool = false) {
        self.enabled = enabled
    }
}

public struct RightAxisBridge {
    public var enabled: Bool
    public var drawAxisLineEnabled: Bool
    
    public init(enabled: Bool = false, drawAxisLineEnabled: Bool = false) {
        self.enabled = enabled
        self.drawAxisLineEnabled = drawAxisLineEnabled
    }
}

public struct LeftAxisBridge {
    public var drawGridLinesEnabled: Bool
    public var drawLimitLinesBehindDataEnabled: Bool
    public var spaceTop: CGFloat
    public var labelCount: Int
    public var formatter: NumberFormatter
    public var labelPosition: YAxis.LabelPosition
    public var axisMinimum: Double
    //public var axisMaximum: Double
    
    public init(drawGridLinesEnabled: Bool = false, drawLimitLinesBehindDataEnabled: Bool = true, spaceTop: CGFloat = 0.15, labelCount: Int = 40, formatter: NumberFormatter = NumberFormatter(), labelPosition: YAxis.LabelPosition = .outsideChart, axisMinimum: Double = 0) {
        self.drawGridLinesEnabled = drawGridLinesEnabled
        self.drawLimitLinesBehindDataEnabled = drawLimitLinesBehindDataEnabled
        self.spaceTop = spaceTop
        self.labelCount = labelCount
        self.formatter = formatter
        self.labelPosition = labelPosition
        self.axisMinimum = axisMinimum
        //self.axisMaximum = axisMaximum
    }
}

public struct XAxisBridge {
    public var drawGridLinesEnabled: Bool
    public var labelPosition: XAxis.LabelPosition
    public var labelFont: UIFont
    public var formatter: NumberFormatter
    public var drawAxisLineEnabled: Bool
    
    public init(drawGridLinesEnabled: Bool = false, labelPosition: XAxis.LabelPosition = .bottom, labelFont: UIFont = .systemFont(ofSize: 10), formatter: NumberFormatter = NumberFormatter(), drawAxisLineEnabled: Bool = true) {
        self.drawGridLinesEnabled = drawGridLinesEnabled
        self.labelPosition = labelPosition
        self.labelFont = labelFont
        self.formatter = formatter
        self.drawAxisLineEnabled = drawAxisLineEnabled
    }
}

public struct ChartGradientBridge {
    public var colors: [CGColor]
    public var alpha: CGFloat
    public var angle: CGFloat
    public var drawFilledEnabled: Bool
    
    public init(colors: [CGColor] = [UIColor.JEWDefault().cgColor, UIColor.JEWLightDefault().cgColor], alpha: CGFloat = 1, angle: CGFloat = 90, drawFilledEnabled: Bool = true) {
        self.colors = colors
        self.alpha = alpha
        self.angle = angle
        self.drawFilledEnabled = drawFilledEnabled
    }
}
