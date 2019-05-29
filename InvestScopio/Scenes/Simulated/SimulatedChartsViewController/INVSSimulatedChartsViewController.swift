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
    func displayTotalCalculatedChartValues(withTotalChartDataEntries totalChartDataEntries: [ChartDataEntry])
    func displayTotalSegmentedControl(withMonths months: [String])
    func displayTotalLeftAxys(withLastTotal lastTotal: Double)
    func displayTotalXAxys(withMonths months: Int, andGranularity granularity:Double)
    
    func displayRescueCalculatedChartValues(withRescueChartDataEntries rescueChartDataEntries: [ChartDataEntry])
    func displayRescueLeftAxys(withLastRescue lastRescue: Double)
    func displayRescueXAxys(withMonths months: Int, andGranularity granularity:Double)
}

class INVSSimulatedChartsViewController: UIViewController {
    var containerView = UIView(frame: .zero)
    var totalChartView = INVSSimulatedTotalChartView()
    var rescueChartView = INVSSimulatedRescueChartView()
    var monthsSegmentedControl: BetterSegmentedControl!
    var chartTypeSegmentedControl: BetterSegmentedControl!
    var interactor: INVSSimulatedChartsInteractorProtocol?
    let router = INVSRouter()
    private var showRescueChart = false
    private var isTotalChart: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupChart(withSimulatedValues simulatedValues:[INVSSimulatedValueModel], andShouldShowRescueChart showRescueChart: Bool) {
        self.showRescueChart = showRescueChart
        let interactor = INVSSimulatedChartsInteractor()
        interactor.simulatedValues = simulatedValues
        self.interactor = interactor
        let presenter = INVSSimulatedChartsPresenter()
        presenter.controller = self
        interactor.presenter = presenter
        totalChartView.setupChart()
        rescueChartView.isHidden = true
        rescueChartView.setupChart()
        setupChartTypeSegmentedControl()
        interactor.setSegmentControl()
        interactor.calculateChartValues(withMonths: 3)
    }
    
    private func setupChartTypeSegmentedControl() {
        chartTypeSegmentedControl = BetterSegmentedControl.init(
            frame: .zero,
            segments: LabelSegment.segments(withTitles: ["Total", "Resgate"],
                                            normalFont: UIFont(name: "Avenir", size: 13.0)!,
                                            normalTextColor: .INVSDefault(),
                                            selectedFont: UIFont(name: "Avenir", size: 13.0)!,
                                            selectedTextColor: .white),
            options:[.backgroundColor(.white),
                     .indicatorViewBackgroundColor(.INVSDefault()),
                     .cornerRadius(15.0),
                     .bouncesOnChange(true)
            ])
        chartTypeSegmentedControl.addTarget(self, action: #selector(INVSSimulatedChartsViewController.segmentedControlChartTypeChanged(_:)), for: .valueChanged)
    }
    
    @IBAction func segmentedControlChartTypeChanged(_ sender: BetterSegmentedControl) {
        isTotalChart = !isTotalChart
        
        let profitabilityView = isTotalChart ? totalChartView : rescueChartView
        let rescueView = isTotalChart ? rescueChartView : totalChartView
        
        UIView.transition(from: profitabilityView,
                          to: rescueView,
                          duration: 0.5,
                          options: [.transitionFlipFromTop, .showHideTransitionViews],
                          completion: nil)
    }
    
    @IBAction func segmentedControlMonthChanged(_ sender: BetterSegmentedControl) {
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

extension INVSSimulatedChartsViewController: INVSSimulatedChartsViewControllerProtocol {
    
    func displayTotalCalculatedChartValues(withTotalChartDataEntries totalChartDataEntries: [ChartDataEntry]) {
        totalChartView.displayCalculatedChartValues(withChartDataEntries: totalChartDataEntries)
    }
    
    
    func displayTotalLeftAxys(withLastTotal lastTotal: Double) {
        totalChartView.displayLeftAxys(withLastTotal: lastTotal)
    }
    
    func displayTotalXAxys(withMonths months: Int, andGranularity granularity:Double) {
        totalChartView.displayXAxys(withMonths: months, andGranularity: granularity)
    }
    
    func displayTotalSegmentedControl(withMonths months: [String]) {
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
        monthsSegmentedControl.addTarget(self, action: #selector(INVSSimulatedChartsViewController.segmentedControlMonthChanged(_:)), for: .valueChanged)
    }
    
    func displayRescueCalculatedChartValues(withRescueChartDataEntries rescueChartDataEntries: [ChartDataEntry]) {
        rescueChartView.displayCalculatedChartValues(withChartDataEntries: rescueChartDataEntries)
    }
    
    func displayRescueLeftAxys(withLastRescue lastRescue: Double) {
        rescueChartView.displayLeftAxys(withLastRescue: lastRescue)
    }
    
    func displayRescueXAxys(withMonths months: Int, andGranularity granularity: Double) {
        rescueChartView.displayXAxys(withMonths: months, andGranularity: granularity)
    }
}

extension INVSSimulatedChartsViewController: INVSCodeView {
    func buildViewHierarchy() {
        view.addSubview(containerView)
        containerView.addSubview(rescueChartView)
        containerView.addSubview(totalChartView)
        containerView.addSubview(monthsSegmentedControl)
        containerView.addSubview(chartTypeSegmentedControl)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        rescueChartView.translatesAutoresizingMaskIntoConstraints = false
        totalChartView.translatesAutoresizingMaskIntoConstraints = false
        monthsSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        chartTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            monthsSegmentedControl.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            monthsSegmentedControl.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            monthsSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            monthsSegmentedControl.heightAnchor.constraint(equalToConstant: 30)
            ])
        
        NSLayoutConstraint.activate([
            chartTypeSegmentedControl.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            chartTypeSegmentedControl.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            chartTypeSegmentedControl.topAnchor.constraint(equalTo: monthsSegmentedControl.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            chartTypeSegmentedControl.heightAnchor.constraint(equalToConstant: self.showRescueChart ? 30 : 0)
            ])
        
        NSLayoutConstraint.activate([
            rescueChartView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            rescueChartView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            rescueChartView.topAnchor.constraint(equalTo: chartTypeSegmentedControl.safeAreaLayoutGuide.bottomAnchor),
            rescueChartView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            totalChartView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            totalChartView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            totalChartView.topAnchor.constraint(equalTo: chartTypeSegmentedControl.safeAreaLayoutGuide.bottomAnchor),
            totalChartView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        
    }
    
    func setupAdditionalConfiguration() {

    }
}
