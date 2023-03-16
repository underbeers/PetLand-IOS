//
//  RegistrationVC.swift
//  PetLand
//
//  Created by Никита Сигал on 12.02.2023.
//

import UIKit

protocol RegistrationPageProtocol {
    func configure(interactor: RegistrationBusinessLogic?)
}

class RegistrationVC: UIPageViewController {
    private var current = 0
    private var pages: [UIViewController] = []

    private var interactor: RegistrationBusinessLogic?

    private func setup() {
        let viewContoller = self
        let interactor = RegistrationInteractor()
        let presenter = RegistrationPresenter()

        viewContoller.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewContoller

        let router = RegistrationRouter()
        interactor.router = router
        router.viewContoller = viewContoller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configurePages()

        setViewControllers([pages[current]],
                           direction: .forward,
                           animated: true)
    }

    private func configurePages() {
        pages = [RegistrationPage1.id,
                 RegistrationPage2.id,
                 RegistrationPage3.id]
            .map {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: $0)
                else { fatalError("Cannot create Registration page") }
                (vc as? RegistrationPageProtocol)?.configure(interactor: interactor)
                return vc
            }
    }
}

extension RegistrationVC: RegistrationDisplayLogic {
    func displayError(_ errorDescription: String) {
        let ac = UIAlertController(title: "Произошла ошибка",
                                   message: errorDescription,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    func displayNextPage() {
        current += 1
        if current < pages.count {
            setViewControllers([pages[current]],
                               direction: .forward,
                               animated: true)
        }
    }
}
