//
//  INVSSimulatedChartsViewController.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 24/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit
import Charts

protocol INVSSimulatedChartsViewControllerProtocol: class {
    func displayCalculatedChartValues(withChartDataEntries chartDataEntries: [ChartDataEntry])
}

class INVSSimulatedChartsViewController: UIViewController {
    var containerView = UIView(frame: .zero)
    var chartView = LineChartView()
    var interactor: INVSSimulatedChartsInteractorProtocol?
    let router = INVSRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chartView.animate(xAxisDuration: 2, yAxisDuration: 2)
    }
    
    func setupChart(withMonths months: Int, simulatedValues:[INVSSimulatedValueModel]) {
        
        let interactor = INVSSimulatedChartsInteractor()
        interactor.simulatedValues = simulatedValues
        self.interactor = interactor
        let presenter = INVSSimulatedChartsPresenter()
        presenter.controller = self
        interactor.presenter = presenter
        
        chartView.delegate = self
        setInterativeCharts()
        hideChartsInfo()
        let lastValueWithoutRescue = (simulatedValues.last?.total ?? 0) + (simulatedValues.last?.rescue ?? 0)
        setLeftAxys(withFirstTotal: simulatedValues.first?.total ?? 0, withLastTotal: lastValueWithoutRescue)
        setXAxys(withMonths: months)
        setBallonMarker()
        interactor.calculateChartValues()
        
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
    
    func setXAxys(withMonths months: Int) {
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelCount = months
        xAxis.labelFont = .systemFont(ofSize: 10)
        chartView.xAxis.drawAxisLineEnabled = true
    }
    
    func setLeftAxys(withFirstTotal firstTotal: Double, withLastTotal lastTotal: Double) {
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativePrefix = "R$ "
        leftAxisFormatter.positivePrefix = "R$ "
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMaximum = lastTotal + (lastTotal * 0.1)
        leftAxis.axisMinimum = firstTotal - (firstTotal * 0.1)
        leftAxis.labelPosition = .outsideChart
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelCount = 40
        leftAxis.spaceTop = 0.15
        leftAxis.drawLimitLinesBehindDataEnabled = true
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
    
    func setGradientFilled(withDataSet dataSet: LineChartDataSet) {
        
        let gradientColors = UIColor.INVSGradientColors()
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        dataSet.fillAlpha = 1
        dataSet.fill = Fill(linearGradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true
    }

}

struct INVSChartModel {
    var valueWithRescue: Double
    var valueWithoutRescue: Double
    var month: Int
}

extension INVSSimulatedChartsViewController: INVSSimulatedChartsViewControllerProtocol {
        func displayCalculatedChartValues(withChartDataEntries chartDataEntries: [ChartDataEntry]) {
        let set = LineChartDataSet(entries: chartDataEntries, label: "DataSet da Simulação")
        set.lineWidth = 0
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
