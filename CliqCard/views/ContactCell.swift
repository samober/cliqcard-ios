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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
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
