//
//  RegistrationPageVC.swift
//  PetLand
//
//  Created by Никита Сигал on 12.02.2023.
//

import UIKit

protocol RegistrationPageProtocol: AnyObject {
    func configure(_ completion: @escaping () -> ())
}

class RegistrationPageVC: UIPageViewController {
    private var current = 0
    private lazy var pages: [UIViewController] = {
        [RegistrationPage1.id,
         RegistrationPage2.id,
         RegistrationPage3.id]
            .compactMap {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: $0)
                (vc as? RegistrationPageProtocol)?.configure(advance)
                return vc
            }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers([pages[current]],
                           direction: .forward,
                           animated: true)
    }

    func advance() {
        current += 1
        if current < pages.count {
            setViewControllers([pages[current]],
                               direction: .forward,
                               animated: true)
        } else {
            performSegue(withIdentifier: "showNavigation", sender: nil)
        }
    }
}
