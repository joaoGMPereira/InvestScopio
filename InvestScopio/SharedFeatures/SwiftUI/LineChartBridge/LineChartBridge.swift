//
//  LineChart.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 24/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import Charts

extension View {
    public func setChartDataBase(_ data: ChartDataBaseBridge = ChartDataBaseBridge()) -> some View {
        return self
            .environmentObject(data)
    }
    
    public func setChartDataSet(_ data: LineChartDataSetBaseBridge = LineChartDataSetBaseBridge()) -> some View {
        return self
            .environmentObject(data)
    }
}

extension LineChartView {
    
}

struct LineChart: UIViewRepresentable {
    //public var data = ChartDataBase()
    
    @EnvironmentObject var data: ChartDataBaseBridge
    @EnvironmentObject var dataSet: LineChartDataSetBaseBridge
    var entries: [ChartDataEntry]
    var months: Int
    var granularity: Double
    var axisMaximum: Double
    var label: String
    @Binding var hideHighlight: Bool
    @Binding var indexSelected: Int
    @Binding var positionXSelected: CGFloat
    
    func makeUIView(context: Context) -> LineChartView {
        let chartView = LineChartView()
        setInterativeCharts(chartView: chartView)
        setChartsInfo(chartView: chartView)
        setChartsEntries(chartView: chartView)
        setLeftAxys(chartView: chartView)
        setXAxys(chartView: chartView)
        if data.hasBallonMarker {
            setBallonMarker(chartView: chartView)
        }
        chartView.delegate = context.coordinator
        let gesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleGesture(_:)))
        gesture.minimumPressDuration = 0.2
        gesture.allowableMovement = 50
        chartView.addGestureRecognizer(gesture)
        return chartView
    }
    
    func setInterativeCharts(chartView: LineChartView) {
        chartView.dragEnabled = data.interativeData.dragEnabled
        chartView.setScaleEnabled(data.interativeData.scaleEnabled)
        chartView.pinchZoomEnabled = data.interativeData.pinchZoomEnabled
        chartView.doubleTapToZoomEnabled = false
        chartView.legend.enabled = false
    }
    
    func setChartsInfo(chartView: LineChartView) {
        chartView.chartDescription?.enabled = data.informationData.chartDescription.enabled
        chartView.rightAxis.enabled = data.informationData.rightAxis.enabled
        chartView.rightAxis.drawAxisLineEnabled = data.informationData.rightAxis.drawAxisLineEnabled
        chartView.leftAxis.drawGridLinesEnabled = false // data.informationData.leftAxis.drawGridLinesEnabled
        chartView.xAxis.drawGridLinesEnabled = false // data.informationData.xAxis.drawGridLinesEnabled
        chartView.drawGridBackgroundEnabled = data.informationData.drawGridBackgroundEnabled
        
    }
    
    private func setBallonMarker(chartView: LineChartView) {
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = ChartMarkerView.init(color: .JEWBackground(), chartView: chartView)
        chartView.drawMarkers = true
        chartView.viewPortHandler.setMaximumScaleX(1)
        chartView.viewPortHandler.setMaximumScaleY(1)
    }
    
    func setChartsEntries(chartView: LineChartView) {
        let set = LineChartDataSet(entries: entries, label: nil)
        set.setColor(dataSet.color)
        set.colors = dataSet.colors
        set.setCircleColor(dataSet.circleColor)
        set.lineWidth = dataSet.lineWidth
        set.circleRadius = dataSet.circleRadius
        set.circleHoleRadius = dataSet.circleHoleRadius
        set.drawCircleHoleEnabled = dataSet.drawCircleHoleEnabled
        set.circleColors = dataSet.circleColors
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false
        setGradientFilled(dataSet: set)
        
        let data = LineChartData(dataSets: [set])
//        data.setDrawValues(dataSet.drawValues)
//        data.setValueFont(dataSet.valueFont)
        chartView.data = data
        chartView.animate(xAxisDuration: dataSet.xAxisDuration, yAxisDuration: dataSet.yAxisDuration)
    }
    
    private func setGradientFilled(dataSet: LineChartDataSet) {
        
        let gradientColors = data.informationData.gradient.colors
        _ = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        //dataSet.fillAlpha = data.informationData.gradient.alpha
       // dataSet.fill = Fill(linearGradient: gradient, angle: data.informationData.gradient.angle)
       // dataSet.drawFilledEnabled = data.informationData.gradient.drawFilledEnabled
        dataSet.highlightLineWidth = 2
        dataSet.highlightColor = .JEWDarkDefault()
        dataSet.highlightEnabled = true
        dataSet.drawVerticalHighlightIndicatorEnabled = true
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
    }
    
    func setLeftAxys(chartView: LineChartView) {
        chartView.leftAxis.enabled = true
        chartView.leftAxis.drawZeroLineEnabled = true
        chartView.leftAxis.zeroLineColor = UIColor.white
        chartView.leftAxis.zeroLineWidth = 1
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.spaceBottom = 0.5
        chartView.leftAxis.spaceTop = 0.5
       // leftAxis.axisMaximum = axisMaximum + (axisMaximum * 0.1)
       // leftAxis.axisMinimum = data.informationData.leftAxis.axisMinimum
        //leftAxis.labelPosition = .outsideChart
        
//        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: data.informationData.leftAxis.formatter)
//        leftAxis.labelCount = data.informationData.leftAxis.labelCount
//        leftAxis.spaceTop = data.informationData.leftAxis.spaceTop
//        leftAxis.drawLimitLinesBehindDataEnabled = data.informationData.leftAxis.drawLimitLinesBehindDataEnabled
    }
    
    func setXAxys(chartView: LineChartView) {
//        let xAxis = chartView.xAxis
//        xAxis.labelPosition = data.informationData.xAxis.labelPosition
//        xAxis.labelCount = months
//        xAxis.labelFont = data.informationData.xAxis.labelFont
//        let numberFormatter = data.informationData.xAxis.formatter
//        xAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: numberFormatter)
//        xAxis.granularity = granularity
        chartView.xAxis.drawAxisLineEnabled = false // data.informationData.xAxis.drawAxisLineEnabled
        chartView.xAxis.enabled = false
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        setLeftAxys(chartView: uiView)
        setXAxys(chartView: uiView)
        setInterativeCharts(chartView: uiView)
        setChartsInfo(chartView: uiView)
        setChartsEntries(chartView: uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(hideHighlight: $hideHighlight, indexSelected: $indexSelected, positionXSelected: $positionXSelected)
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        private let selectionFeedback = UISelectionFeedbackGenerator()
        private var lastIndexHighlighted: Double?
        @Binding var hideHighlight: Bool
        @Binding var indexSelected: Int
        @Binding var positionXSelected: CGFloat
        
        init(hideHighlight: Binding<Bool>, indexSelected: Binding<Int>, positionXSelected: Binding<CGFloat>) {
            _hideHighlight = hideHighlight
            _indexSelected = indexSelected
            _positionXSelected = positionXSelected
        }
        
        @objc func handleGesture(_ gesture: UIGestureRecognizer) {
            if let chartView = gesture.view as? LineChartView {
                if gesture.state == .ended || gesture.state == .cancelled {
                    chartView.highlightValue(x: 0.0, dataSetIndex: -1)
                } else {
                    let position = gesture.location(in: chartView)
                    let highlight = chartView.getHighlightByTouchPoint(position)
                    
                    chartView.highlightValue(highlight, callDelegate: true)
                }
            }
        }
        
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            if self.lastIndexHighlighted != entry.x {
                self.hideHighlight = false
                self.selectionFeedback.selectionChanged()
                self.indexSelected = Int(entry.x)
                self.positionXSelected = chartView.convert(CGPoint(x: highlight.xPx, y: 0), to: chartView.superview).x
              //  self.delegate?.updateValuesToPosition(Int(entry.x), highlightXPosition: self.convert(CGPoint(x: highlight.xPx, y: 0), to: self.superview).x)
                self.lastIndexHighlighted = entry.x
            }
        }

        func chartValueNothingSelected(_ chartView: ChartViewBase) {
            self.hideHighlight = true
          //  self.delegate?.hideHighlightText()
            self.lastIndexHighlighted = nil
        }
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        return LineChart(entries: [ChartDataEntry(x: 0, y: 0)], months: 10, granularity: 1, axisMaximum: 100, label: "teste", hideHighlight: .constant(true), indexSelected: .constant(0), positionXSelected: .constant(.zero)).setChartDataBase().setChartDataSet()
    }
}


