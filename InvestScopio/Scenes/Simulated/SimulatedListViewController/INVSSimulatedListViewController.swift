//
//  INVSSimulatedListViewController.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 16/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Hero
import SkeletonView

protocol INVSSimulatedListViewControlerDelegate {
    func didFinishSimulating(withSimulatedValues simulatedValues: [INVSSimulatedValueModel], andShouldShowRescueChart showRescueChart: Bool)
}

protocol INVSSimulatedListViewControlerProtocol: class {
    func displaySimulationProjection(with simulatedValues: [INVSSimulatedValueModel], andShouldShowRescueChart showRescueChart: Bool)
}

class INVSSimulatedListViewController: UIViewController {

    var tableView = UITableView()
    
    var delegate: INVSSimulatedListViewControlerDelegate?
    var topTableviewConstraint = NSLayoutConstraint()
    var hasLoaded:Bool = false
    var interactor: INVSSimulatedListInteractorProtocol?
    let router = INVSRouter()
    var dataSource = INVSSimulatorTableviewDataSourceDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if topTableviewConstraint.constant != 0 {
            topTableviewConstraint.constant = 0
            UIView.animate(withDuration: 2) {
                self.view.layoutIfNeeded()
            }
            interactor?.simulationProjection()
            setupSkeletonView()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupTableView() {
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = 100
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
    func setupSkeletonView() {
        view.isSkeletonable = true
        tableView.isSkeletonable = true
        
    }
    
    func setup(withSimulatorModel simulatorModel:INVSSimulatorModel) {
        let interactor = INVSSimulatedListInteractor()
        interactor.simulatorModel = simulatorModel
        self.interactor = interactor
        let presenter = INVSSimulatedListPresenter()
        presenter.controller = self
        interactor.presenter = presenter
    }
    
    public override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tableView.reloadData()
    }
}

extension INVSSimulatedListViewController: INVSCodeView {
    func buildViewHierarchy() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        topTableviewConstraint = tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            topTableviewConstraint
            ])
        
    }
    
    func setupAdditionalConfiguration() {
        tableView.backgroundColor = .INVSGray()
        tableView.separatorStyle = .none
        
        let bundle = Bundle(for: type(of: self))
        let simulatorCellNib = UINib(nibName: INVSConstants.SimulatorCellConstants.cellIdentifier.rawValue, bundle: bundle)
        let simulatorHeaderlNib = UINib(nibName: INVSConstants.SimulatorCellConstants.tableViewHeaderName.rawValue, bundle: bundle)
        tableView.register(simulatorCellNib, forCellReuseIdentifier: INVSConstants.SimulatorCellConstants.cellIdentifier.rawValue)
        tableView.register(simulatorHeaderlNib, forHeaderFooterViewReuseIdentifier: INVSConstants.SimulatorCellConstants.tableViewHeaderName.rawValue)
    }
}

extension INVSSimulatedListViewController: INVSSimulatedListViewControlerProtocol{
    func displaySimulationProjection(with simulatedValues: [INVSSimulatedValueModel], andShouldShowRescueChart showRescueChart: Bool) {
        dataSource.setup(withSimulatedValues: simulatedValues)
        tableView.reloadData()
        delegate?.didFinishSimulating(withSimulatedValues: simulatedValues, andShouldShowRescueChart: showRescueChart)
        
    }
}
