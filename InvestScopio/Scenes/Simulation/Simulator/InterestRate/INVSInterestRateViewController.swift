//
//  INVSInterestRateViewController.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 26/08/19.
//  Copyright (c) 2019 Joao Medeiros Pereira. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import BetterSegmentedControl
import ZCAnimatedLabel

protocol INVSInterestRateViewControllerDelegate: class {
    func didChangeInterestRate(type: INVSInterestRateType, value: String)
}

protocol INVSInterestRateViewControllerProtocol: class {
    func displayChangeType(type: INVSInterestRateType)
}

class INVSInterestRateViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    var interestRateTypeSegmentedControl = BetterSegmentedControl.init(
        frame: .zero,
        segments: LabelSegment.segments(withTitles: ["Mensal", "Anual"],
                                        normalFont: UIFont(name: "Avenir", size: 13.0)!,
                                        normalTextColor: .white,
                                        selectedFont: UIFont(name: "Avenir", size: 13.0)!,
                                        selectedTextColor: .INVSDefault()),
        options:[.backgroundColor(.INVSDefault()),
                 .indicatorViewBackgroundColor(.white),
                 .cornerRadius(25.0),
                 .bouncesOnChange(true)
        ])
    var messageLabel = ZCAnimatedLabel()
    var interestRateTextField = INVSFloatingTextField(frame:.zero)
    var messageLabelWidthConstraint = NSLayoutConstraint()
    var messageLabelHeightConstraint = NSLayoutConstraint()
    var bottomViewHeightConstraint = NSLayoutConstraint()
    @IBOutlet weak var bottomContentViewConstraint: NSLayoutConstraint!
    var delegate: INVSInterestRateViewControllerDelegate?
    var type: INVSInterestRateType = .monthly
    var interactor: INVSInterestRateInteractorProtocol?
    var router: INVSRoutingLogic?
    var shapeLayer: CAShapeLayer?
    

  // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
  // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = INVSInterestRateInteractor()
        let presenter = INVSInterestRatePresenter()
        let router = INVSRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
  // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Taxa de Juros"
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interestRateTextField.floatingTextField.becomeFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                bottomContentViewConstraint.constant = keyboardHeight
                UIView.animate(withDuration: 0.4) {
                    self.view.layoutIfNeeded()
                }
            }
    }
                
    @objc func keyboardWillHide(notification: NSNotification){
        bottomContentViewConstraint.constant = 0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupNavigationBarButtons() {
                
        let button = UIButton.init(frame: .init(x: 0, y: 0, width: 20, height: 20))
        button.setAttributedTitle(NSAttributedString.init(string: "X", attributes: [NSAttributedString.Key.font : UIFont.INVSFontDefaultBold()]), for: .normal)
        button.tintColor = UIColor.darkGray
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem.init(customView: button)
        navigationItem.leftBarButtonItem = barButtonItem
        
        let filterButton = UIButton.init(frame: .init(x: 0, y: 0, width: 60, height: 20))
                        filterButton.setAttributedTitle(NSAttributedString.init(string: "Finalizar", attributes: [NSAttributedString.Key.font : UIFont.INVSFontDefaultBold(), NSAttributedString.Key.foregroundColor : UIColor.INVSDefault()]), for: .normal)
                        filterButton.tintColor = UIColor.darkGray
                        filterButton.addTarget(self, action: #selector(okAction(_:)), for: .touchUpInside)
                        let barButtonItemFilter = UIBarButtonItem.init(customView: filterButton)
                        navigationItem.rightBarButtonItem = barButtonItemFilter
    }
        
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        shapeLayer = CAShapeLayer.addCorner(withShapeLayer: shapeLayer, withCorners: [.topLeft, .topRight], withRoundedCorner: 16, andColor: .white, inView: contentView, andOffSet: CGSize(width: -1, height: -1))
    }
    
    //MARK: Common methods
    private func resetConstraints() {
        self.messageLabelWidthConstraint.constant = 0
        self.messageLabelHeightConstraint.constant = 0
        contentView.layoutIfNeeded()
    }
    
    private func setNewAttributedText(messageMutableAttributedString: NSMutableAttributedString) {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            style.alignment = .center
            style.lineBreakMode = .byWordWrapping
            let range: NSRange = messageMutableAttributedString.mutableString.range(of: messageMutableAttributedString.string)
            messageMutableAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
            resetConstraints()
            self.messageLabel.attributedString = messageMutableAttributedString
            self.messageLabel.animationDuration = 0.3
            self.messageLabel.animationDelay = 0.02
            self.messageLabel.layoutTool.groupType = .char
            if let superWidth = self.messageLabel.superview?.frame.width {
                let messageLabelWidth = self.messageLabel.attributedString.width(withConstrainedHeight: self.messageLabel.intrinsicContentSize.height)
                self.messageLabelWidthConstraint.constant = messageLabelWidth > superWidth ? superWidth : messageLabelWidth
                self.messageLabelHeightConstraint.constant = self.messageLabel.attributedString.height(withConstrainedWidth: self.messageLabelWidthConstraint.constant)
                    contentView.layoutIfNeeded()
            }
            self.messageLabelWidthConstraint.constant = self.messageLabel.attributedString.getNewWidth(with: self.messageLabelWidthConstraint)
            contentView.layoutIfNeeded()
            self.messageLabel.startAppearAnimation()
        }
    
    //MARK: Actions
    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }

   @objc func okAction(_ sender: Any) {
        interactor?.interestRateValue = interestRateTextField.textFieldText
        delegate?.didChangeInterestRate(type: type, value: interactor?.interestRateValue ?? "")
        self.dismiss(animated: true, completion: nil)
   }
    
    @objc func segmentedControlInterestRateTypeChanged(_ sender: BetterSegmentedControl) {
        interactor?.changeType(index: sender.index)
    }

}

