//
//  UITextField+Placeholders.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class SJOTextField: UITextField {
    
    var placeholderColor: UIColor {
        didSet {
            if let placeholder = self.placeholder {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [ NSAttributedStringKey.foregroundColor: self.placeholderColor ])
            }
        }
    }
    
    override var placeholder: String? {
        didSet {
            if let placeholder = self.placeholder {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [ NSAttributedStringKey.foregroundColor: self.placeholderColor ])
            }
        }
    }
    
    override init(frame: CGRect) {
        self.placeholderColor = UIColor("#C7C7CD")
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
