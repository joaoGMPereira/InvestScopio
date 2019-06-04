//
//  FloatingTextField.swift
//  InvestEx_Example
//
//  Created by Joao Medeiros Pereira on 10/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

protocol INVSFloatingTextFieldDelegate: class {
    func infoButtonAction(_ textField: INVSFloatingTextField)
    func toolbarAction(_ textField: INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton)
    func textFieldDidBeginEditing(_ textField: INVSFloatingTextField)
}

class INVSFloatingTextField: UIView {
    let floatingTextField = UITextField(frame: .zero)
    let placeholderLabel = UILabel(frame: .zero)
    let bottomLineView = UIView(frame: .zero)
    let infoButton = UIButton.init(type: .infoLight)
    var delegate: INVSFloatingTextFieldDelegate?
    
    var typeTextField: INVSFloatingTextFieldType?
    var required: Bool = false
    var hasInfoButton: Bool = false {
        didSet {
            updateInfoButton()
        }
    }
    var hasError: Bool = false {
        didSet {
            updateTextFieldUI()
        }
    }
    
    private var valueTypeTextField: INVSFloatingTextFieldValueType = .currency
    private var selectedColor = UIColor.lightGray
    private var currentlySelectedColor = UIColor.lightGray
    private var smallFont = UIFont.systemFont(ofSize: 11)
    private var bigFont = UIFont.systemFont(ofSize: 16)
    private var heightLabelConstraint = NSLayoutConstraint()
    private var trailingLabelConstraint = NSLayoutConstraint()
    private var trailingTextFieldConstraint = NSLayoutConstraint()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setup(placeholder: String,typeTextField: INVSFloatingTextFieldType?, valueTypeTextField: INVSFloatingTextFieldValueType? = nil,keyboardType: UIKeyboardType = .numberPad , required: Bool = false, hasInfoButton: Bool = false, color: UIColor, smallFont: UIFont = UIFont.systemFont(ofSize: 11), bigFont: UIFont = UIFont.systemFont(ofSize: 16), leftButtons: [INVSKeyboardToolbarButton] = [INVSKeyboardToolbarButton.cancel], rightButtons: [INVSKeyboardToolbarButton] = [INVSKeyboardToolbarButton.ok]) {
        placeholderLabel.text = placeholder
        floatingTextField.keyboardType = keyboardType
        self.typeTextField = typeTextField
        self.valueTypeTextField = valueTypeTextField ?? .none
        self.required = required
        self.hasInfoButton = hasInfoButton
        if self.required {
            placeholderLabel.text = "\(placeholderLabel.text ?? "")*"
        }
        selectedColor = color
        currentlySelectedColor = selectedColor
        self.smallFont = smallFont
        self.bigFont = bigFont
        if floatingTextField.text != nil && floatingTextField.text != "" {
            openKeyboard()
        }
        setToolbar(leftButtons: leftButtons, rightButtons: rightButtons)
    }
    
    func setToolbar(leftButtons: [INVSKeyboardToolbarButton], rightButtons: [INVSKeyboardToolbarButton]) {
        let toolbar = INVSKeyboardToolbar()
        toolbar.toolBarDelegate = self
        toolbar.setup(leftButtons: leftButtons, rightButtons: rightButtons)
        floatingTextField.inputAccessoryView = toolbar
    }
    
    func updateTextFieldUI() {
        currentlySelectedColor = selectedColor
        placeholderLabel.text = placeholderLabel.text?.replacingOccurrences(of: "*", with: "")
        if hasError {
            currentlySelectedColor = .INVSRed()
            placeholderLabel.text = "\(placeholderLabel.text ?? "")*"
        }
        placeholderLabel.textColor = currentlySelectedColor
        bottomLineView.backgroundColor = currentlySelectedColor
        
    }
    
    func updateInfoButton() {
        if hasInfoButton {
            addSubview(infoButton)
            infoButton.translatesAutoresizingMaskIntoConstraints = false
            infoButton.tintColor = .INVSDefault()
            infoButton.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
            let size = frame.height * 0.8
            NSLayoutConstraint.activate([
                infoButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
                infoButton.heightAnchor.constraint(equalToConstant: size),
                infoButton.widthAnchor.constraint(equalToConstant: size),
                infoButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 0)
                ])
            let trailingFromInfoButton = -((frame.height * 0.8) + 16)
            trailingLabelConstraint.constant = trailingFromInfoButton
            trailingTextFieldConstraint.constant = trailingFromInfoButton
            layoutIfNeeded()
            
        }
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
        let trailingFromInfoButton = -((frame.height * 0.8) + 16)
        trailingLabelConstraint = placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingFromInfoButton)
        trailingTextFieldConstraint = floatingTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingFromInfoButton)
        heightLabelConstraint = placeholderLabel.heightAnchor.constraint(equalTo: self.heightAnchor)

        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            trailingLabelConstraint,
            placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor),
            heightLabelConstraint
            ])
        NSLayoutConstraint.activate([
            floatingTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            trailingTextFieldConstraint,
            floatingTextField.topAnchor.constraint(equalTo: self.topAnchor),
            floatingTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            bottomLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1),
            bottomLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
    func setupAdditionalConfiguration() {
        floatingTextField.delegate = self
        placeholderLabel.adjustsFontSizeToFitWidth = true
        placeholderLabel.minimumScaleFactor = 0.5
        placeholderLabel.font = bigFont
        placeholderLabel.textColor = .lightGray
        bottomLineView.backgroundColor = .lightGray
    }
}

extension INVSFloatingTextField: UITextFieldDelegate, INVSKeyboardToolbarDelegate {
    
    @objc func infoButtonTapped(_ sender: UIButton) {
        self.delegate?.infoButtonAction(self)
    }
    
    func keyboardToolbar(button: UIBarButtonItem, type: INVSKeyboardToolbarButton, tappedIn toolbar: INVSKeyboardToolbar) {
        self.delegate?.toolbarAction(self, typeOfAction: type)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isBackSpace = string == ""
        let fullText = String.init(format: "%@%@", textField.text ?? "", string)
        textField.text = valueTypeTextField.formatText(textFieldText: fullText, isBackSpace: isBackSpace)
        
        if isBackSpace {
            return true
        }
 
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(self)
        openKeyboard()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.text == "" || textField.text == nil {
            closeKeyboard()
        }
    }
    
    func openKeyboard() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.heightLabelConstraint.constant = -30
            self?.placeholderLabel.font = self?.smallFont
            self?.placeholderLabel.textColor = self?.currentlySelectedColor
            self?.bottomLineView.backgroundColor = self?.currentlySelectedColor
            self?.layoutIfNeeded()
        }
    }
    
    func clear() {
        self.floatingTextField.text = ""
        closeKeyboard()
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


