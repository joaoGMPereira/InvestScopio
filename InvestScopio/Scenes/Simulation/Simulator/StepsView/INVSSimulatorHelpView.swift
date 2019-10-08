//
//  INVSSimulatorHelpView.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 01/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit
import StepView
import BetterSegmentedControl
import ZCAnimatedLabel

class INVSSimulatorHelpView: UIView {
    
    private var shadowLayer: CAShapeLayer!
    private var segmentedControlHeightConstraint = NSLayoutConstraint()
    private var stepViewHeightConstraint = NSLayoutConstraint()
    
    var investorTypeSegmentedControl = BetterSegmentedControl.init(
        frame: .zero,
        segments: LabelSegment.segments(withTitles: ["Simplicada", "Completa"],
                                        normalFont: UIFont(name: "Avenir", size: 13.0)!,
                                        normalTextColor: .white,
                                        selectedFont: UIFont(name: "Avenir", size: 13.0)!,
                                        selectedTextColor: .INVSDefault()),
        options:[.backgroundColor(.INVSDefault()),
                 .indicatorViewBackgroundColor(.white),
                 .cornerRadius(15.0),
                 .bouncesOnChange(true)
        ])
    var stepView = StepView.init(frame: .zero, numberOfSteps: 2, circleBorderColor: .INVSDefault())
    var messageLabel = ZCAnimatedLabel()
    var messageLabelType = INVSSimulatedHelpViewType.initialStep
    var messageLabelWidthConstraint = NSLayoutConstraint()
    var messageLabelHeightConstraint = NSLayoutConstraint()
    var bottomView = UIView(frame: .zero)
    var bottomViewHeightConstraint = NSLayoutConstraint()
    var allTextfields = [INVSFloatingTextField]()
    var interactor: INVSSimulatorInteractorProtocol?
    var isOpened = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    func setInitialStep() {
        messageLabelType = .initialStep
        messageLabelType.setNextStep(helpView: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer = CAShapeLayer.addCorner(withShapeLayer: self.shadowLayer, withCorners: [.bottomLeft, .bottomRight], withRoundedCorner: 12, andColor: .white, inView: self)
    }
}

extension INVSSimulatorHelpView: INVSCodeView {
    func buildViewHierarchy() {
        addSubview(investorTypeSegmentedControl)
        addSubview(stepView)
        addSubview(messageLabel)
        addSubview(bottomView)
        investorTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        stepView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        segmentedControlHeightConstraint = investorTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 0)
        stepViewHeightConstraint = stepView.heightAnchor.constraint(equalToConstant: 0)
        messageLabelWidthConstraint = messageLabel.widthAnchor.constraint(equalToConstant: 0)
        messageLabelHeightConstraint = messageLabel.heightAnchor.constraint(equalToConstant: 0)
        bottomViewHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            investorTypeSegmentedControl.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            investorTypeSegmentedControl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            investorTypeSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: safeAreaInsets.top + 8),
            segmentedControlHeightConstraint
            ])
        
        NSLayoutConstraint.activate([
            stepView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            stepView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            stepView.topAnchor.constraint(equalTo: investorTypeSegmentedControl.bottomAnchor, constant: 8),
            stepViewHeightConstraint
            ])
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 0),
            messageLabelWidthConstraint,
            messageLabelHeightConstraint,
            messageLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -100),
            ])
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bottomView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            bottomView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            bottomViewHeightConstraint
            
            ])
    }
    
    func setupAdditionalConfiguration() {
        
        stepView.circleRadius = 10
        stepView.selectedCircleRadius = 15
        stepView.textColor = .INVSDefault()
        stepView.selectedCircleBorderColor = .INVSDefault()
        stepView.circleFilledColor = .INVSDefault()
        investorTypeSegmentedControl.addTarget(self, action: #selector(INVSSimulatorHelpView.segmentedControlInvestorTypeChanged(_:)), for: .valueChanged)
    }

}

extension INVSSimulatorHelpView: INVSFloatingTextFieldDelegate {
    func infoButtonAction(_ textField: INVSFloatingTextField) {
        endEditing(true)
        interactor?.showInfo(withSender: textField)
    }
    
    func toolbarAction(_ textField: INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton) {
        switch type {
        case .cancel:
            endEditing(true)
            break
        case .back:
            backStep()
        case .ok:
            var textFieldsFilled = allTextfields
            textFieldsFilled.append(textField)
            interactor?.check(withTextFields: textFieldsFilled)
        }
    }
    
    func backStep() {
        if stepView.selectedStep > 1 {
            stepView.showPreviousStep()
            allTextfields.removeLast()
        } else {
            investorTypeSegmentedControl.isHidden = true
            stepView.isHidden = true
        }
        messageLabelType = INVSSimulatedHelpViewType(rawValue: messageLabelType.rawValue - 1) ?? .initialStep
        messageLabelType.setNextStep(helpView: self)
    }
    
    func showNextStep(withLastTextField textField: INVSFloatingTextField) {
        allTextfields.append(textField)
        if stepView.selectedStep == stepView.numberOfSteps {
            messageLabelType = .lastStep
            messageLabelType.setNextStep(helpView: self)
            return
        }
        stepView.showNextStep()
        if let nextTextFieldType = textField.typeTextField?.next() {
            messageLabelType = INVSSimulatedHelpViewType(rawValue: nextTextFieldType.rawValue + 1) ?? .firstStep
        }
        messageLabelType.setNextStep(helpView: self)
    }
    
    func textFieldDidBeginEditing(_ textField: INVSFloatingTextField) {
        
    }
    
    
}

extension INVSSimulatorHelpView {
    
    @IBAction func segmentedControlInvestorTypeChanged(_ sender: BetterSegmentedControl) {
        allTextfields = [INVSFloatingTextField]()
        messageLabelType = .firstStep
        messageLabelType.setNextStep(helpView: self)
        stepView.moveTo(step: 1)
        stepView.numberOfSteps = 4
        if sender.index == 1 {
            stepView.numberOfSteps = 7
        }
        stepView.setNeedsDisplay()
    }
    
    @objc func simplyButtonAction(withButton button:UIButton) {
        bottomViewHeightConstraint.constant = 0
        stepViewHeightConstraint.constant = 30
        segmentedControlHeightConstraint.constant = 40
        investorTypeSegmentedControl.setIndex(0, animated: true)
        updateSteps(withNumberOfSteps: 4)
        
    }
    
    @objc func completeButtonAction(withButton button:UIButton) {
        bottomViewHeightConstraint.constant = 0
        stepViewHeightConstraint.constant = 30
        segmentedControlHeightConstraint.constant = 40
        investorTypeSegmentedControl.setIndex(1, animated: true)
        updateSteps(withNumberOfSteps: 7)
    }
    
    @objc func simulateButtonAction(withButton button:UIButton) {
        interactor?.simulateSteps(withTextFields: allTextfields)
    }
    
    @objc func reviewButtonAction(withButton button:UIButton) {
        interactor?.review(withTextFields: allTextfields)
    }
    
    private func updateSteps(withNumberOfSteps steps: Int) {
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
            self.stepView.numberOfSteps = steps
            self.stepView.setNeedsDisplay()
            self.bottomView.subviews.forEach({$0.removeFromSuperview()})
            self.messageLabelType = .firstStep
            self.messageLabelType.setNextStep(helpView: self)
            self.investorTypeSegmentedControl.isHidden = false
            self.stepView.isHidden = false
        }
    }
}

