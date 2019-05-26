//
//  INVSSimulatorHeaderView.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 16/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SkeletonView

class INVSSimulatorHeaderView: UIView,INVSCodeView {
    private var initialAplicationLabel = UILabel()
    private var monthlyValueLabel = UILabel()
    
    private var shadowLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSkeletonView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer = CAShapeLayer.addCornerAndShadow(withShapeLayer: self.shadowLayer, withCorners: [.bottomLeft, .bottomRight], withRoundedCorner: 12, andColor: .white, inView: self)
    }
    
    func setup(withSimulatedValue simulatedValue: INVSSimulatedValueModel) {
        hideSkeletonView()
        initialAplicationLabel.text = "Aplicação Inicial: \(simulatedValue.total?.currencyFormat() ?? 0.0.currencyFormat())"
        monthlyValueLabel.text = "Aporte Mensal: \(simulatedValue.monthValue?.currencyFormat() ?? 0.0.currencyFormat())"
    }
    
    func buildViewHierarchy() {
        addSubview(initialAplicationLabel)
        addSubview(monthlyValueLabel)
        translatesAutoresizingMaskIntoConstraints = false
        initialAplicationLabel.translatesAutoresizingMaskIntoConstraints = false
        monthlyValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            initialAplicationLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            initialAplicationLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            initialAplicationLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            initialAplicationLabel.widthAnchor.constraint(equalToConstant: frame.width - 16),
            initialAplicationLabel.heightAnchor.constraint(equalToConstant: (frame.height - 20)/2)
            ])
        NSLayoutConstraint.activate([
            monthlyValueLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            monthlyValueLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            monthlyValueLabel.topAnchor.constraint(equalTo: initialAplicationLabel.bottomAnchor, constant: 4),
            monthlyValueLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            monthlyValueLabel.widthAnchor.constraint(equalToConstant: frame.width - 16),
            monthlyValueLabel.heightAnchor.constraint(equalTo: initialAplicationLabel.heightAnchor)
            ])
    }
    
    func setupAdditionalConfiguration() {
        initialAplicationLabel.font = .INVSFontDefault()
        monthlyValueLabel.font = .INVSFontDefault()
        
        initialAplicationLabel.numberOfLines = 0
        monthlyValueLabel.numberOfLines = 0
        
        initialAplicationLabel.text = "testando isso"
        monthlyValueLabel.text = "testando isso"
        
    }
    
    func setupSkeletonView() {
        let skeletonViews = [initialAplicationLabel,monthlyValueLabel]
        skeletonViews.forEach({
            $0.isSkeletonable = true
            $0.linesCornerRadius = 5
            $0.lastLineFillPercent = 50
            $0.showAnimatedGradientSkeleton()
        })
    }
    
    func hideSkeletonView() {
        let skeletonViews = [initialAplicationLabel,monthlyValueLabel]
        skeletonViews.forEach({
            $0.hideSkeleton()
        })
    }
}
