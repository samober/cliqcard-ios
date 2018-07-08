//
//  LargeActionButtonCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class LargeActionButtonCell: UITableViewCell {
    
    var buttonColor: UIColor! {
        didSet {
            self.actionButton.setBackgroundImage(UIImage(color: self.buttonColor), for: .normal)
        }
    }

    lazy var actionButton: UIButton! = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.setBackgroundImage(UIImage(color: UIColor.black), for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.buttonColor = Colors.carminePink
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        
        self.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
