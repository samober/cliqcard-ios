//
//  ProfileHeaderCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class ProfileHeaderCell: UITableViewCell {
    
    lazy var profileImageButton: UIButton! = {
        let view = UIButton(type: .custom)
        view.backgroundColor = Colors.lightGray
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderColor = Colors.lightGray.cgColor
        view.layer.borderWidth = 1.0
        view.imageView?.contentMode = .scaleAspectFill
        
        return view
    }()
    
    lazy var nameLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.boldSystemFont(ofSize: 32)
        view.textAlignment = .center
        
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        
        self.selectionStyle = .none
        
        self.addSubview(profileImageButton)
        profileImageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(144)
        }
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
