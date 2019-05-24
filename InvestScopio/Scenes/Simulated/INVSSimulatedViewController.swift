//
//  INVSSimulatedViewController.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 16/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Hero
import SkeletonView

protocol INVSSimutatedViewControlerProtocol: class {
    func displaySimulationProjection(with simulatedValues: [INVSSimulatedValueModel])
    func displayLoading()
    func dismissLoading()
}

class INVSSimulatedViewController: INVSPresentBaseViewController {

    var tableView = UITableView()
    
    var topTableviewConstraint = NSLayoutConstraint()
    var hasLoaded:Bool = false
    var interactor: INVSSimulatedInteractorProtocol?
    let router = INVSRouter()
    var dataSource = INVSSimulatorTableviewDataSourceDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.simulationProjection()
        setupSkeletonView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            topTableviewConstraint.constant = navigationBarHeight + 8
            UIView.animate(withDuration: 3) {
                self.view.layoutIfNeeded()
            }
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
        let interactor = INVSSimulatedInteractor()
        interactor.simulatorModel = simulatorModel
        self.interactor = interactor
        let presenter = INVSSimulatedPresenter()
        presenter.controller = self
        interactor.presenter = presenter
    }
    
    public override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tableView.reloadData()
    }
}

extension INVSSimulatedViewController: INVSCodeView {
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

extension INVSSimulatedViewController: INVSSimutatedViewControlerProtocol{
    func displaySimulationProjection(with simulatedValues: [INVSSimulatedValueModel]) {
        dataSource.setup(withSimulatedValues: simulatedValues)
        tableView.reloadData()
    }
    
    func displayLoading() {
        showLoading()
    }
    
    func dismissLoading() {
        hideLoading()
    }
}

