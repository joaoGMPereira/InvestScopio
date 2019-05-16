//
//  INVSPopupMessage.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation
import UIKit

enum INVSPopupMessageType: Int {
    case error = 0
    case alert
    
    func messageColor() -> UIColor {
        switch self {
        case .error:
            return .white
        case .alert:
            return .INVSDefault()
        }
    }
    
    func backgroundColor() -> UIColor {
        switch self {
        case .error:
            return .INVSRed()
        case .alert:
            return .white
        }
    }
}

class INVSPopupMessage: UIView {
    
    private var size = CGSize()
    private var hasAddedSubview = false
    private var topBarHeight = CGFloat(0.0)
    private var topConstraint = NSLayoutConstraint()
    private var popupHeight = CGFloat(60.0)
    private var popupWidth = CGFloat(200)
    private var shadowLayer: CAShapeLayer!
    private var timerToHide = Timer()
    private var messageColor :UIColor = INVSPopupMessageType.error.messageColor()
    private var popupBackgroundColor :UIColor = INVSPopupMessageType.error.backgroundColor()
    
    private var parentViewController = UIViewController()
    private var shouldHideAutomatically = true
    var textMessageLabel = UILabel()
    var closeButton = UIButton()
    
    
    init(parentViewController:UIViewController) {
        self.parentViewController = parentViewController
        let topPadding = CGFloat(10)
        popupWidth = parentViewController.view.frame.width * 0.9
        topBarHeight = UIApplication.shared.statusBarFrame.size.height + topPadding
        super.init(frame: CGRect.init(x: (parentViewController.view.frame.width - (parentViewController.view.frame.width * 0.9))/2, y: -(topBarHeight+popupHeight), width: popupWidth, height: popupHeight))
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer.addShadow(withRoundedCorner: 12, andColor: popupBackgroundColor, inView: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(withTextMessage message:String, popupType: INVSPopupMessageType = .error, shouldHideAutomatically: Bool = true, sender: UIView? = nil) {
        self.shouldHideAutomatically = shouldHideAutomatically
        messageColor = popupType.messageColor()
        popupBackgroundColor = popupType.backgroundColor()
        setupUI(withMessage: message)
        calculateHeightOfPopup(with: message)
        if hasAddedSubview == false {
            UIApplication.shared.keyWindow?.addSubview(self)
            hasAddedSubview = true
            setupView()
        }
        showPopup(sender: sender)
    }
    
    private func setupUI(withMessage message:String) {
        textMessageLabel.text = message
        textMessageLabel.textColor = messageColor
        closeButton.setTitleColor(messageColor, for: .normal)
        let closeTitle = NSAttributedString.init(string: "X", attributes: [NSAttributedString.Key.font : UIFont.INVSFontDefault(),NSAttributedString.Key.foregroundColor:messageColor])
        closeButton.setAttributedTitle(closeTitle, for: .normal)
        if shadowLayer != nil {
            shadowLayer.fillColor = popupBackgroundColor.cgColor
        }
    }
    
    private func calculateHeightOfPopup(with message: String) {
        let paddings: CGFloat = 24
        let buttonWidth: CGFloat = 30
        let textMessageWidth = popupWidth - paddings - buttonWidth
        let estimatedPopupHeight = message.height(withConstrainedWidth: textMessageWidth, font: .INVSFontBig())
        if estimatedPopupHeight > 60 {
            popupHeight = estimatedPopupHeight
        }
    }
    
    private func showPopup(sender: UIView?) {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseOut, animations: {
            self.frame.size.height = self.popupHeight
            self.frame.origin.y = self.topBarHeight
            if let sender = sender {
                self.frame.origin.y = sender.frame.origin.y
            }
            self.layoutIfNeeded()
        }) { (finished) in
            if self.shouldHideAutomatically {
                self.timerToHide = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(INVSPopupMessage.hide), userInfo: nil, repeats: false)
            }
        }
    }
    
     @objc func hide() {
        self.timerToHide.invalidate()
        UIView.animate(withDuration: 0.4) {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
                (self.parentViewController.navigationController?.navigationBar.frame.height ?? 0.0)
            self.frame.origin.y = -(topBarHeight + self.popupHeight)
            self.layoutIfNeeded()
        }
    }
}

extension INVSPopupMessage: INVSCodeView {
    func buildViewHierarchy() {
        self.addSubview(textMessageLabel)
        self.addSubview(closeButton)
        textMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textMessageLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            textMessageLabel.heightAnchor.constraint(equalToConstant: popupHeight * 0.95),
            textMessageLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 0)
            ])
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: textMessageLabel.trailingAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            closeButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 0),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30)
            ])
    }
    
    func setupAdditionalConfiguration() {
        closeButton.addTarget(self, action: #selector(INVSPopupMessage.hide), for: .touchUpInside)
        textMessageLabel.textColor = messageColor
        textMessageLabel.font = .INVSFontDefault()
        textMessageLabel.numberOfLines = 0
        textMessageLabel.textAlignment = .center
    }
    
}
