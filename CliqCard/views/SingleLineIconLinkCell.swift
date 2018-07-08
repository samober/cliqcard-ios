//
//  SingleLineIconLinkCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class SingleLineIconLinkCell: SeparatorCell {
    
    lazy var iconImageView: UIImageView! = {
        let view = UIImageView()
        view.contentMode = .center
        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.vertical)
        
        return view
    }()

    lazy var titleLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = Colors.darkestGray
        
        return view
    }()
    
    lazy var caretImageView: UIImageView! = {
        let view = UIImageView()
        view.setIcon(icon: .fontAwesome(.caretRight), textColor: Colors.lightGray, backgroundColor: UIColor.clear, size: CGSize(width: 28, height: 28))
        view.contentMode = .center
        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.vertical)
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(32)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.top.bottom.equalToSuperview()
        }
        
        self.addSubview(caretImageView)
        caretImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview().offset(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