extension INVSInterestRateViewController: INVSCodeView {
    func buildViewHierarchy() {
        contentView.addSubview(interestRateTypeSegmentedControl)
        contentView.addSubview(messageLabel)
        contentView.addSubview(interestRateTextField)
        interestRateTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        interestRateTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        messageLabelWidthConstraint = messageLabel.widthAnchor.constraint(equalToConstant: 0)
        messageLabelHeightConstraint = messageLabel.heightAnchor.constraint(equalToConstant: 0)
        bottomViewHeightConstraint = interestRateTextField.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([
                    messageLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                    messageLabelWidthConstraint,
                    messageLabelHeightConstraint,
                    messageLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: contentView.safeAreaInsets.top + 8)
        ])
        NSLayoutConstraint.activate([
            interestRateTypeSegmentedControl.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            interestRateTypeSegmentedControl.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            interestRateTypeSegmentedControl.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            interestRateTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            interestRateTextField.topAnchor.constraint(equalTo: interestRateTypeSegmentedControl.bottomAnchor, constant: 16),
            interestRateTextField.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            interestRateTextField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            bottomViewHeightConstraint
        ])
    }
    
    func setupAdditionalConfiguration() {
        setupNavigationBarButtons()
        interestRateTypeSegmentedControl.addTarget(self, action: #selector(INVSInterestRateViewController.segmentedControlInterestRateTypeChanged(_:)), for: .valueChanged)
        let messageMutableAttributedString = NSMutableAttributedString()
                messageMutableAttributedString.append(NSAttributedString.subtitle(withText: "Você deseja taxas de juros\n"))
                messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "Anual ou mensal?"))
        setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
        interestRateTextField.delegate = self
        interestRateTextField.textFieldText = interactor?.interestRateValue ?? ""
        interestRateTextField.setup(placeholder: type.getPlaceHolder(), typeTextField: .interestRate, valueTypeTextField: .percent, keyboardType: .numberPad, required: false, hasInfoButton: false, color: UIColor.INVSDefault())
    }

}

extension INVSInterestRateViewController: INVSFloatingTextFieldDelegate {
    func infoButtonAction(_ textField: INVSFloatingTextField) {
        
    }
    
    func toolbarAction(_ textField: INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: INVSFloatingTextField) {
        
    }
    
    
}

extension INVSInterestRateViewController: INVSInterestRateViewControllerProtocol {
    func displayChangeType(type: INVSInterestRateType) {
        self.type = type
        interestRateTextField.setup(placeholder: self.type.getPlaceHolder(), typeTextField: .interestRate, valueTypeTextField: .percent, keyboardType: .numberPad, required: false, hasInfoButton: false, color: UIColor.INVSDefault())
    }
}

