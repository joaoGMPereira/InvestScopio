//
//  KeyboardToolbar.swift
//  InvestEx_Example
//
//  Created by Joao Medeiros Pereira on 10/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

enum INVSKeyboardToolbarButton: Int {
    
    case ok = 0
    case cancel
    case back, backDisabled
    case forward, forwardDisabled
    
    func createButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        var button: UIBarButtonItem!
        
        switch self {
        case .back:
            button = UIBarButtonItem(title: "back", style: .plain, target: target, action: action)
        case .backDisabled:
            button = UIBarButtonItem(title: "back", style: .plain, target: target, action: action)
            button.isEnabled = false
        case .forward:
            button = UIBarButtonItem(title: "forward", style: .plain, target: target, action: action)
        case .forwardDisabled:
            button = UIBarButtonItem(title: "forward", style: .plain, target: target, action: action)
            button.isEnabled = false
        case .ok:
            button = UIBarButtonItem(title: "Ok", style: .plain, target: target, action: action)
        case .cancel:
            button = UIBarButtonItem(title: "cancel", style: .plain, target: target, action: action)
        }
        button.tag = rawValue
        return button
    }
    
    static func detectType(barButton: UIBarButtonItem) -> INVSKeyboardToolbarButton? {
        return INVSKeyboardToolbarButton(rawValue: barButton.tag)
    }
}

protocol INVSKeyboardToolbarDelegate: class {
    func keyboardToolbar(button: UIBarButtonItem, type: INVSKeyboardToolbarButton, tappedIn toolbar: INVSKeyboardToolbar)
}

class INVSKeyboardToolbar: UIToolbar {
    
    weak var toolBarDelegate: INVSKeyboardToolbarDelegate?
    
    init() {
        super.init(frame: .zero)
        barStyle = UIBarStyle.default
        isTranslucent = true
        sizeToFit()
        isUserInteractionEnabled = true
    }
    
    func setup(leftButtons: [INVSKeyboardToolbarButton] = [INVSKeyboardToolbarButton](), rightButtons: [INVSKeyboardToolbarButton] = [INVSKeyboardToolbarButton]()) {

        let leftBarButtons = leftButtons.map { (item) -> UIBarButtonItem in
            return item.createButton(target: self, action: #selector(buttonTapped))
        }
        
        let rightBarButtons = rightButtons.map { (item) -> UIBarButtonItem in
            return item.createButton(target: self, action: #selector(buttonTapped(sender:)))
        }
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setItems(leftBarButtons + [spaceButton] + rightBarButtons, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func buttonTapped(sender: UIBarButtonItem) {
        if let type = INVSKeyboardToolbarButton.detectType(barButton: sender) {
            toolBarDelegate?.keyboardToolbar(button: sender, type: type, tappedIn: self)
        }
    }
    
}
