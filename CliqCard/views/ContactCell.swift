//
//  ContactCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class ContactCell: SeparatorCell {

    lazy var profileImageView: UIImageView! = {
        let view = UIImageView()
        view.backgroundColor = Colors.lightGray
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
//        view.layer.borderColor = Colors.lightGray.cgColor
//        view.layer.borderWidth = 1.0
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    lazy var nameLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont(name: "Lato-Regular", size: 18)
        view.textColor = Colors.darkestGray
        
        return view
    }()
    
    lazy var detailLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont(name: "Lato-Regular", size: 15)
        view.textColor = Colors.gray
        
        return view
    }()
    
    lazy var labelsView: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        self.labelsView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.right.left.top.equalToSuperview()
        }
        
        self.labelsView.addSubview(detailLabel)
        self.detailLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(4)
            make.bottom.right.left.equalToSuperview()
        }
        
        self.addSubview(self.labelsView)
        self.labelsView.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = self.profileImageView.backgroundColor
        super.setSelected(selected, animated: animated)
        self.profileImageView.backgroundColor = color
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = self.profileImageView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        self.profileImageView.backgroundColor = color
    }

}
