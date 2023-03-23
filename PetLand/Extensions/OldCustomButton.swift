//
//  OldCustomButton.swift
//  PetLand
//
//  Created by Никита Сигал on 23.01.2023.
//
import UIKit

@IBDesignable
class OldCustomButton: UIButton {
    @IBInspectable var isFilled: Bool = true
    @IBInspectable var isBold: Bool = true
    @IBInspectable var accentColor: UIColor = .blue

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
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        layoutSubviews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if isFilled {
            backgroundColor = accentColor.withAlphaComponent(isEnabled ? 1 : 0.75)
            titleLabel?.textColor = .white
        } else {
            backgroundColor = .clear
            titleLabel?.textColor = .blue.withAlphaComponent(isEnabled ? 1 : 0.75)
            layer.borderWidth = 3
            layer.borderColor = accentColor.withAlphaComponent(isEnabled ? 1 : 0.75).cgColor
        }

        if isBold {
            titleLabel?.font = UIFont(name: "Mulish-Bold", size: 18)
        } else {
            titleLabel?.font = UIFont(name: "Mulish-SemiBold", size: 16)
        }

        titleLabel?.numberOfLines = 1
    }
}
