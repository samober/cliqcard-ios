//
//  InlinePhoneTextFieldCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import PhoneNumberKit

class InlinePhoneTextFieldCell: UITableViewCell {

    lazy var label: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.boldSystemFont(ofSize: 15)
        
        return view
    }()
    
    lazy var countryCodeLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 14)
        view.textAlignment = .right
        view.text = "+1"
        
        return view
    }()
    
    lazy var textField: PhoneNumberTextField! = {
        let view = PhoneNumberTextField()
        view.borderStyle = .none
        view.textAlignment = .right
        view.placeholder = "+1 (555) 234-9876"
        
        return view
    }()
    
    lazy var topSeparator: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        
        return view
    }()
    
    lazy var bottomSeparator: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
        }
        
        self.addSubview(countryCodeLabel)
        countryCodeLabel.snp.makeConstraints { make in
            make.right.equalTo(textField.snp.left).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(topSeparator)
        topSeparator.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(0.5)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
