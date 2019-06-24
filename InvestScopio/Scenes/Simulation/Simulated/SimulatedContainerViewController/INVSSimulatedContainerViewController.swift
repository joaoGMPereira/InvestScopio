//
//  INVSSimulatedContainerViewController.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 23/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit

class INVSSimulatedContainerViewController: INVSPresentBaseViewController {
    var containerView = UIView(frame: .zero)
    var switchView = INVSSwitchView(frame: .zero)
    let simulatedListViewController = INVSSimulatedListViewController()
    let simulatedChartsViewController = INVSSimulatedChartsViewController()
    
    var heightSwitchViewConstraint = NSLayoutConstraint()
    let router: INVSRoutingLogic? = INVSRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSimulatedViewControllerToContainer()
        closeClosure = { () -> () in
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func addSimulatedViewControllerToContainer() {
        showLoading()
        simulatedListViewController.delegate = self
        addChild(simulatedListViewController)
        simulatedListViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        simulatedListViewController.view.frame = containerView.bounds
        
        containerView.addSubview(simulatedListViewController.view)
        simulatedListViewController.didMove(toParent: self)
    }
    
    func showSwitchView() {
        let listButton = UIButton()
        listButton.setTitleColor(.INVSBlack(), for: .normal)
        listButton.setTitle("Lista", for: .normal)
        listButton.backgroundColor = .white
        let chartsButton = UIButton()
        chartsButton.setTitleColor(.INVSBlack(), for: .normal)
        chartsButton.setTitle("Grafico", for: .normal)
        chartsButton.backgroundColor = .white
        switchView.setup(withSwitchButtons: [listButton, chartsButton])
        switchView.delegate = self
        heightSwitchViewConstraint.constant = 70
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
}

extension INVSSimulatedContainerViewController: INVSCodeView {
    func buildViewHierarchy() {
        view.addSubview(switchView)
        view.addSubview(containerView)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        heightSwitchViewConstraint = switchView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            switchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            switchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            switchView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor, constant: 1),
            heightSwitchViewConstraint
            ])
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: switchView.bottomAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        
    }
    
    func setupAdditionalConfiguration() {
        containerView.backgroundColor = .clear
    }
    
    
}

extension INVSSimulatedContainerViewController: INVSSwitchViewDelegate, INVSSimulatedListViewControlerDelegate {
    func didFinishSimulating(withSimulatedValues simulatedValues: [INVSSimulatedValueModel], andShouldShowRescueChart showRescueChart: Bool) {
        simulatedChartsViewController.setupChart(withSimulatedValues: simulatedValues, andShouldShowRescueChart: showRescueChart)
        hideLoading()
        showSwitchView()
    }
    
    func didSelectButton(_ sender: UIButton) {
        switchView.isUserInteractionEnabled = false
        if sender.titleLabel?.text == "Grafico" {
            router?.showNextViewController(withNewController: simulatedChartsViewController, withOldController: simulatedListViewController, andParentViewController: self, withAnimation: .transitionFlipFromLeft, completion: {finished in
                self.switchView.isUserInteractionEnabled = finished
            })
        }
        if sender.titleLabel?.text == "Lista" {
            router?.showNextViewController(withNewController: simulatedListViewController, withOldController: simulatedChartsViewController, andParentViewController: self, withAnimation: .transitionFlipFromRight, completion: {finished in
                self.switchView.isUserInteractionEnabled = finished
            })
        }
    }
}