enum ShadeBackgroundStyle {
    case left
    case right
    case both
}

class ChartMarkerView: IMarker {
    var offset: CGPoint

    let color: UIColor
    let chartView: ChartViewBase
    let shadeStyle: ShadeBackgroundStyle
    let hightlightLineWidth: CGFloat

    init(color: UIColor = .JEWDefault(), chartView: ChartViewBase, shadeStyle: ShadeBackgroundStyle = .left, highlightWidth: CGFloat = 2) {
        self.color = color
        self.chartView = chartView
        self.offset = .zero
        self.shadeStyle = shadeStyle
        self.hightlightLineWidth = highlightWidth
    }

    func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
    }

    func offsetForDrawing(atPoint: CGPoint) -> CGPoint {
        return self.offset
    }

    func draw(context: CGContext, point: CGPoint) {
        let offset = self.offsetForDrawing(atPoint: point)

        let layer = CALayer()
        layer.frame = CGRect(origin: .zero, size: self.chartView.frame.size)
        layer.backgroundColor = self.color.cgColor
        layer.opacity = 0.6

        context.saveGState()
        UIGraphicsPushContext(context)

        switch self.shadeStyle {
        case .right:
            context.translateBy(x: (point.x - offset.x) - layer.frame.width, y: 0 + offset.y)
            layer.render(in: context)
        case .both:
            //Cria path onde será destacado
            let path = UIBezierPath(rect: layer.frame)

            //Cria a area onde sera transparente
            let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: point.x - (offset.x / 2), y: 0),
                                                     size: CGSize(width: self.hightlightLineWidth + offset.x, height: self.chartView.frame.height)))

            path.append(rectPath)
            path.usesEvenOddFillRule = true

            let fillLayer = CAShapeLayer()
            fillLayer.path = path.cgPath
            fillLayer.fillRule = CAShapeLayerFillRule.evenOdd

            layer.mask = fillLayer
            layer.render(in: context)
        default:
            context.translateBy(x: point.x + offset.x, y: 0 + offset.y)
            layer.render(in: context)
        }

        UIGraphicsPopContext()
        context.restoreGState()
    }
}


