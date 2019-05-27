//
//  INVSSimulatedChartsViewController.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 24/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit
import Charts
import BetterSegmentedControl

protocol INVSSimulatedChartsViewControllerProtocol: class {
    func displayCalculatedChartValues(withChartDataEntries chartDataEntries: [ChartDataEntry])
    func displaySegmentedControl(withMonths months: [String])
    func displayLeftAxys(withFirstTotal firstTotal: Double, withLastTotal lastTotal: Double)
    func displayXAxys(withMonths months: Int)
}

class INVSSimulatedChartsViewController: UIViewController {
    var containerView = UIView(frame: .zero)
    var chartView = LineChartView()
    var monthsSegmentedControl: BetterSegmentedControl!
    var interactor: INVSSimulatedChartsInteractorProtocol?
    let router = INVSRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupChart(withSimulatedValues simulatedValues:[INVSSimulatedValueModel]) {
        
        let interactor = INVSSimulatedChartsInteractor()
        interactor.simulatedValues = simulatedValues
        self.interactor = interactor
        let presenter = INVSSimulatedChartsPresenter()
        presenter.controller = self
        interactor.presenter = presenter
        chartView.delegate = self
        setInterativeCharts()
        hideChartsInfo()

        setBallonMarker()
        interactor.setSegmentControl()
        interactor.calculateChartValues(withMonths: 3)
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
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        xAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: numberFormatter)
        xAxis.granularity = 1
        if months > 12 {
            xAxis.granularity = 4
            if months > 50 {
                xAxis.granularity = Double(months) * 0.1
            }
        }
        chartView.xAxis.drawAxisLineEnabled = true
    }
    
    func setLeftAxys(withFirstTotal firstTotal: Double, withLastTotal lastTotal: Double) {
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
    
    @IBAction func segmentedControl1ValueChanged(_ sender: BetterSegmentedControl) {
        for (index, segment) in sender.segments.enumerated() {
            if let labelSegment = segment as? LabelSegment {
                if index == sender.index {
                    let months = Int(labelSegment.text?.stringOfNumbersRegex() ?? "")
                    interactor?.calculateChartValues(withMonths: months)
                }
            }
        }
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
        chartView.animate(xAxisDuration: 2, yAxisDuration: 2)
    }
    
    func displayLeftAxys(withFirstTotal firstTotal: Double, withLastTotal lastTotal: Double) {
        setLeftAxys(withFirstTotal: firstTotal, withLastTotal: lastTotal)
        
    }
    
    func displaySegmentedControl(withMonths months: [String]) {
        monthsSegmentedControl = BetterSegmentedControl.init(
            frame: .zero,
            segments: LabelSegment.segments(withTitles: months,
                                            normalFont: UIFont(name: "Avenir", size: 13.0)!,
                                            normalTextColor: .INVSDefault(),
                                            selectedFont: UIFont(name: "Avenir", size: 13.0)!,
                                            selectedTextColor: .white),
            options:[.backgroundColor(.white),
                     .indicatorViewBackgroundColor(.INVSDefault()),
                     .cornerRadius(15.0),
                     .bouncesOnChange(true)
            ])
        monthsSegmentedControl.addTarget(self, action: #selector(INVSSimulatedChartsViewController.segmentedControl1ValueChanged(_:)), for: .valueChanged)
    }
    
    func displayXAxys(withMonths months: Int) {
        setXAxys(withMonths: months)
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
        containerView.addSubview(monthsSegmentedControl)
        monthsSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            monthsSegmentedControl.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            monthsSegmentedControl.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            monthsSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            monthsSegmentedControl.heightAnchor.constraint(equalToConstant: 30)
            ])
        
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            chartView.topAnchor.constraint(equalTo: monthsSegmentedControl.safeAreaLayoutGuide.bottomAnchor),
            chartView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        
    }
    
    func setupAdditionalConfiguration() {

    }
}
