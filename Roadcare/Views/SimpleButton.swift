//
//  SimpleButton.swift
//  EZSportsRP
//
//  Created by admin_user on 2/7/18.
//  Copyright © 2018 admin_user. All rights reserved.
//

import UIKit

@IBDesignable
class SimpleButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 10
    @IBInspectable var bgNormal: UIColor = UIColor.clear
    @IBInspectable var bgHighlighted: UIColor = UIColor.lightGray
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? bgHighlighted : bgNormal
        }
    }
    
}
