//
//  CountryCodeCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class CountryCodeCell: SeparatorCell {
    
    var country: String? {
        get {
            return self.countryLabel.text
        }
        set {
            self.countryLabel.text = newValue
        }
    }
    
    var code: String? {
        get {
            return self.codeLabel.text
        }
        set {
            self.codeLabel.text = newValue
        }
    }

    private lazy var countryLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = Colors.darkestGray
        
        return view
    }()
    
    private lazy var codeLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = Colors.darkGray
        view.textAlignment = .right
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(codeLabel)
        codeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
