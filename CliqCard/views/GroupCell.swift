//
//  GroupCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class GroupCell: UITableViewCell {
    
    lazy var groupImageView: UIImageView! = {
        let view = UIImageView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        
        return view
    }()
    
    lazy var nameLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.boldSystemFont(ofSize: 18)
        
        return view
    }()
    
    lazy var membersLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = UIColor.lightGray
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(groupImageView)
        groupImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(groupImageView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(-12)
        }
        
        self.addSubview(membersLabel)
        membersLabel.snp.makeConstraints { make in
            make.left.equalTo(groupImageView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(12)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
