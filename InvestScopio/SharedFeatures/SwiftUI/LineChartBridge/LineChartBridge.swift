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

struct LineChart: UIViewRepresentable {
    //public var data = ChartDataBase()
    
    @EnvironmentObject var data: ChartDataBaseBridge
    @EnvironmentObject var dataSet: LineChartDataSetBaseBridge
     var entries: [ChartDataEntry]
     var months: Int
     var granularity: Double
     var axisMaximum: Double
     var label: String
    
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
        return chartView
    }
    
    func setInterativeCharts(chartView: LineChartView) {
        chartView.dragEnabled = data.interativeData.dragEnabled
        chartView.setScaleEnabled(data.interativeData.scaleEnabled)
        chartView.pinchZoomEnabled = data.interativeData.pinchZoomEnabled
    }
    
    func setChartsInfo(chartView: LineChartView) {
        chartView.chartDescription?.enabled = data.informationData.chartDescription.enabled
        chartView.rightAxis.enabled = data.informationData.rightAxis.enabled
        chartView.rightAxis.drawAxisLineEnabled = data.informationData.rightAxis.drawAxisLineEnabled
        chartView.leftAxis.drawGridLinesEnabled = data.informationData.leftAxis.drawGridLinesEnabled
        chartView.xAxis.drawGridLinesEnabled = data.informationData.xAxis.drawGridLinesEnabled
        chartView.drawGridBackgroundEnabled = data.informationData.drawGridBackgroundEnabled
    }
    
    private func setBallonMarker(chartView: LineChartView) {
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
    }
    
    func setChartsEntries(chartView: LineChartView) {
        let set = LineChartDataSet(entries: entries, label: label)
        set.setColor(dataSet.color)
        set.colors = dataSet.colors
        set.setCircleColor(dataSet.circleColor)
        set.lineWidth = dataSet.lineWidth
        set.circleRadius = dataSet.circleRadius
        set.circleHoleRadius = dataSet.circleHoleRadius
        set.drawCircleHoleEnabled = dataSet.drawCircleHoleEnabled
        set.circleColors = dataSet.circleColors
        setGradientFilled(dataSet: set)
        
        let data = LineChartData(dataSets: [set])
        data.setDrawValues(dataSet.drawValues)
        data.setValueFont(dataSet.valueFont)
        chartView.data = data
        chartView.animate(xAxisDuration: dataSet.xAxisDuration, yAxisDuration: dataSet.yAxisDuration)
    }
    
    private func setGradientFilled(dataSet: LineChartDataSet) {
        
        let gradientColors = data.informationData.gradient.colors
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        dataSet.fillAlpha = data.informationData.gradient.alpha
        dataSet.fill = Fill(linearGradient: gradient, angle: data.informationData.gradient.angle)
        dataSet.drawFilledEnabled = data.informationData.gradient.drawFilledEnabled
    }
    
    func setLeftAxys(chartView: LineChartView) {
        let leftAxis = chartView.leftAxis
        leftAxis.axisMaximum = axisMaximum + (axisMaximum * 0.1)
        leftAxis.axisMinimum = data.informationData.leftAxis.axisMinimum
        leftAxis.labelPosition = .outsideChart
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: data.informationData.leftAxis.formatter)
        leftAxis.labelCount = data.informationData.leftAxis.labelCount
        leftAxis.spaceTop = data.informationData.leftAxis.spaceTop
        leftAxis.drawLimitLinesBehindDataEnabled = data.informationData.leftAxis.drawLimitLinesBehindDataEnabled
    }
    
    func setXAxys(chartView: LineChartView) {
        let xAxis = chartView.xAxis
        xAxis.labelPosition = data.informationData.xAxis.labelPosition
        xAxis.labelCount = months
        xAxis.labelFont = data.informationData.xAxis.labelFont
        let numberFormatter = data.informationData.xAxis.formatter
        xAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: numberFormatter)
        xAxis.granularity = granularity
        chartView.xAxis.drawAxisLineEnabled = data.informationData.xAxis.drawAxisLineEnabled
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        setInterativeCharts(chartView: uiView)
        setChartsInfo(chartView: uiView)
        setChartsEntries(chartView: uiView)
        setLeftAxys(chartView: uiView)
        setXAxys(chartView: uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        return LineChart(entries: [ChartDataEntry(x: 0, y: 0)], months: 10, granularity: 1, axisMaximum: 100, label: "teste").setChartDataBase().setChartDataSet()
    }
}
