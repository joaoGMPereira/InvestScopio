//
//  LineChartDataSetBaseBridge.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 25/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import UIKit

public class LineChartDataSetBaseBridge: ObservableObject {
    @Published var color: UIColor
    @Published var colors: [UIColor]
    @Published var circleColor: UIColor
    @Published var lineWidth: CGFloat
    @Published var circleRadius: CGFloat
    @Published var circleHoleRadius: CGFloat
    @Published var drawCircleHoleEnabled: Bool
    @Published var circleColors: [UIColor]
    @Published var drawValues: Bool
    @Published var valueFont: UIFont
    @Published var xAxisDuration: TimeInterval
    @Published var yAxisDuration: TimeInterval

    public init(color: UIColor = .JEWDefault(), colors: [UIColor] = [UIColor.JEWDefault()], circleColor: UIColor = .JEWBlack(), lineWidth: CGFloat = 1, circleRadius: CGFloat = 2, circleHoleRadius: CGFloat = 1, drawCircleHoleEnabled: Bool = true, circleColors: [UIColor] = [UIColor.JEWDefault()], drawValues: Bool = false, valueFont: UIFont = .systemFont(ofSize: 13, weight: .light), xAxisDuration: TimeInterval = 0.5, yAxisDuration: TimeInterval = 0.5) {
        self.color = color
        self.colors = colors
        self.circleColor = circleColor
        self.lineWidth = lineWidth
        self.circleRadius = circleRadius
        self.circleHoleRadius = circleHoleRadius
        self.drawCircleHoleEnabled = drawCircleHoleEnabled
        self.circleColors = circleColors
        self.drawValues = drawValues
        self.valueFont = valueFont
        self.xAxisDuration = xAxisDuration
        self.yAxisDuration = yAxisDuration
    }
}
