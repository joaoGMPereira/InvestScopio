//
//  INVSSimulatedViewController.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 16/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Hero
class INVSSimulatedViewController: INVSPresentBaseViewController {

    var tableView = UITableView()
    var heightTableviewConstraint = NSLayoutConstraint()
    
    
    var dataSource = INVSSimulatorTableviewDataSourceDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        heightTableviewConstraint.constant = view.frame.height - navigationBarHeight
        UIView.animate(withDuration: 2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setup(withSimulatedValues simulatedValues:[INVSSimulatedValueModel]) {
        dataSource.setup(withSimulatedValues: simulatedValues)
        reloadTableView()
    }
    
    private func reloadTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.reloadData()
    }
}

extension INVSSimulatedViewController: INVSCodeView {
    func buildViewHierarchy() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        heightTableviewConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            heightTableviewConstraint
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

extension INVSSimulatedViewController {
    func displayClear() {
        dataSource.setup(withSimulatedValues: [INVSSimulatedValueModel]())
        reloadTableView()
    }
}

