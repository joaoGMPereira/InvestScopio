//
//  INVSSimulatedProfitabilityChartView.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 28/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit
import Charts

class INVSSimulatedTotalChartView: UIView {
    var chartView = LineChartView()
    
    func setupChart() {
        setupView()
        chartView.delegate = self
        setInterativeCharts()
        hideChartsInfo()
        setBallonMarker()
    }
    
    func setInterativeCharts() {
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
    }
    
    func hideChartsInfo() {
        chartView.chartDescription?.enabled = false
        chartView.rightAxis.enabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.drawGridBackgroundEnabled = false
    }
    
    func setBallonMarker() {
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
    }

}

extension INVSSimulatedTotalChartView: INVSCodeView {
    func buildViewHierarchy() {
        addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            chartView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            chartView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    func setupAdditionalConfiguration() {
    }
}

extension INVSSimulatedTotalChartView {
    func displayCalculatedChartValues(withChartDataEntries chartDataEntries: [ChartDataEntry]) {
        let set = LineChartDataSet(entries: chartDataEntries, label: "DataSet da Simulação")
        set.setColor(.INVSDefault())
        set.colors = [.INVSDefault()]
        set.setCircleColor(.black)
        set.lineWidth = 1
        set.circleRadius = 2
        set.circleHoleRadius = 1
        set.drawCircleHoleEnabled = true
        set.circleColors = [.INVSDefault()]
        setGradientFilled(withDataSet: set)
        
        let data = LineChartData(dataSets: [set])
        data.setDrawValues(false)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        chartView.data = data
        chartView.animate(xAxisDuration: 2, yAxisDuration: 2)
    }
    
    private func setGradientFilled(withDataSet dataSet: LineChartDataSet) {
        
        let gradientColors = UIColor.INVSGradientColors()
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        dataSet.fillAlpha = 1
        dataSet.fill = Fill(linearGradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true
    }
    
    func displayLeftAxys(withLastTotal lastTotal: Double) {
        let leftAxisFormatter = NumberFormatter.currencyDefault()
        leftAxisFormatter.negativePrefix = "R$ "
        leftAxisFormatter.positivePrefix = "R$ "
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMaximum = lastTotal + (lastTotal * 0.1)
        leftAxis.axisMinimum = 0
        leftAxis.labelPosition = .outsideChart
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelCount = 40
        leftAxis.spaceTop = 0.15
        leftAxis.drawLimitLinesBehindDataEnabled = true
    }
    
    func displayXAxys(withMonths months: Int, andGranularity granularity:Double) {
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelCount = months
        xAxis.labelFont = .systemFont(ofSize: 10)
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        xAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: numberFormatter)
        xAxis.granularity = granularity
        chartView.xAxis.drawAxisLineEnabled = true
    }
}


extension INVSSimulatedTotalChartView: ChartViewDelegate {
    
    
}
