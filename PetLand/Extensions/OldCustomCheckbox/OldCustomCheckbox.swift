//
//  OldCustomCheckbox.swift
//  PetLand
//
//  Created by Никита Сигал on 23.01.2023.
//

import UIKit

@IBDesignable
class OldCustomCheckbox: UIView {
    static let identifier = "OldCustomCheckbox"
    
    @IBInspectable var titleLabel: String? {
        set { checkboxLabel.text = newValue}
        get { checkboxLabel.text }
    }
    
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
        let bundle = Bundle(for: Self.self)
        
        guard let view = bundle.loadNibNamed(Self.identifier, owner: self, options: nil)?.first as? UIView
        else { fatalError("Unable to load nib") }
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(view)
        
        guard let offImage = UIImage(named: "petland:checkbox:off", in: bundle, with: nil),
              let onImage = UIImage(named: "petland:checkbox:on", in: bundle, with: nil)
        else { fatalError("Missing checkbox assets") }
        
        checkboxToggle.setImage(offImage, for: .normal)
        checkboxToggle.setImage(onImage, for: .selected)
    }
}

extension OldCustomCheckbox {
    func configure(isChecked: Bool = false) {
        checkboxToggle.isSelected = isChecked
    }
    
    var isChecked: Bool {
        checkboxToggle.isSelected
    }
}
