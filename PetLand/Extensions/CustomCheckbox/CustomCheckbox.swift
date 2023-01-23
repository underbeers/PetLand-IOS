//
//  CustomCheckbox.swift
//  PetLand
//
//  Created by Никита Сигал on 23.01.2023.
//

import UIKit

class CustomCheckbox: UIView {
    static let identifier = "CustomCheckbox"
    
    @IBOutlet var checkboxToggle: UIButton!
    @IBOutlet var checkboxLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let nib = UINib(nibName: CustomCheckbox.identifier, bundle: nil)
        guard let view = nib.instantiate(withOwner: self).first as? UIView
        else { fatalError("Unable to convert nib") }
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        backgroundColor = .none
        addSubview(view)
        
        guard let offImage = UIImage(named: "petland:checkbox:off"),
              let onImage = UIImage(named: "petland:checkbox:on")
        else { fatalError("Missing checkbox assets") }
        
        checkboxToggle.setImage(offImage, for: .normal)
        checkboxToggle.setImage(onImage, for: .selected)
    }
}

extension CustomCheckbox {
    func configure(label: String, isChecked: Bool = false) {
        checkboxLabel.text = label
        checkboxToggle.isSelected = isChecked
    }
    
    var isChecked: Bool {
        checkboxToggle.isSelected
    }
}
