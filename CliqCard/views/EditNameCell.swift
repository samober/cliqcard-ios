//
//  EditNameCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import SwiftIcons

class EditNameCell: SeparatorCell {

    private lazy var iconImageView: UIImageView! = {
        let view = UIImageView()
        view.contentMode = .center
        view.setIcon(icon: .fontAwesome(.user), textColor: Colors.darkGray, backgroundColor: UIColor.clear, size: CGSize(width: 40, height: 40))
        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        
        return view
    }()
    
    lazy var nameField: SJOTextField! = {
        let view = SJOTextField()
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = Colors.darkestGray
        view.borderStyle = .none
        view.placeholder = "Name"
        view.placeholderColor = Colors.gray
        //        view.clearButtonMode = .whileEditing
        
        return view
    }()
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        
        self.selectionStyle = .none
        
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(nameField)
        nameField.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
