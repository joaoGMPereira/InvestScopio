//
//  INVSSimulationsViewController.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 24/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit
import Lottie

protocol INVSSimulationsViewControllerProtocol: class, INVSConnectorErrorProtocol {
    func displaySimulations(withSimulations simulations: [INVSSimulatorModel])
    func displayDeleteSimulation(withDeleteSimulation deleteSimulation: INVSDeleteSimulationResponse)
    func displayDeleteAllSimulations(withDeleteSimulation deleteSimulation: INVSDeleteSimulationResponse)
}

class INVSSimulationsViewController: UIViewController {
    
    @IBOutlet weak var secondNoneSimulationLabel: UILabel!
    @IBOutlet weak var noneSimulationsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var cleanButton: INVSLoadingButton!
    @IBOutlet weak var simulateButton: INVSLoadingButton!
    @IBOutlet weak var bottomStackViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    let router: INVSRoutingLogic? = INVSRouter()
    var interactor: INVSSimulationsInteractorProtocol?
    var reloadView = AnimationView()
    var popupMessage: INVSPopupMessage?
    var dataSource = INVSSimulationsTableviewDataSourceDelegate()
    var deleteCompletion : DidFinishDeleteSimulation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Simulações"
        let interactor = INVSSimulationsInteractor()
        self.interactor = interactor
        let presenter = INVSSimulationsPresenter()
        presenter.controller = self
        interactor.presenter = presenter
        popupMessage = INVSPopupMessage(parentViewController: self)
        popupMessage?.delegate = self
        noneSimulationsLabel.alpha = 0
        secondNoneSimulationLabel.alpha = 0

