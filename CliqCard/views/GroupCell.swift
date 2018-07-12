//
//  GroupCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import SwiftIcons

class GroupCell: SeparatorCell {
    
    lazy var groupImageView: UIImageView! = {
        let view = UIImageView()
        view.backgroundColor = Colors.lightGray
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    lazy var nameLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont(name: "Lato-Bold", size: 18)
        view.textColor = Colors.darkestGray
        
        return view
    }()
    
    lazy var membersLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont(name: "Lato-Regular", size: 15)
        view.textColor = UIColor.lightGray
        
        return view
    }()
    
    lazy var labelsView: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    lazy var shareButton: UIButton! = {
        let view = UIButton(type: .system)
        view.setIcon(icon: .fontAwesome(.userPlus), iconSize: 20, color: Colors.gray, backgroundColor: UIColor.clear, forState: .normal)
//        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        view.setIcon(prefixText: "", prefixTextFont: UIFont(), prefixTextColor: .clear, icon: .fontAwesome(.shareSquareO), iconColor: Colors.gray, postfixText: "  Share", postfixTextFont: UIFont(name: "Lato-Bold", size: 15)!, postfixTextColor: Colors.gray, backgroundColor: .clear, forState: .normal, iconSize: 16)
//        view.setIcon(icon: .fontAwesome(.shareSquareO), title: "Share", font: UIFont(name: "Lato-Bold", size: 15)!, forState: .normal)
//        view.setIcon(icon: .fontAwesome(.shareSquareO), title: "Share", font: UIFont(name: "Lato-Bold", size: 15), forState: .normal)
//        view.setTitleColor(Colors.gray, for: .normal)
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(groupImageView)
        groupImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        self.addSubview(self.shareButton)
        self.shareButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        self.labelsView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
        }
        
        self.labelsView.addSubview(membersLabel)
        membersLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        self.addSubview(self.labelsView)
        self.labelsView.snp.makeConstraints { make in
            make.left.equalTo(groupImageView.snp.right).offset(16)
            make.right.equalTo(self.shareButton.snp.left).offset(-24)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = self.groupImageView.backgroundColor
        super.setSelected(selected, animated: animated)
        self.groupImageView.backgroundColor = color
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = self.groupImageView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        self.groupImageView.backgroundColor = color
    }

}
