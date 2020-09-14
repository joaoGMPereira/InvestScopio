//
//  INVSFaqViewController.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 28/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit
import MessageUI
import Lottie

protocol INVSTalkWithUsViewControllerProtocol: class, INVSConnectorErrorProtocol {
    func displaySuccessSendVote(withTitle title:String, andMessage message: String)
    func displaySuccessSendEmail(withSubject subject: String, recipients: String, andMessageBody messageBody: String)
}


class INVSTalkWithUsViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleEvaluateLabel: UILabel!
    @IBOutlet weak var firstStarAnimationView: AnimationView!
    @IBOutlet weak var secondStarAnimationView: AnimationView!
    @IBOutlet weak var thirdStarAnimationView: AnimationView!
    @IBOutlet weak var fourthStartAnimationView: AnimationView!
    @IBOutlet weak var fifthStarAnimationView: AnimationView!
    var allAnimations = [AnimationView]()
    
    @IBOutlet weak var tellMoreTitleLabel: UILabel!
    @IBOutlet weak var tellMoreMessageLabel: UILabel!
    @IBOutlet weak var sendEmailButton: INVSLoadingButton!
    @IBOutlet weak var sendOpinionButton: INVSLoadingButton!
    var popupMessage: INVSPopupMessage?
    
    @IBOutlet weak var typeFeedbackView: UIView!
    @IBOutlet weak var feedabackLabel: UILabel!
    @IBOutlet weak var feedabackInfoLabel: UILabel!
    @IBOutlet weak var feedbackArrowImageView: UIImageView!
    @IBOutlet weak var versionLabel: UILabel!
    
    var opinionShapeLayer: CAShapeLayer?
    var feedbackShapeLayer: CAShapeLayer?
    
    var interactor: INVSTalkWithUsInteractorProtocol?
  //  var router: INVSRoutingLogic? = INVSRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fale Conosco"
        setup()
        allAnimations = [firstStarAnimationView, secondStarAnimationView, thirdStarAnimationView, fourthStartAnimationView, fifthStarAnimationView]
        popupMessage = INVSPopupMessage(parentViewController: self)
        setLabelsInfo()
        setButtonsInfo()
        setGrayStars()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBordedViewBackgrounds()
        
    }
    
    // MARK: Setup
    private func setup() {
//        let viewController = self
//        let interactor = INVSTalkWithUsInteractor()
//        let presenter = INVSTalkWithUsPresenter()
//        let router = INVSRouter()
//        viewController.interactor = interactor
//        viewController.router = router
//        interactor.presenter = presenter
//        presenter.viewController = viewController
    }
    
    func setBordedViewBackgrounds() {
        opinionShapeLayer = CAShapeLayer.addCorner(withShapeLayer: opinionShapeLayer, withCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], withRoundedCorner: 8, andColor: .white, inView: contentView)
        feedbackShapeLayer = CAShapeLayer.addCorner(withShapeLayer: feedbackShapeLayer, withCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], withRoundedCorner: 8, andColor: .white, inView: typeFeedbackView)
    }
    
    func setLabelsInfo() {
        tellMoreMessageLabel.text = "Caso tenha alguma dúvida, sugestão ou crítica, nos envie um email.\n\nCaso encontre algum problema, por favor nos envie ele, se possível tente tirar prints.\n\nVamos tentar resolve-los o mais breve possível."
        feedabackLabel.text = ""
        versionLabel.text = "v\(INVSTalkWithUsWorker.getAppVersion())"
        titleEvaluateLabel.font = .INVSSmallFontDefaultBold()
        tellMoreTitleLabel.font = .INVSSmallFontDefaultBold()
        tellMoreMessageLabel.font = .INVSSmallFontDefault()
        feedabackInfoLabel.font = .INVSSmallFontDefault()
        feedabackLabel.font = .INVSSmallFontDefault()
        versionLabel.font = .INVSSmallFontDefault()
        feedabackLabel.textColor = .darkGray
        versionLabel.textColor = .darkGray
        feedbackArrowImageView.tintColor = .INVSDefault()
        let feedbackTapGesture = UITapGestureRecognizer(target: self, action: #selector(feedbackAction))
        typeFeedbackView.addGestureRecognizer(feedbackTapGesture)
        
    }
    
    func setButtonsInfo() {
        sendEmailButton.setupFillGradient(withColor: UIColor.INVSGradientColors(), title: "Envie um email", andRounded: true)
        sendEmailButton.button.isEnabled = false
        sendEmailButton.buttonAction = {(button) in
            self.interactor?.sendEmail(withFeedback: self.feedabackLabel.text ?? "Feedback")
        }
        sendOpinionButton.setupFillGradient(withColor: UIColor.INVSGradientColors(), title: "Envie sua avaliação", andRounded: true)
        
        sendOpinionButton.buttonAction = {(button) in
            self.sendOpinionButton.showLoading()
            self.interactor?.sendOpinion()
        }
    }
    
    func setGrayStars() {
        for (index, animationView) in allAnimations.enumerated() {
            let starTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapStar(sender:)))
            let starAnimation = Animation.named("star")
            animationView.tag = index
            animationView.animation = starAnimation
            animationView.contentMode = .scaleAspectFit
            animationView.animationSpeed = 1.0
            animationView.play(fromFrame: 8, toFrame: 12, loopMode: .playOnce, completion: nil)
            animationView.addGestureRecognizer(starTapGesture)
        }
    }
    
    @objc func didTapStar(sender: UITapGestureRecognizer) {
        if let indexStar = sender.view?.tag {
            interactor?.evaluate = indexStar
            for animationView in allAnimations {
                animationView.play(fromFrame: 8, toFrame: 12, loopMode: .playOnce, completion: nil)
            }
            for index in 0...indexStar {
                let animationView = allAnimations[index]
                animationView.loopMode = .playOnce
                animationView.play()
            }
        }
    }
    
    @objc func feedbackAction() {
        let alertController = UIAlertController(title: "Selecione o tipo do feedback", message: nil, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Sugestão", style: .default) { (action:UIAlertAction) in
            if let title = action.title {
                self.setSelectedFeedback(title: title, alertController: alertController)
            }
        }
        
        let action2 = UIAlertAction(title: "Reclamação", style: .default) { (action:UIAlertAction) in
            if let title = action.title {
                self.setSelectedFeedback(title: title, alertController: alertController)
            }
        }
        
        let action3 = UIAlertAction(title: "Elogio", style: .default) { (action:UIAlertAction) in
            if let title = action.title {
                self.setSelectedFeedback(title: title, alertController: alertController)
            }
            
        }
        
        let action4 = UIAlertAction(title: "Feedback", style: .default) { (action:UIAlertAction) in
            if let title = action.title {
                self.setSelectedFeedback(title: title, alertController: alertController)
            }
        }
        let action5 = UIAlertAction(title: "Cancelar", style: .cancel) { (action:UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        alertController.addAction(action4)
        alertController.addAction(action5)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setSelectedFeedback(title: String, alertController: UIAlertController) {
        self.feedabackLabel.text = title
        sendEmailButton.button.isEnabled = true
        alertController.dismiss(animated: true, completion: nil)
    }
}

extension INVSTalkWithUsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent {
            popupMessage?.show(withTextMessage: INVSConstants.TalkWithUsAlertViewController.messageMailSuccess.rawValue, title: INVSConstants.TalkWithUsAlertViewController.titleSuccess.rawValue, popupType: .alert, shouldHideAutomatically: true, sender: nil)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

extension INVSTalkWithUsViewController: INVSTalkWithUsViewControllerProtocol {
    func displayErrorDefault(titleError: String, messageError: String, shouldHideAutomatically: Bool, popupType: INVSPopupMessageType) {
        self.sendOpinionButton.hideLoading()
        popupMessage?.show(withTextMessage: messageError, title: titleError, popupType: .error, shouldHideAutomatically: true, sender: nil)
    }
    
    func displayErrorAuthentication(titleError: String, messageError: String, shouldRetry: Bool) {
        self.sendOpinionButton.hideLoading()
        self.tabBarController?.tabBar.isHidden = true
//        INVSConnectorHelpers.presentErrorRememberedUserLogged(lastViewController: self, message: messageError, title: titleError, shouldRetry: shouldRetry, successCompletion: {
//            self.tabBarController?.tabBar.isHidden = false
//            self.interactor?.sendOpinion()
//        }) {
//            self.tabBarController?.tabBar.isHidden = false
//            self.goToLogin()
//        }
    }
    
    func displayErrorSettings(titleError: String, messageError: String) {
        self.sendOpinionButton.hideLoading()
        self.tabBarController?.tabBar.isHidden = true
//        INVSConnectorHelpers.presentErrorGoToSettingsRememberedUserLogged(lastViewController: self, message: messageError, title: titleError, finishCompletion: {
//            self.tabBarController?.tabBar.isHidden = false
//            self.goToLogin()
//        })
    }
    
    func displayErrorLogout(titleError: String, messageError: String) {
        self.sendOpinionButton.hideLoading()
        self.tabBarController?.tabBar.isHidden = true
//        INVSConnectorHelpers.presentErrorRememberedUserLogged(lastViewController: self) {
//            self.tabBarController?.tabBar.isHidden = false
//            self.goToLogin()
//        }
    }
    
    func goToLogin() {
        self.dismiss(animated: false, completion: nil)
       // router?.routeToLogin()
    }
    
    func displaySuccessSendVote(withTitle title:String, andMessage message: String) {
        self.sendOpinionButton.hideLoading()
        popupMessage?.show(withTextMessage: message, title: title, popupType: .alert, shouldHideAutomatically: true, sender: nil)
    }
    
    func displaySuccessSendEmail(withSubject subject: String, recipients: String, andMessageBody messageBody: String) {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setSubject(subject)
        mail.setToRecipients([recipients])
        mail.setMessageBody(messageBody, isHTML: true)
        
        present(mail, animated: true)
    }
}
