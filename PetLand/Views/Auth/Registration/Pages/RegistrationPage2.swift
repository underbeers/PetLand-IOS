//
//  RegistrationPage2.swift
//  PetLand
//
//  Created by Никита Сигал on 12.02.2023.
//

import UIKit

class RegistrationPage2: UIViewController {
    static let id = "Registration.Page2"
    
    @IBOutlet var emailTF: OldCustomTextField!
    @IBOutlet var sendCodeButton: OldCustomButton!
    @IBOutlet var waitLabel: UILabel!
    @IBOutlet var codeTF: OldCustomTextField!
    @IBOutlet var nextButton: OldCustomButton!
    
    private var interactor: RegistrationBusinessLogic?
    
    private var secondsLeft: Int = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendCodeButton.isEnabled = false
        
        emailTF.configure(for: .email, delegate: self)
        codeTF.configure(for: .verificationCode, delegate: self)
    }
    
    @IBAction func onSendCodeButtonPress() {
        let code = ValidationManager.shared.generateVerificationCode()
        interactor?.verifyEmail(email: emailTF.text, code: code)
        
        secondsLeft = 30
        waitLabel.text = "Подождите \(secondsLeft) секунд"
        waitLabel.isHidden = false        
        codeTF.text = ""
        updateSendCodeButton()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.secondsLeft -= 1
            if self?.secondsLeft == 0 {
                self?.waitLabel.isHidden = true
                self?.updateSendCodeButton()
                timer.invalidate()
            } else {
                self?.waitLabel.text = "Подождите \(self?.secondsLeft ?? 0) секунд"
            }
        }
    }
    
    func updateSendCodeButton() {
        sendCodeButton.isEnabled = emailTF.isValid && waitLabel.isHidden
    }
    
    @IBAction func onNextButtonPress() {
        interactor?.model.email = emailTF.text
        interactor?.advancePage()
    }
}

extension RegistrationPage2: RegistrationPageProtocol {
    func configure(interactor: RegistrationBusinessLogic?) {
        self.interactor = interactor
    }
}

extension RegistrationPage2: CustomTextFieldDelegate {
    func onEditingChanged() {
        updateSendCodeButton()
        nextButton.isEnabled = emailTF.isValid && codeTF.isValid
        codeTF.isUserInteractionEnabled = !codeTF.isValid
    }
}
