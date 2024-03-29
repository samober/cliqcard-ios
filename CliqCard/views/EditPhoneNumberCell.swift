//
//  EditPhoneNumberCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import SwiftIcons
import PhoneNumberKit

class EditPhoneNumberCell: SeparatorCell {
    
    var countryCode: String {
        get {
            return self.countryCodeLabel.text!
        }
        set {
            self.countryCodeLabel.text = newValue
        }
    }
    
    private var _region: String!
    
    var region: String {
        get {
            return self._region
        }
        set {
            self._region = newValue
            let font = UIFont(name: "Lato-Bold", size: 18)!
            self.countryPickerButton.setIcon(prefixText: newValue, prefixTextFont: font, prefixTextColor: Colors.bondiBlue, icon: .icofont(.caretDown),
                                             iconColor: Colors.bondiBlue, postfixText: "", postfixTextFont: font, postfixTextColor: Colors.bondiBlue, forState: .normal, iconSize: 20)
            
            self.phoneNumberField.defaultRegion = newValue
            
            // reformat the phone number
            if let text = self.phoneNumberField.text {
                let phoneNumberKit = PhoneNumberKit()
                let partialFormatter = PartialFormatter(phoneNumberKit: phoneNumberKit, defaultRegion: self._region, withPrefix: true)
                self.phoneNumberField.text = partialFormatter.formatPartial(text)
            }
        }
    }
    
    var phoneNumber: String? {
        get {
            return self.phoneNumberField.text
        }
        set {
            self.phoneNumberField.text = newValue
        }
    }
    
    var showCountryPicker: (() -> Void)?
    
    private lazy var iconImageView: UIImageView! = {
        let view = UIImageView()
        view.contentMode = .center
        view.setIcon(icon: .fontAwesome(.mobile), textColor: Colors.gray, backgroundColor: UIColor.clear, size: CGSize(width: 40, height: 40))
        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        
        return view
    }()
    
    private lazy var countryPickerButton: UIButton! = {
        let view = UIButton()
        view.contentMode = .center
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        
        return view
    }()
    
    private lazy var countryCodeLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont(name: "Lato-Regular", size: 18)
        view.textColor = Colors.darkGray
        
        return view
    }()
    
    lazy var phoneNumberField: SJOPhoneNumberTextField! = {
        let view = SJOPhoneNumberTextField()
        view.font = UIFont(name: "Lato-Regular", size: 18)
        view.textColor = Colors.darkestGray
        view.borderStyle = .none
        view.keyboardType = .numberPad
        view.placeholder = "Phone"
        view.placeholderColor = Colors.gray
//        view.clearButtonMode = .whileEditing
        
        return view
    }()
    
    init(countryCode: String, region: String) {
        super.init(style: .default, reuseIdentifier: nil)
        
        self.countryCode = countryCode
        self.region = region
        
        self.selectionStyle = .none
        
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        
        self.addSubview(countryPickerButton)
        countryPickerButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(16)
        }
        
        self.addSubview(countryCodeLabel)
        countryCodeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(countryPickerButton.snp.right).offset(16)
        }
        
        self.addSubview(phoneNumberField)
        phoneNumberField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(countryCodeLabel.snp.right).offset(8)
            make.right.equalToSuperview().offset(-24)
            make.width.greaterThanOrEqualTo(countryPickerButton.snp.width)
        }
        
        countryPickerButton.addTarget(self, action: #selector(countryButtonPressed(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func countryButtonPressed(sender: UIButton) {
        self.showCountryPicker?()
    }
    
}
