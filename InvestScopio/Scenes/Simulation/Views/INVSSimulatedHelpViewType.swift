//
//  INVSSimulatedHelpViewType.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 02/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import ZCAnimatedLabel

enum INVSSimulatedHelpViewType: Int {
    case initialStep = 0
    case firstStep
    case secondStep
    case thirdStep
    case fourthStep
    case fifthStep
    case sixthStep
    case seventhStep
    case lastStep
    
    
    func setNextStep(helpView: INVSSimulatorHelpView) {
        switch self {
        case .initialStep:
            setInitialStep(withHelpView: helpView)
            break
        case .firstStep:
            setFirstStep(withHelpView: helpView)
            break
        case .secondStep:
            setSecondStep(withHelpView: helpView)
            break
        case .thirdStep:
            setThirdStep(withHelpView: helpView)
            break
        case .fourthStep:
            setFourthStep(withHelpView: helpView)
            break
        case .fifthStep:
            setFifthStep(withHelpView: helpView)
            break
        case .sixthStep:
            setSixthStep(withHelpView: helpView)
            break
        case .seventhStep:
            setSeventhStep(withHelpView: helpView)
            break
        case .lastStep:
            setLastStep(withHelpView: helpView)
            break
        }
    }
    
    //MARK: Initial Step
    private func setInitialStep(withHelpView helpView: INVSSimulatorHelpView) {
        setInitialStepMessage(withHelpView: helpView)
        setInitialStepBottomView(withHelpView: helpView)
        
    }
    
