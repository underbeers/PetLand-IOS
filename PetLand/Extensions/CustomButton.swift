//
//  CustomButton.swift
//  PetLand
//
//  Created by Никита Сигал on 23.01.2023.
//
import UIKit

@IBDesignable
class CustomButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            layoutSubviews()
        }
    }

    @IBInspectable var isFilled: Bool = true
    @IBInspectable var isBold: Bool = true
    @IBInspectable var accentColor: UIColor = .cAccent1

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        layer.cornerRadius = 15
        clipsToBounds = true

        layoutSubviews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if isFilled {
            backgroundColor = accentColor.withAlphaComponent(isEnabled ? 1 : 0.75)
            titleLabel?.textColor = .white
        } else {
            backgroundColor = .clear
            titleLabel?.textColor = .cText
            layer.borderWidth = 3
            layer.borderColor = accentColor.withAlphaComponent(isEnabled ? 1 : 0.5).cgColor
        }

        if isBold {
            titleLabel?.font = UIFont(name: "Mulish-Bold", size: 18)
        } else {
            titleLabel?.font = UIFont(name: "Mulish-SemiBold", size: 16)
        }

        titleLabel?.numberOfLines = 1
    }
}