        noneSimulationsLabel.attributedText = NSAttributedString.title(withText: "Faça uma nova simulação a qualquer momento!")
        secondNoneSimulationLabel.attributedText = NSAttributedString.titleBold(withText: ";D")
        secondNoneSimulationLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTableView()
        setupRightNavigationItem()
        setupSkeletonView()
        setupBottomButtons()
    }
    
    func setupBottomButtons() {
        cleanButton.button.isEnabled = false
        cleanButton.setupBorded(withColor: .INVSDefault(), title: "Limpar Histórico", andRounded: true)
        cleanButton.buttonAction = {(button) in
            self.cleanButton.showLoading()
            self.interactor?.deleteAllSimulations()
        }
        
        simulateButton.setupFillGradient(withColor: UIColor.INVSGradientColors(), title: "Nova Simulação", andRounded: true)
        simulateButton.buttonAction = {(button) in
            AppDelegate.appDelegate().tabBarController.selectedIndex = 1
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupTableView() {
        tableViewHeightConstraint.constant = view.safeAreaLayoutGuide.layoutFrame.height - 66
        view.backgroundColor = .INVSLightGray()
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        dataSource.delegate = self
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.separatorStyle = .none
        let bundle = Bundle(for: type(of: self))
        let simulatorCellNib = UINib(nibName: INVSConstants.SimulationCellConstants.cellIdentifier.rawValue, bundle: bundle)
        tableView.register(simulatorCellNib, forCellReuseIdentifier: INVSConstants.SimulationCellConstants.cellIdentifier.rawValue)
        view.layoutIfNeeded()
        reloadSimulations()
        
    }
    
    func setupSkeletonView() {
        view.isSkeletonable = true
        tableView.isSkeletonable = true
    }
    
    func setupRightNavigationItem() {
        let loadAnimation = Animation.named("refreshAnimationPurple")
        reloadView.animation = loadAnimation
        reloadView.contentMode = .scaleAspectFit
        reloadView.animationSpeed = 1.0
        reloadView.loopMode = .playOnce
        reloadView.play(fromFrame: 20, toFrame: 121, loopMode: .playOnce) { (finished) in
            
        }
        
        let touchUpInsideReloadView = UITapGestureRecognizer.init(target: self, action: #selector(reloadSimulations))
        reloadView.addGestureRecognizer(touchUpInsideReloadView)
        
        let rightItem = UIBarButtonItem(customView: reloadView)
        let reloadWidth = rightItem.customView?.widthAnchor.constraint(equalToConstant: 44)
        reloadWidth?.isActive = true
        let reloadHeight = rightItem.customView?.heightAnchor.constraint(equalToConstant: 44)
        reloadHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func reloadSimulations() {
        showMickSimulations()
        dataSource.setup(withSimulations: [INVSSimulatorModel]())
        tableView.reloadData()
        
        interactor?.getSimulations()
        reloadView.play(fromFrame: 0, toFrame: 121, loopMode: .loop)
    }

}

extension INVSSimulationsViewController: INVSSimulationsTableviewDataSourceDelegateProtocol {
    
    func didSelect(withSimulation simulation: INVSSimulatorModel) {
        router?.routeToSimulated(withViewController: self, andSimulatorModel: simulation)
    }
    
    func didDelete(withSimulation simulation: INVSSimulatorModel, completion: @escaping (DidFinishDeleteSimulation)) {
        deleteCompletion = completion
        interactor?.deleteSimulation(withSimulation: simulation)
    }
    
    func removeAllSimulations() {
        cleanButton.button.isEnabled = false
        tableViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.4) {
            self.noneSimulationsLabel.alpha = 1
            self.secondNoneSimulationLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func showMickSimulations() {
        tableViewHeightConstraint.constant = view.safeAreaLayoutGuide.layoutFrame.height - 66
        UIView.animate(withDuration: 0.4) {
            self.noneSimulationsLabel.alpha = 0
            self.secondNoneSimulationLabel.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
}

extension INVSSimulationsViewController: INVSPopupMessageDelegate {
    func didFinishDismissPopupMessage(withPopupMessage popupMessage: INVSPopupMessage) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension INVSSimulationsViewController: INVSSimulationsViewControllerProtocol {
    
    func displaySimulations(withSimulations simulations: [INVSSimulatorModel]) {
        reloadView.play(fromFrame: 20, toFrame: 121, loopMode: .playOnce)
        if simulations.count > 0 {
            cleanButton.button.isEnabled = true
            self.noneSimulationsLabel.alpha = 0
            secondNoneSimulationLabel.alpha = 0
            
            dataSource.setup(withSimulations: simulations)
            tableView.reloadData()
            animateVisibleCells()
        } else {
            removeAllSimulations()
        }
    }
    
    private func animateVisibleCells() {
        let cells = tableView.visibleCells
        let tableViewHeight: CGFloat = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        var index = 0
        for cell in cells {
            
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            index += 1
        }
        
    }
    
    func displayDeleteSimulation(withDeleteSimulation deleteSimulation: INVSDeleteSimulationResponse) {
        if let completion = deleteCompletion {
            popupMessage?.show(withTextMessage: deleteSimulation.message, title: "Atenção\n", popupType: .alert, shouldHideAutomatically: true, sender: nil)
            completion(deleteSimulation.deleted)
        }
    }
    
    func displayDeleteAllSimulations(withDeleteSimulation deleteSimulation: INVSDeleteSimulationResponse) {
        cleanButton.hideLoading()
        popupMessage?.show(withTextMessage: deleteSimulation.message, title: "Atenção\n", popupType: .alert, shouldHideAutomatically: true, sender: nil)
        removeAllSimulations()
        
    }
    
    func displayErrorDefault(titleError: String, messageError: String, shouldHideAutomatically: Bool, popupType: INVSPopupMessageType) {
        cleanButton.hideLoading()
        popupMessage?.show(withTextMessage: messageError, title: titleError, popupType: popupType, shouldHideAutomatically: shouldHideAutomatically, sender: nil)
    }
    
    func displayErrorAuthentication(titleError: String, messageError: String, shouldRetry: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        INVSConnectorHelpers.presentErrorRememberedUserLogged(lastViewController: self, message: messageError, title: titleError, shouldRetry: shouldRetry, successCompletion: {
            self.tabBarController?.tabBar.isHidden = false
            self.interactor?.getSimulations()
        }) {
            self.tabBarController?.tabBar.isHidden = false
            self.goToLogin()
        }
    }
    
    func displayErrorSettings(titleError: String, messageError: String) {
        self.tabBarController?.tabBar.isHidden = true
        INVSConnectorHelpers.presentErrorGoToSettingsRememberedUserLogged(lastViewController: self, message: messageError, title: titleError, finishCompletion: {
            self.tabBarController?.tabBar.isHidden = false
            self.goToLogin()
        })
    }
    
    func displayErrorLogout(titleError: String, messageError: String) {
        self.tabBarController?.tabBar.isHidden = true
        INVSConnectorHelpers.presentErrorRememberedUserLogged(lastViewController: self) {
            self.tabBarController?.tabBar.isHidden = false
            self.goToLogin()
        }
    }
    
    func goToLogin() {
        self.dismiss(animated: false, completion: nil)
        router?.routeToLogin()
    }
    
}