//
//  XPMultipleLineChartView.swift
//  MinhaCarteiraXP
//
//  Created by Leonardo Mendes on 19/05/19.
//  Copyright ©️ 2019 XP Investimentos. All rights reserved.
//
//
//import Foundation
//import UIKit
//import Charts
//
//protocol XPMultipleLineChartDelegate {
//    func updateValuesToPosition(_ position: Int, highlightXPosition: CGFloat)
//    func hideHighlightText()
//}
//
//class XPMultipleLineChartView: UIView {
//    var delegate: XPMultipleLineChartDelegate?
//
//    var values: [[Double]]? {
//        didSet {
//            var minValue = Double.infinity
//
//            self.lineSets.removeAll()
//            self.values?.enumerated().forEach({ (arg) in
//                let (i, chartValues) = arg
//
//                self.lineSets.append(setupLineSet(chartValues, color: self.colors?[i] ?? .white))
//
//                if let chartMinValue = chartValues.min(), chartMinValue <= minValue {
//                    minValue = chartMinValue
//                }
//            })
//
//            self.chartView.data = LineChartData(dataSets: self.lineSets.reversed())
//            self.chartView.data?.calcMinMax()
//            self.chartView.leftAxis.drawZeroLineEnabled = minValue < 0
//        }
//    }
//
//    var colors: [UIColor]? {
//        didSet {
//            self.colors?.enumerated().forEach({ (i, color) in
//                if i < lineSets.count {
//                    lineSets[i].setColor(color)
//                    lineSets[i].highlightColor = self.colors?.first ?? .clear
//                }
//            })
//        }
//    }
//
//    private let chartView = LineChartView()
//    private var lineSets = [LineChartDataSet]()
//    private let selectionFeedback = UISelectionFeedbackGenerator()
//    private var lastIndexHighlighted: Double?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    func commonInit() {
//        self.backgroundColor = .clear
//        self.addSubview(self.chartView)
//
//        setupChartView()
//
//        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
//        gesture.minimumPressDuration = 0.2
//        gesture.allowableMovement = 50
//
//        self.chartView.addGestureRecognizer(gesture)
//    }
//
//    //Private Methods
//    private func setupChartView() {
//        self.chartView.frame = CGRect(origin: .zero, size: self.frame.size)
//        self.chartView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        self.chartView.minOffset = 0
//
//        self.chartView.xAxis.enabled = false
//        self.chartView.rightAxis.enabled = false
//        self.chartView.highlightPerTapEnabled = false
//        self.chartView.highlightPerDragEnabled = false
//        self.chartView.pinchZoomEnabled = false
//        self.chartView.doubleTapToZoomEnabled = false
//        self.chartView.autoScaleMinMaxEnabled = false
//        self.chartView.legend.enabled = false
//
//        self.chartView.leftAxis.enabled = true
//        self.chartView.leftAxis.zeroLineColor = .neutralLight2
//        self.chartView.leftAxis.zeroLineDashLengths = [1, 3]
//        self.chartView.leftAxis.zeroLineWidth = 1
//        self.chartView.leftAxis.drawLabelsEnabled = false
//        self.chartView.leftAxis.drawGridLinesEnabled = false
//        self.chartView.leftAxis.drawAxisLineEnabled = false
//        self.chartView.leftAxis.spaceBottom = 0.01
//        self.chartView.leftAxis.spaceTop = 0.01
//
//        self.chartView.noDataText = ""
//        self.chartView.backgroundColor = .clear
//        self.chartView.delegate = self
//
//        let marker = XPChartMarkerView(color: .neutralDarkPure, chartView: self.chartView)
//
//        self.chartView.marker = marker
//        self.chartView.drawMarkers = true
//
//        self.chartView.viewPortHandler.setMaximumScaleX(1)
//        self.chartView.viewPortHandler.setMaximumScaleY(1)
//    }
//
//    private func setupLineSet(_ values: [Double], color: UIColor) -> LineChartDataSet {
//        var chartValues = [ChartDataEntry]()
//
//        values.enumerated().forEach { (arg) in
//            let (i, value) = arg
//
//            chartValues.append(ChartDataEntry(x: Double(i), y: value))
//        }
//
//        let dataSet = LineChartDataSet(entries: chartValues, label: nil)
//        dataSet.setColor(color)
//        dataSet.lineWidth = CGFloat(2)
//        dataSet.drawCirclesEnabled = false
//        dataSet.drawIconsEnabled = false
//        dataSet.drawValuesEnabled = false
//        dataSet.drawHorizontalHighlightIndicatorEnabled = false
//
//        dataSet.highlightLineWidth = 2
//        dataSet.highlightColor = self.colors?.first ?? .clear
//        dataSet.highlightEnabled = true
//        dataSet.drawVerticalHighlightIndicatorEnabled = true
//        return dataSet
//    }
//
//    @objc private func handleGesture(_ gesture: UIGestureRecognizer) {
//        if gesture.state == .ended || gesture.state == .cancelled {
//            self.chartView.highlightValue(x: 0.0, dataSetIndex: -1)
//        } else {
//            let position = gesture.location(in: self.chartView)
//            let highlight = self.chartView.getHighlightByTouchPoint(position)
//
//            self.chartView.highlightValue(highlight, callDelegate: true)
//        }
//    }
//}
//
//extension XPMultipleLineChartView: ChartViewDelegate {
//    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        if self.lastIndexHighlighted != entry.x {
//
//            self.selectionFeedback.selectionChanged()
//            self.delegate?.updateValuesToPosition(Int(entry.x), highlightXPosition: self.convert(CGPoint(x: highlight.xPx, y: 0), to: self.superview).x)
//            self.lastIndexHighlighted = entry.x
//        }
//    }
//
//    func chartValueNothingSelected(_ chartView: ChartViewBase) {
//        self.delegate?.hideHighlightText()
//        self.lastIndexHighlighted = nil
//    }
//}
