//
//  INVSSimulatorHeaderView.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 16/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class INVSSimulatorHeaderView: UIView,INVSCodeView {
    private var stackView = UIStackView()
    private var initialAplicationLabel = UILabel()
    private var monthlyValueLabel = UILabel()
    
    private var shadowLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer.addCorner(inCorners: [.bottomLeft, .bottomRight], withRoundedCorner: 12, andColor: .white, inView: self)
        }
    }
    
    func setup(withSimulatedValue simulatedValue: INVSSimulatedValueModel) {
        initialAplicationLabel.text = "Aplicação Inicial: \(simulatedValue.total?.currencyFormat() ?? 0.0.currencyFormat())"
        monthlyValueLabel.text = "Aporte Mensal: \(simulatedValue.monthValue?.currencyFormat() ?? 0.0.currencyFormat())"
    }
    
    func buildViewHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(initialAplicationLabel)
        stackView.addArrangedSubview(monthlyValueLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    func setupAdditionalConfiguration() {
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        initialAplicationLabel.font = .INVSFontDefault()
        monthlyValueLabel.font = .INVSFontDefault()
        
        initialAplicationLabel.numberOfLines = 0
        monthlyValueLabel.numberOfLines = 0
        
        initialAplicationLabel.text = "Aplicação Inicial:"
        monthlyValueLabel.text = "Aporte Mensal:"

    }


}