    private func setInitialStepMessage(withHelpView helpView: INVSSimulatorHelpView) {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "Olá futuro investidor!\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitle(withText: "Você deseja fazer uma simulação"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "\nSimplificada "))
        messageMutableAttributedString.append(NSAttributedString.subtitle(withText: "ou "))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Completa?"))
        setNewAttributedText(withHelpView: helpView, messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setInitialStepBottomView(withHelpView helpView: INVSSimulatorHelpView) {
        helpView.bottomView.subviews.forEach({$0.removeFromSuperview()})
        helpView.bottomViewHeightConstraint.constant = 50
        helpView.layoutIfNeeded()
        let simplyButton = UIButton()
        simplyButton.setTitle("Simplificada", for: .normal)
        simplyButton.addTarget(helpView, action: #selector(INVSSimulatorHelpView.simplyButtonAction(withButton:)), for: .touchUpInside)
        let completeButton = UIButton()
        completeButton.setTitle("Completa", for: .normal)
        completeButton.addTarget(helpView, action: #selector(INVSSimulatorHelpView.completeButtonAction(withButton:)), for: .touchUpInside)
        addButtonsInStackView(firstButton: simplyButton, secondButton: completeButton, andHelpView: helpView)
    }
    
    //MARK: TextFields Steps
    private func setFirstStep(withHelpView helpView: INVSSimulatorHelpView) {
        setFirstStepMessage(withHelpView: helpView)
        setTextFieldBottomView(withHelpView: helpView, textFieldType: INVSFloatingTextFieldType.initialValue,andValueType: .currency, isRequired: true)
    }
    
    private func setFirstStepMessage(withHelpView helpView: INVSSimulatorHelpView) {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Quanto você teria para seu\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Primeiro Investimento?"))
        setNewAttributedText(withHelpView: helpView, messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setSecondStep(withHelpView helpView: INVSSimulatorHelpView) {
        setSecondStepMessage(withHelpView: helpView)
        setTextFieldBottomView(withHelpView: helpView, textFieldType: INVSFloatingTextFieldType.monthValue,andValueType: .currency)
    }
    
    private func setSecondStepMessage(withHelpView helpView: INVSSimulatorHelpView) {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Quanto você teria para colocar\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Todo Mês?"))
        setNewAttributedText(withHelpView: helpView, messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setThirdStep(withHelpView helpView: INVSSimulatorHelpView) {
        setThirdStepMessage(withHelpView: helpView)
        setTextFieldBottomView(withHelpView: helpView, textFieldType: INVSFloatingTextFieldType.interestRate, andValueType: .percent, isRequired: true)
    }
    
    private func setThirdStepMessage(withHelpView helpView: INVSSimulatorHelpView) {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Qual a taxa de rendimento\ndo seu investimento?"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Qual a taxa de rendimento\ndo seu investimento?"))
        setNewAttributedText(withHelpView: helpView, messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setFourthStep(withHelpView helpView: INVSSimulatorHelpView) {
        setFourthStepMessage(withHelpView: helpView)
        setTextFieldBottomView(withHelpView: helpView, textFieldType: INVSFloatingTextFieldType.totalMonths, andValueType: .months, isRequired: true)
    }
    
    private func setFourthStepMessage(withHelpView helpView: INVSSimulatorHelpView) {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Por quanto "))
        messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "cempo "))
        messageMutableAttributedString.append(NSAttributedString.title(withText: "cocê quer \nFicar com esse investimento?"))
        setNewAttributedText(withHelpView: helpView, messageMutableAttributedString: messageMutableAttributedString)
    }

    private func setFifthStep(withHelpView helpView: INVSSimulatorHelpView) {
        setFifthStepMessage(withHelpView: helpView)
        setTextFieldBottomView(withHelpView: helpView, textFieldType: INVSFloatingTextFieldType.initialMonthlyRescue,andValueType: .currency, hasInfoButton: true)
    }
    
    private func setFifthStepMessage(withHelpView helpView: INVSSimulatorHelpView) {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Quanto você gostaria de\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Retirar do seu primeiro rendimento?"))
        setNewAttributedText(withHelpView: helpView, messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setSixthStep(withHelpView helpView: INVSSimulatorHelpView) {
        setSixthStepMessage(withHelpView: helpView)
        setTextFieldBottomView(withHelpView: helpView, textFieldType: INVSFloatingTextFieldType.increaseRescue,andValueType: .currency, hasInfoButton: true)
    }
    
    private func setSixthStepMessage(withHelpView helpView: INVSSimulatorHelpView) {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Quanto você gostaria de\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Aumentar da sua retirada\ndo seu rendimento?"))
        setNewAttributedText(withHelpView: helpView, messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setSeventhStep(withHelpView helpView: INVSSimulatorHelpView) {
        setSeventhStepMessage(withHelpView: helpView)
        setTextFieldBottomView(withHelpView: helpView, textFieldType: INVSFloatingTextFieldType.goalIncreaseRescue, andValueType: .currency, hasInfoButton: true)
    }
    
    private func setSeventhStepMessage(withHelpView helpView: INVSSimulatorHelpView) {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Qual seria seu objetivo para\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Aumentar a retirada do seu rendimento?"))
        setNewAttributedText(withHelpView: helpView, messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setTextFieldBottomView(withHelpView helpView: INVSSimulatorHelpView, textFieldType: INVSFloatingTextFieldType, andValueType valueType:INVSFloatingTextFieldValueType, isRequired: Bool = false, hasInfoButton: Bool = false) {
        helpView.bottomView.subviews.forEach({$0.removeFromSuperview()})
        helpView.bottomViewHeightConstraint.constant = 50
        helpView.layoutIfNeeded()
        let textField = INVSFloatingTextField(frame: .zero)
        helpView.bottomView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: helpView.bottomView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: helpView.bottomView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: helpView.bottomView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: helpView.bottomView.bottomAnchor)
            ])
        helpView.layoutIfNeeded()
        textFieldType.setupTextField(withTextField: textField, andDelegate: helpView, valueTypeTextField: valueType, isRequired: isRequired, hasInfoButton: hasInfoButton, leftButtons: [.cancel,.back])
        textField.floatingTextField.becomeFirstResponder()
    }
    
    private func setLastStep(withHelpView helpView: INVSSimulatorHelpView) {
        setLastStepMessage(withHelpView: helpView)
        setLastStepBottomView(withHelpView: helpView)
        
    }
    
    private func setLastStepMessage(withHelpView helpView: INVSSimulatorHelpView) {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "Dados coletados!\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: " você deseja simular "))
        messageMutableAttributedString.append(NSAttributedString.subtitle(withText: "ou "))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "deseja conferir seus dados?"))
        setNewAttributedText(withHelpView: helpView, messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setLastStepBottomView(withHelpView helpView: INVSSimulatorHelpView) {
        helpView.bottomView.subviews.forEach({$0.removeFromSuperview()})
        helpView.bottomViewHeightConstraint.constant = 50
        helpView.layoutIfNeeded()
        let simulateButton = UIButton()
        simulateButton.setTitle("Simular", for: .normal)
        simulateButton.addTarget(helpView, action: #selector(INVSSimulatorHelpView.simulateButtonAction(withButton:)), for: .touchUpInside)
        let reviewButton = UIButton()
        reviewButton.setTitle("Conferir", for: .normal)
        reviewButton.addTarget(helpView, action: #selector(INVSSimulatorHelpView.reviewButtonAction(withButton:)), for: .touchUpInside)
        addButtonsInStackView(firstButton: simulateButton, secondButton: reviewButton, andHelpView: helpView)
    }

    
    
    //MARK: Common methods
    private func resetConstraints(withHelpView helpView: INVSSimulatorHelpView) {
        helpView.messageLabelWidthConstraint.constant = 0
        helpView.messageLabelHeightConstraint.constant = 0
        helpView.layoutIfNeeded()
    }
    
    private func addButtonsInStackView(firstButton: UIButton, secondButton: UIButton, andHelpView helpView: INVSSimulatorHelpView) {
        let stackview = UIStackView(arrangedSubviews: [firstButton, secondButton])
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .fillEqually
        stackview.spacing = 2
        helpView.bottomView.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackview.topAnchor.constraint(equalTo: helpView.bottomView.topAnchor),
            stackview.leadingAnchor.constraint(equalTo: helpView.bottomView.leadingAnchor),
            stackview.trailingAnchor.constraint(equalTo: helpView.bottomView.trailingAnchor),
            stackview.bottomAnchor.constraint(equalTo: helpView.bottomView.bottomAnchor)
            ])
        helpView.layoutIfNeeded()
        var simplyButtonLayer: CAGradientLayer!
        var completeButtonLayer: CAGradientLayer!
        simplyButtonLayer = CAShapeLayer.addGradientLayer(withGradientLayer: simplyButtonLayer, inView: firstButton, withColorsArr: UIColor.INVSGradientColors(), withRoundedCorner: 25)
        completeButtonLayer = CAShapeLayer.addGradientLayer(withGradientLayer: completeButtonLayer, inView: secondButton, withColorsArr: UIColor.INVSGradientColors(), withRoundedCorner: 25)
        
        var simplyShapeButtonLayer: CAShapeLayer!
        var completeShapeButtonLayer: CAShapeLayer!
        simplyShapeButtonLayer = CAShapeLayer.addCornerAndShadow(withShapeLayer: simplyShapeButtonLayer, withCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], withRoundedCorner: 25, andColor: .clear, inView: firstButton)
        completeShapeButtonLayer = CAShapeLayer.addCornerAndShadow(withShapeLayer: completeShapeButtonLayer, withCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], withRoundedCorner: 25, andColor: .clear, inView: secondButton)
        
    }
    
    private func setNewAttributedText(withHelpView helpView: INVSSimulatorHelpView, messageMutableAttributedString: NSMutableAttributedString) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        style.alignment = .center
        style.lineBreakMode = .byWordWrapping
        let range: NSRange = messageMutableAttributedString.mutableString.range(of: messageMutableAttributedString.string)
        messageMutableAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
        resetConstraints(withHelpView: helpView)
        helpView.messageLabel.attributedString = messageMutableAttributedString
        helpView.messageLabel.animationDuration = 0.3
        helpView.messageLabel.animationDelay = 0.02
        helpView.messageLabel.layoutTool.groupType = .char
        if let superWidth = helpView.messageLabel.superview?.frame.width {
            let messageLabelWidth = helpView.messageLabel.attributedString.width(withConstrainedHeight: helpView.messageLabel.intrinsicContentSize.height)
            helpView.messageLabelWidthConstraint.constant = messageLabelWidth > superWidth ? superWidth : messageLabelWidth
            helpView.messageLabelHeightConstraint.constant = helpView.messageLabel.attributedString.height(withConstrainedWidth: helpView.messageLabelWidthConstraint.constant)
                    helpView.layoutIfNeeded()
        }
        helpView.messageLabel.attributedString.newLabelWith(with: helpView.messageLabelWidthConstraint)
        helpView.layoutIfNeeded()
        helpView.messageLabel.startAppearAnimation()
    }
}


extension NSAttributedString {
    
    func newLabelWith(with widthConstraint: NSLayoutConstraint)  {
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: widthConstraint.constant, height: CGFloat(MAXFLOAT)))
        let frameSetterRef : CTFramesetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
        let frameRef: CTFrame = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path.cgPath, nil)
        
        let linesNS: NSArray  = CTFrameGetLines(frameRef)
        
        guard let lines = linesNS as? [CTLine] else {return }
        var width = 0.0
        lines.forEach({
            let nextWidth = Double(CTLineGetBoundsWithOptions($0, CTLineBoundsOptions.useGlyphPathBounds).width)
            if nextWidth > width {
                width = nextWidth
            }
        })
        
        widthConstraint.constant = CGFloat(width + 30)
        
    }
}
