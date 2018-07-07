//
//  SeparatorCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit

class SeparatorCell: UITableViewCell {
    
    private lazy var topSeparator: UIView! = {
        let view = UIView()
        view.backgroundColor = Colors.lightGray
        view.layer.zPosition = 1
        
        return view
    }()
    
    private lazy var bottomSeparator: UIView! = {
        let view = UIView()
        view.backgroundColor = Colors.lightGray
        view.layer.zPosition = 1
        
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(topSeparator)
        topSeparator.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(0.5)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
