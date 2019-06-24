//
//  INVSSwitchView.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 23/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit


protocol INVSSwitchViewDelegate {
    func didSelectButton(_ sender: UIButton)
}

class INVSSwitchView: UIView {
    var stackView = UIStackView()
    var switchButtons = [UIButton]()
    var selectedView = UIView()
    var selectedViewWidth = NSLayoutConstraint()
    var selectedViewLeading = NSLayoutConstraint()
    var selectedButton = 0
    var delegate: INVSSwitchViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setup(withSwitchButtons buttons:[UIButton], selectedButton: Int = 0) {
        switchButtons = buttons
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        for (index, button) in switchButtons.enumerated() {
            button.tag = index
            stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(didSelectButton(_:)), for: .touchUpInside)
        }
        updateUI(selectedButtonIndex: selectedButton)
        
    }
    
    private func updateUI(selectedButtonIndex: Int) {
        selectedButton = selectedButtonIndex
        selectedViewWidth.constant = stackView.frame.width/CGFloat(switchButtons.count)
        UIView.animate(withDuration: 0.6) {
            self.layoutIfNeeded()
        }
    }
    
    @objc func didSelectButton(_ sender: UIButton) {
        selectedButton = sender.tag
        stackView.arrangedSubviews.forEach({$0.isUserInteractionEnabled = true})
        sender.isUserInteractionEnabled = false
        selectedViewLeading.constant = sender.frame.minX
        UIView.animate(withDuration: 0.6) {
            self.layoutIfNeeded()
        }
        delegate?.didSelectButton(sender)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if stackView.arrangedSubviews.count > 0 {
            if let selectedButton = stackView.arrangedSubviews[selectedButton] as? UIButton {
                selectedViewLeading.constant = selectedButton.frame.minX
            }
        }
    }
}

extension INVSSwitchView: INVSCodeView {
    func buildViewHierarchy() {
        addSubview(stackView)
        addSubview(selectedView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        selectedViewWidth = selectedView.widthAnchor.constraint(equalToConstant: 0)
        selectedViewLeading = selectedView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2)
            ])
        NSLayoutConstraint.activate([
            selectedViewLeading,
            selectedViewWidth,
            selectedView.heightAnchor.constraint(equalToConstant: 2),
            selectedView.topAnchor.constraint(equalTo: stackView.bottomAnchor)
            ])
        
    }
    
    func setupAdditionalConfiguration() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addBackground(color: .INVSLightGray())
        stackView.spacing = 1
        selectedView.backgroundColor = .INVSDefault()
    }
    
    
}
