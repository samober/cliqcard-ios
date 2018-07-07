//
//  InlineDataCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class InlineDataCell: UITableViewCell {
    
    var key: String? {
        get {
            return self.keyLabel.text
        }
        set {
            self.keyLabel.text = newValue
        }
    }
    
    var value: String? {
        get {
            return self.valueLabel.text
        }
        set {
            self.valueLabel.text = newValue
            self.valueLabel.isHidden = self.valueLabel.text == nil
            self.placeholderLabel.isHidden = self.valueLabel.text != nil
        }
    }
    
    var placeholder: String? {
        get {
            return self.placeholderLabel.text
        }
        set {
            self.placeholderLabel.text = newValue
        }
    }

    private lazy var keyLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.boldSystemFont(ofSize: 16)
        
        return view
    }()
    
    private lazy var valueLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 16)
        
        return view
    }()
    
    private lazy var placeholderLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = UIColor.lightGray
        
        return view
    }()
    
    private lazy var topSeparator: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        
        return view
    }()
    
    private lazy var bottomSeparator: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.addSubview(keyLabel)
        keyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(topSeparator)
        topSeparator.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(96)
        }
        
        self.addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(0.5)
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(96)
        }
        
        placeholderLabel.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
