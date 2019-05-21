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
        
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        monthLabel.text = ""
        profitabilityLabel.text = ""
        rescueLabel.text = ""
        totalLabel.text = ""
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutSubviews()
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer.addShadow(withRoundedCorner: 12, andColor: .white, inView: infoView)
        }
    }
    
    func setup(withSimulatedValue simulatedValue:INVSSimulatedValueModel) {
        if let shadowLayer = self.shadowLayer {
            shadowLayer.removeFromSuperlayer()
        }
        self.shadowLayer = nil
        monthLabel.font = .INVSFontDefault()
        profitabilityLabel.font = .INVSFontDefault()
        rescueLabel.font = .INVSFontDefault()
        totalLabel.font = .INVSFontDefault()
        if let month = simulatedValue.month {
            monthLabel.text = "Mês: \(month)"
        } else {
            monthLabel.text = "Aplicação Inicial"
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
    
    
}
