//
//  UpdatePictureCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/8/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class UpdatePictureCell: SeparatorCell {
    
    lazy var pictureView: UIImageView! = {
        let view = UIImageView()
        view.backgroundColor = Colors.lightGray
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
//        view.layer.borderColor = Colors.lightGray.cgColor
//        view.layer.borderWidth = 1.0
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    lazy var descriptionLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont(name: "Lato-Regular", size: 18)
        view.textColor = Colors.darkestGray
        view.numberOfLines = 0
        
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(self.pictureView)
        self.pictureView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(self.pictureView.snp.right).offset(24)
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
