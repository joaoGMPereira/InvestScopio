//
//  INVSSimulatedChartsViewController.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 24/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit
import Charts

class INVSSimulatedChartsViewController: UIViewController {
    var containerView = UIView(frame: .zero)
    var chartView = LineChartView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupChart(withMonths months: Int, simulatedValues:[INVSSimulatedValueModel]) {
        chartView.delegate = self
        chartView.setScaleEnabled(true)
        setLeftAxys(withLastTotal: simulatedValues.last?.total ?? 0)
        setXAxys()
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        chartView.chartDescription?.enabled = false
        chartView.rightAxis.enabled = false
        chartView.rightAxis.drawAxisLineEnabled = false


        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.drawGridBackgroundEnabled = false
        
        self.setDataCount(months, simulatedValues: simulatedValues)
    }
    
    func setXAxys() {
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        chartView.xAxis.drawAxisLineEnabled = true
    }
    
    func setLeftAxys(withLastTotal lastTotal: Double) {
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativePrefix = " R$"
        leftAxisFormatter.positivePrefix = " R$"
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = lastTotal * 2
        leftAxis.axisMinimum = 0
        leftAxis.labelPosition = .outsideChart
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.spaceTop = 0.15
        leftAxis.drawLimitLinesBehindDataEnabled = true
    }
    
    func setDataCount(_ monthsCount: Int, simulatedValues: [INVSSimulatedValueModel]) {
        
        let block: (Int) -> ChartDataEntry = { (month) -> ChartDataEntry in
            let simulatedValue = simulatedValues[month]
            return ChartDataEntry(x: Double(month), y: simulatedValue.total ?? 0)
        }
        let yVals = (0..<monthsCount).map(block)
        let set = LineChartDataSet(entries: yVals, label: "DataSet \(1)")
        set.lineWidth = 2.5
        set.drawCirclesEnabled = false
        set.setColor(.INVSDefault())
        set.colors = [.INVSDefault()]
        set.circleColors = [.INVSDefault()]
        
        let data = LineChartData(dataSets: [set])
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        chartView.data = data
    }

}

extension INVSSimulatedChartsViewController: ChartViewDelegate {
    
}

extension INVSSimulatedChartsViewController: INVSCodeView {
    func buildViewHierarchy() {
        view.addSubview(containerView)
        containerView.addSubview(chartView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        chartView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chartView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        
    }
    
    func setupAdditionalConfiguration() {
    }
    
    
}
