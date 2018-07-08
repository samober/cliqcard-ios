//
//  InlineDataCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class InlineDataCell: SeparatorCell {

    lazy var keyLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.boldSystemFont(ofSize: 16)
        view.textColor = Colors.darkestGray
        
        return view
    }()
    
    lazy var valueLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = Colors.darkestGray
        
        return view
    }()
    
    lazy var placeholderLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = Colors.gray
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.addSubview(keyLabel)
        keyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview().offset(1)
        }
        
        self.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(116)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(116)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
