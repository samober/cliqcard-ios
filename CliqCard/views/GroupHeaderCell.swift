//
//  GroupHeaderCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class GroupHeaderCell: UITableViewCell {

    lazy var imageButton: UIButton! = {
        let view = UIButton(type: .custom)
        view.backgroundColor = Colors.lightGray
        view.layer.cornerRadius = 100
        view.layer.masksToBounds = true
//        view.layer.borderColor = Colors.lightGray.cgColor
//        view.layer.borderWidth = 1.0
        view.imageView?.contentMode = .scaleAspectFill
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        self.addSubview(imageButton)
        imageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
