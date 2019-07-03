//
//  INVSSimulatorCell.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 15/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit


enum CellState {
    case `static`
    case collapsed
    case expanded
}


class INVSSimulationCell: UITableViewCell {
    @IBOutlet weak var initialValueLabel: UILabel!
    @IBOutlet weak var interestRateLabel: UILabel!
    @IBOutlet weak var totalMonthsLabel: UILabel!
    @IBOutlet weak var monthValueLabel: UILabel!
    @IBOutlet weak var initialRescueValueLabel: UILabel!
    @IBOutlet weak var increaseRescueValueLabel: UILabel!
    @IBOutlet weak var increaseGoalRescueValueLabel: UILabel!
    @IBOutlet var separatorsView: [UIView]!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var completeInfoStackView: UIStackView!
    @IBOutlet weak var simulationButton: INVSLoadingButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var arrowHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightInfoViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightStackViewConstraint: NSLayoutConstraint!
    private var shadowLayer: CAShapeLayer!
    var state: CellState = .static
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSkeletonView()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initialValueLabel.text = ""
        interestRateLabel.text = ""
        totalMonthsLabel.text = ""
        monthValueLabel.text = ""
        initialRescueValueLabel.text = ""
        increaseRescueValueLabel.text = ""
        increaseGoalRescueValueLabel.text = ""
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.infoView.layoutIfNeeded()
        self.completeInfoStackView.layoutIfNeeded()
        self.shadowLayer = CAShapeLayer.addCorner(withShapeLayer: self.shadowLayer, withCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], withRoundedCorner: 12, andColor: .white, inView: infoView)
        
        
    }
    
    func setup(withSimulation simulation:INVSSimulatorModel) {
        hideSkeletonView()
        simulationButton.hideSkeleton()
        initialValueLabel.font = .INVSFontDefault()
        interestRateLabel.font = .INVSFontDefault()
        totalMonthsLabel.font = .INVSFontDefault()
        monthValueLabel.font = .INVSFontDefault()
        initialRescueValueLabel.font = .INVSFontDefault()
        increaseRescueValueLabel.font = .INVSFontDefault()
        increaseGoalRescueValueLabel.font = .INVSFontDefault()
        initialValueLabel.text = "Valor Inicial:\(simulation.initialValue.currencyFormat())"
        interestRateLabel.text = "Taxa de Juros:\n\(simulation.interestRate.currencyFormat().percentFormat())"
        totalMonthsLabel.text = "Total de Meses:\n\(simulation.totalMonths)"
        monthValueLabel.text = "Valor Mensal:\n\(simulation.monthValue.currencyFormat())"
        initialRescueValueLabel.text = "Valor Inicial para Resgatar do seu rendimento:\n\(simulation.initialMonthlyRescue.currencyFormat())"
        increaseRescueValueLabel.text = "Acréscimo no resgate:\n\(simulation.increaseRescue.currencyFormat())"
        increaseGoalRescueValueLabel.text = "Objetivo de rendimento para aumento de resgate:\n\(simulation.goalIncreaseRescue.currencyFormat())"
        arrowHeightConstraint.constant = 0
        arrowImageView.isHidden = true
        if let isSimply = simulation.isSimply {
            if isSimply == false {
                arrowHeightConstraint.constant = 25
                arrowImageView.isHidden = false
                let image = UIImage(named:"arrow")?.withRenderingMode(.alwaysTemplate)
                arrowImageView.tintColor = UIColor.darkGray
                arrowImageView.image = image
            }
        }
    }
    
    func hideSkeletonView() {
        separatorsView.forEach({$0.isHidden = false})
        let skeletonViews = [initialValueLabel,interestRateLabel,totalMonthsLabel, monthValueLabel, initialRescueValueLabel, increaseRescueValueLabel, increaseGoalRescueValueLabel, simulationButton]
        skeletonViews.forEach({ $0?.hideSkeleton()})
    }
    
    func setupSkeletonView() {
        separatorsView.forEach({$0.isHidden = true})
        let skeletonViews = [initialValueLabel,interestRateLabel,totalMonthsLabel, monthValueLabel, initialRescueValueLabel, increaseRescueValueLabel, increaseGoalRescueValueLabel]
        skeletonViews.forEach({$0?.layer.masksToBounds = true
                                $0?.isSkeletonable = true
                                $0?.linesCornerRadius = 5
                                $0?.lastLineFillPercent = 100
                                $0?.showAnimatedGradientSkeleton()
        })
        self.layoutSkeletonIfNeeded()
        
    }
    
    func toggle(withNeedsLayout needsLayout:Bool = true) {
        completeInfoStackView.arrangedSubviews.forEach({ (view) in
            view.isHidden = stateIsCollapsed()
        })
        if stateIsStatic() {
            heightStackViewConstraint.constant = 0
            heightInfoViewConstraint.constant = 185
        } else {
            if stateIsCollapsed() {
                heightStackViewConstraint.constant = 0
                heightInfoViewConstraint.constant = 185
                downArrow()
                
            } else {
                heightStackViewConstraint.constant = 157
                heightInfoViewConstraint.constant = 340
                upArrow()
            }
        }
        if needsLayout {
            self.setNeedsLayout()
            return
        }
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion:nil)
        
    }
    
    private func stateIsCollapsed() -> Bool {
        return state == .collapsed || state == .static
    }
    
    private func stateIsStatic() -> Bool {
        return state == .static
    }
    
    private func upArrow() {
        UIView.animate(withDuration: 0.4) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }
    
    private func downArrow() {
        UIView.animate(withDuration: 0.4) {
            self.arrowImageView.transform = CGAffineTransform.identity
        }
    }
    
}
