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
        //monthValueLabel.text = ""
        profitabilityLabel.text = ""
        rescueLabel.text = ""
        totalLabel.text = ""
        
        monthLabel.font = .INVSFontDefault()
        profitabilityLabel.font = .INVSFontDefault()
        rescueLabel.font = .INVSFontDefault()
        totalLabel.font = .INVSFontDefault()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutSubviews()
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer.addShadow(withRoundedCorner: 12, andColor: .white, inView: infoView)
        }
    }
    
    func setup(withSimulatedValue simulatedValue:INVSSimulatedValueModel) {
        if let month = simulatedValue.month, month != 0  {
            monthLabel.text = "Mês: \(month)"
        } else {
            monthLabel.text = "Aplicação Inicial"
        }
//        if let monthValue = simulatedValue.monthValue, monthValue != 0 {
//            monthValueLabel.text =  "Aporte:\n\(monthValue.currencyFormat())"
//        }
        if let profitability = simulatedValue.profitability, profitability != 0 {
            profitabilityLabel.text = "Rentabilidade:\n \(profitability.currencyFormat())"
        }
        if let rescue = simulatedValue.rescue, rescue != 0 {
            rescueLabel.text = "Resgate:\n\(rescue.currencyFormat())"
        }
        if let total = simulatedValue.total, total != 0 {
            totalLabel.text = "Total:\n\(total.currencyFormat())"
        }
    }
    
    
}
