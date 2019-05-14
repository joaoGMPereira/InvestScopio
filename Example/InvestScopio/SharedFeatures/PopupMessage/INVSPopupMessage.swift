//
//  INVSPopupMessage.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation
import UIKit

class INVSPopupMessage: UIView {
    
    private var size = CGSize()
    private var hasAddedSubview = false
    private var topBarHeight = CGFloat(0.0)
    private var topConstraint = NSLayoutConstraint()
    private var popupHeight = CGFloat(60.0)
    private var shadowLayer: CAShapeLayer!
    private var timerToHide = Timer()
    private var parentViewController = UIViewController()
    var textMessageLabel = UILabel()
    var closeButton = UIButton()
    
    
    init(parentViewController:UIViewController) {
        self.parentViewController = parentViewController
        let topPadding = CGFloat(10)
        topBarHeight = UIApplication.shared.statusBarFrame.size.height + topPadding
        super.init(frame: CGRect.init(x: (parentViewController.view.frame.width - (parentViewController.view.frame.width * 0.9))/2, y: -(topBarHeight+popupHeight), width: (parentViewController.view.frame.width * 0.9), height: popupHeight))
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(withTextMessage message:String) {
        textMessageLabel.text = message
        if hasAddedSubview == false {
            UIApplication.shared.keyWindow?.addSubview(self)
            hasAddedSubview = true
            setupView()
        }
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseOut, animations: {
            self.frame.origin.y = self.topBarHeight
            self.layoutIfNeeded()
        }) { (finished) in
            self.timerToHide = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(INVSPopupMessage.hide), userInfo: nil, repeats: false)
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
            textMessageLabel.heightAnchor.constraint(equalToConstant: 50),
            textMessageLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 0)
            ])
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: textMessageLabel.trailingAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            closeButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 0),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    
    func setupAdditionalConfiguration() {
        let closeTitle = NSAttributedString.init(string: "X", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.init(rawValue: 30))])
        closeButton.setAttributedTitle(closeTitle, for: .normal)
        closeButton.addTarget(self, action: #selector(INVSPopupMessage.closeAction), for: .touchUpInside)
    }
    
    @objc func closeAction() {
        hide()
    }
    
}
