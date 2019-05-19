//
//  PresentBaseViewController.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 16/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class INVSPresentBaseViewController: UIViewController {
    var navigationBarView = UIView()
    var navigationBarTitle = "Simulação" {
        didSet {
            navigationBarLabel.text = navigationBarTitle
        }
    }
    var navigationBarTitleColor : UIColor = .INVSBlack() {
        didSet {
            navigationBarLabel.textColor = navigationBarTitleColor
        }
    }
    var closeButton = UIButton()
    var navigationBarHeight: CGFloat = 44
    private var navigationBarLabel = UILabel()
    private var contentView = UIView()
    private var shadowLayer: CAShapeLayer!
    private var heightNavigationBarConstraint = NSLayoutConstraint()
    private var topNavigationBarConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shadowLayer == nil {
            navigationBarHeight = view.safeAreaInsets.top + 44
            heightNavigationBarConstraint.constant = navigationBarHeight
            topNavigationBarConstraint.constant = view.safeAreaInsets.top
            UIView.animate(withDuration: 1.6) {
                self.view.layoutIfNeeded()
                self.shadowLayer = CAShapeLayer.addShadow(withRoundedCorner: 1, andColor: .INVSLightGray(), inView: self.navigationBarView)
            }
        }
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

}

extension INVSPresentBaseViewController {
    private func buildViewHierarchy() {
        view.addSubview(navigationBarView)
        navigationBarView.addSubview(contentView)
        contentView.addSubview(closeButton)
        contentView.addSubview(navigationBarLabel)
        
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        navigationBarLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        heightNavigationBarConstraint = navigationBarView.heightAnchor.constraint(equalToConstant: 0)
        topNavigationBarConstraint = contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top)
        NSLayoutConstraint.activate([
            navigationBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            navigationBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            heightNavigationBarConstraint,
            ])
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            topNavigationBarConstraint,
            contentView.heightAnchor.constraint(equalToConstant: 44),
            ])
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            closeButton.centerYAnchor.constraint(equalTo: navigationBarView.safeAreaLayoutGuide.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30)
            ])
        NSLayoutConstraint.activate([
            navigationBarLabel.leadingAnchor.constraint(greaterThanOrEqualTo: closeButton.safeAreaLayoutGuide.trailingAnchor, constant: 8),
            navigationBarLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -46),
            navigationBarLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor, constant: 0),
            navigationBarLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: 0),

            ])
    }
    
    private func setupAdditionalConfiguration() {
        let closeTitle = NSAttributedString.init(string: "X", attributes: [NSAttributedString.Key.font : UIFont.INVSFontDefault(),NSAttributedString.Key.foregroundColor:UIColor.black])
        closeButton.setAttributedTitle(closeTitle, for: .normal)
        closeButton.addTarget(self, action: #selector(INVSSimulatedViewController.dismissViewController), for: .touchUpInside)
        navigationBarLabel.text = navigationBarTitle
        view.backgroundColor = .INVSGray()
        navigationBarView.backgroundColor = .INVSLightGray()
    }
    
    private func setupView() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
    
}

