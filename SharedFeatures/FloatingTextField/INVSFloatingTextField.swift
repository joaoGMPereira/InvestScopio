//
//  FloatingTextField.swift
//  InvestEx_Example
//
//  Created by Joao Medeiros Pereira on 10/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class INVSFloatingTextField: UIView {
    let floatingTextField = UITextField(frame: .zero)
    let placeholderLabel = UILabel(frame: .zero)
    let bottomLineView = UIView(frame: .zero)
    
    private var typeTextField: INVSFloatingTextFieldType = .currency
    private var selectedColor = UIColor.lightGray
    private var smallFont = UIFont.systemFont(ofSize: 11)
    private var bigFont = UIFont.systemFont(ofSize: 16)
    private var heightLabelConstraint = NSLayoutConstraint()
    private var trailingLabelConstraint = NSLayoutConstraint()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setup(placeholder: String, typeTextField: INVSFloatingTextFieldType? = nil, color: UIColor, smallFont: UIFont = UIFont.systemFont(ofSize: 11), bigFont: UIFont = UIFont.systemFont(ofSize: 16)) {
        placeholderLabel.text = placeholder
        self.typeTextField = typeTextField ?? .none
        selectedColor = color
        self.smallFont = smallFont
        self.bigFont = bigFont
    }
    
}

extension INVSFloatingTextField: INVSCodeView {
    func buildViewHierarchy() {
        addSubview(floatingTextField)
        addSubview(placeholderLabel)
        addSubview(bottomLineView)
        floatingTextField.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.isUserInteractionEnabled = false
    }
    
    func setupConstraints() {
        
        heightLabelConstraint = placeholderLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor)
        trailingLabelConstraint = placeholderLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)

        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            trailingLabelConstraint,
            placeholderLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            heightLabelConstraint
            ])
        NSLayoutConstraint.activate([
            floatingTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            floatingTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            floatingTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            floatingTextField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            bottomLineView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1),
            bottomLineView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    func setupAdditionalConfiguration() {
        floatingTextField.delegate = self
        placeholderLabel.font = bigFont
        placeholderLabel.textColor = .lightGray
        bottomLineView.backgroundColor = .lightGray
        let toolbar = INVSKeyboardToolbar()
        toolbar.toolBarDelegate = self
        toolbar.setup(rightButtons: [INVSKeyboardToolbarButton.ok])
        floatingTextField.inputAccessoryView = toolbar
    }
}

extension INVSFloatingTextField: UITextFieldDelegate, INVSKeyboardToolbarDelegate {
    func keyboardToolbar(button: UIBarButtonItem, type: INVSKeyboardToolbarButton, tappedIn toolbar: INVSKeyboardToolbar) {
        closeKeyboard()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isBackSpace = string == ""
        let fullText = String.init(format: "%@%@", textField.text ?? "", string)
        textField.text = typeTextField.formatText(textFieldText: fullText, isBackSpace: isBackSpace)
        
        if isBackSpace {
            return true
        }
 
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        openKeyboard()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.text == "" || textField.text == nil {
            closeKeyboard()
        }
    }
    
    func openKeyboard() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.trailingLabelConstraint.constant = 30
            self?.heightLabelConstraint.constant = -30
            self?.placeholderLabel.font = self?.smallFont
            self?.placeholderLabel.textColor = self?.selectedColor
            self?.bottomLineView.backgroundColor = self?.selectedColor
            self?.layoutIfNeeded()
        }
    }
    
    func closeKeyboard() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            if self?.floatingTextField.text == "" || self?.floatingTextField.text == nil {
                self?.trailingLabelConstraint.constant = 0
                self?.heightLabelConstraint.constant = 0
                self?.placeholderLabel.font = UIFont.systemFont(ofSize: 16)
                self?.placeholderLabel.textColor = .lightGray
                self?.bottomLineView.backgroundColor = UIColor.lightGray
            }
            self?.endEditing(true)
            self?.layoutIfNeeded()
        }
    }
}


