//
//  INVSSimulatorCell.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 15/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class INVSSimulatorCell: UITableViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthValueLabel: UILabel!
    @IBOutlet weak var profitabilityLabel: UILabel!
    @IBOutlet weak var rescueLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet var separatorsView: [UIView]!
    @IBOutlet weak var infoView: UIView!
    
    private var shadowLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSkeletonView()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        monthValueLabel.text = ""
        profitabilityLabel.text = ""
        rescueLabel.text = ""
        totalLabel.text = ""
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.shadowLayer = CAShapeLayer.addCorner(withShapeLayer: self.shadowLayer, withCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], withRoundedCorner: 12, andColor: .white, inView: infoView)
        
        
    }
    
    func setup(withSimulatedValue simulatedValue:INVSSimulatedValueModel) {
        hideSkeletonView()
        monthValueLabel.font = .INVSFontDefault()
        profitabilityLabel.font = .INVSFontDefault()
        rescueLabel.font = .INVSFontDefault()
        totalLabel.font = .INVSFontDefault()
        if let month = simulatedValue.month {
            monthValueLabel.text = "Mês: \(month)"
        } else {
            monthValueLabel.text = "Aplicação Inicial"
        }
        if let profitability = simulatedValue.profitability {
            profitabilityLabel.text = "Rentabilidade:\n \(profitability.currencyFormat())"
        }
        if let rescue = simulatedValue.rescue {
            rescueLabel.text = "Resgate:\n\(rescue.currencyFormat())"
        }
        if let total = simulatedValue.total {
            totalLabel.text = "Total:\n\(total.currencyFormat())"
        }
    }
    
    func hideSkeletonView() {
        separatorsView.forEach({$0.isHidden = false})
        let skeletonViews = [monthLabel,monthValueLabel,profitabilityLabel, rescueLabel, totalLabel]
        skeletonViews.forEach({ $0?.hideSkeleton()})
    }
    
    func setupSkeletonView() {
        separatorsView.forEach({$0.isHidden = true})
        let skeletonViews = [monthLabel,monthValueLabel,profitabilityLabel, rescueLabel, totalLabel]
        skeletonViews.forEach({$0?.layer.masksToBounds = true
                                $0?.isSkeletonable = true
                                $0?.linesCornerRadius = 5
                                $0?.lastLineFillPercent = 100
                                $0?.showAnimatedGradientSkeleton()
        })
    }
    
}
