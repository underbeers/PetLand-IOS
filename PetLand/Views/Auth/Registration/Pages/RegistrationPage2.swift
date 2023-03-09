//
//  RegistrationPage2.swift
//  PetLand
//
//  Created by Никита Сигал on 12.02.2023.
//

import UIKit

class RegistrationPage2: UIViewController {
    static let id = "Registration.Page2"
    
    @IBOutlet var emailTF: CustomTextField!
    @IBOutlet var sendCodeButton: CustomButton!
    @IBOutlet var waitLabel: UILabel!
    @IBOutlet var codeTF: CustomTextField!
    @IBOutlet var nextButton: CustomButton!
    
    private var completion: (() -> ())?
    private var secondsLeft: Int = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.configure(for: .email, delegate: self)
        codeTF.configure(for: .verificationCode, delegate: self)
    }
    
    @IBAction func onSendCodeButtonPress() {
        let code = Int.random(in: 100_000 ... 999_999)
        print(code)
        
        secondsLeft = 30
        waitLabel.text = "Подождите \(secondsLeft) секунд"
        waitLabel.isHidden = false        
        sendCodeButton.isEnabled = false
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.secondsLeft -= 1
            if self?.secondsLeft == 0 {
                self?.waitLabel.isHidden = true
                self?.sendCodeButton.isEnabled = true
                timer.invalidate()
            } else {
                self?.waitLabel.text = "Подождите \(self?.secondsLeft ?? 0) секунд"
            }
        }
    }
    
    @IBAction func onNextButtonPress() {
        completion?()
    }
}

extension RegistrationPage2: RegistrationPageProtocol {
    func configure(_ completion: @escaping () -> ()) {
        self.completion = completion
    }
}

extension RegistrationPage2: CustomTextFieldDelegate {
    func onEditingChanged() {
        nextButton.isEnabled = emailTF.isValid && codeTF.isValid
    }
}
