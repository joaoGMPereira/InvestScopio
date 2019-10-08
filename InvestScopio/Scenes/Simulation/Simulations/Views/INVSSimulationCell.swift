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
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var completeInfoStackView: UIStackView!
    @IBOutlet weak var arrowButton: UIButton!
    
    @IBOutlet weak var arrowHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightInfoViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightStackViewConstraint: NSLayoutConstraint!
    private var shadowLayer: CAShapeLayer!
    
    var indexPath: IndexPath? = nil
    var state: CellState = .static
    var expandCellAction: ((_ button: UIButton, _ indexPath: IndexPath) -> ())?
    
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
    
    func setup(withSimulation simulation:INVSSimulatorModel, indexPath: IndexPath) {
        self.indexPath = indexPath
        setupUI()
        let initialValueAttributed = NSMutableAttributedString()
        initialValueAttributed.append(NSAttributedString.subtitleBold(withText: "Valor Inicial:\n", textColor: .lightGray))
        initialValueAttributed.append(NSAttributedString.title(withText: "\(simulation.initialValue.currencyFormat())"))
        initialValueLabel.attributedText = initialValueAttributed
        
        let interestRateAttributed = NSMutableAttributedString()
        interestRateAttributed.append(NSAttributedString.subtitleBold(withText: "Taxa de Juros:\n", textColor: .lightGray))
        interestRateAttributed.append(NSAttributedString.title(withText: "\(simulation.interestRate.currencyFormat().percentFormat())"))
        interestRateLabel.attributedText = interestRateAttributed
        
        let totalMonthsAttributed = NSMutableAttributedString()
        totalMonthsAttributed.append(NSAttributedString.subtitleBold(withText: "Meses:\n", textColor: .lightGray))
        totalMonthsAttributed.append(NSAttributedString.title(withText: "\(simulation.totalMonths)"))
        totalMonthsLabel.attributedText = totalMonthsAttributed
        
        let monthValueAttributed = NSMutableAttributedString()
        monthValueAttributed.append(NSAttributedString.subtitleBold(withText: "Valor Mensal:\n", textColor: .lightGray))
        monthValueAttributed.append(NSAttributedString.title(withText: "\(simulation.monthValue.currencyFormat())"))
        monthValueLabel.attributedText = monthValueAttributed
        
        let initialRescueValueAttributed = NSMutableAttributedString()
        initialRescueValueAttributed.append(NSAttributedString.subtitleBold(withText: "Valor Inicial Resgate Resgatar do seu rendimento:\n", textColor: .lightGray))
        initialRescueValueAttributed.append(NSAttributedString.title(withText: "\(simulation.initialMonthlyRescue.currencyFormat())"))
        initialRescueValueLabel.attributedText = initialRescueValueAttributed
        
        let increaseRescueValueAttributed = NSMutableAttributedString()
        increaseRescueValueAttributed.append(NSAttributedString.subtitleBold(withText: "Acréscimo no resgate:\n", textColor: .lightGray))
        increaseRescueValueAttributed.append(NSAttributedString.title(withText: "\(simulation.increaseRescue.currencyFormat())"))
        increaseRescueValueLabel.attributedText = increaseRescueValueAttributed
        
        let increaseGoalRescueValueAttributed = NSMutableAttributedString()
        increaseGoalRescueValueAttributed.append(NSAttributedString.subtitleBold(withText: "Objetivo de rendimento para aumento de resgate:\n", textColor: .lightGray))
        increaseGoalRescueValueAttributed.append(NSAttributedString.title(withText: "\(simulation.goalIncreaseRescue.currencyFormat())"))
        increaseGoalRescueValueLabel.attributedText = increaseGoalRescueValueAttributed
        arrowHeightConstraint.constant = 0
        arrowButton.isHidden = true
        checkIfIsSimply(isSimply: simulation.isSimply)
    }
        
        func setupUI() {
            hideSkeletonView()
            initialValueLabel.font = .INVSFontDefault()
            interestRateLabel.font = .INVSFontDefault()
            totalMonthsLabel.font = .INVSFontDefault()
            monthValueLabel.font = .INVSFontDefault()
            initialRescueValueLabel.font = .INVSFontDefault()
            increaseRescueValueLabel.font = .INVSFontDefault()
            increaseGoalRescueValueLabel.font = .INVSFontDefault()
        }
        
        func checkIfIsSimply(isSimply: Bool?) {
            if let isSimply = isSimply {
                if isSimply == false {
                    arrowHeightConstraint.constant = 48
                    arrowButton.isHidden = false
                    let image = UIImage(named:"arrow")?.withRenderingMode(.alwaysTemplate)
                    arrowButton.tintColor = UIColor.darkGray
                    arrowButton.setImage(image, for: .normal)
                }
            }
        }
  
    func hideSkeletonView() {
        let skeletonViews = [initialValueLabel,interestRateLabel,totalMonthsLabel, monthValueLabel, initialRescueValueLabel, increaseRescueValueLabel, increaseGoalRescueValueLabel]
        skeletonViews.forEach({ $0?.hideSkeleton()})
    }
    
    func setupSkeletonView() {
        let skeletonViews = [initialValueLabel,interestRateLabel,totalMonthsLabel, monthValueLabel, initialRescueValueLabel, increaseRescueValueLabel, increaseGoalRescueValueLabel]
        skeletonViews.forEach({$0?.layer.masksToBounds = true
                                $0?.isSkeletonable = true
                                $0?.linesCornerRadius = 5
                                $0?.lastLineFillPercent = 100
                                $0?.showAnimatedGradientSkeleton()
        })
        self.layoutSkeletonIfNeeded()
        
    }
    
    @IBAction func expandCell(_ sender: UIButton) {
        if let expandCellAction = self.expandCellAction, let indexPath = self.indexPath {
            expandCellAction(sender, indexPath)
        }
    }
    
    func toggle(withNeedsLayout needsLayout:Bool = true) {
        completeInfoStackView.arrangedSubviews.forEach({ (view) in
            view.isHidden = stateIsCollapsed()
        })
        if stateIsStatic() {
            heightStackViewConstraint.constant = 0
            heightInfoViewConstraint.constant = 130
        } else {
            if stateIsCollapsed() {
                heightStackViewConstraint.constant = 0
                heightInfoViewConstraint.constant = 130
                downArrow()
                
            } else {
                heightStackViewConstraint.constant = 200
                heightInfoViewConstraint.constant = 330
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
            self.arrowButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }
    
    private func downArrow() {
        UIView.animate(withDuration: 0.4) {
            self.arrowButton.transform = CGAffineTransform.identity
        }
    }
    
}
