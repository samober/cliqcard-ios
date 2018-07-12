//
//  InformationSelectView.swift
//  CliqCard
//
//  Created by Sam Ober on 7/12/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class InformationSelectView: UIView {
    
    var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.radioButtonView.backgroundColor = Colors.bondiBlue
            } else {
                self.radioButtonView.backgroundColor = Colors.gray
            }
        }
    }
    
    lazy var radioButtonView: UIView! = {
        let view = UIView()
        view.backgroundColor = Colors.gray
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        
        return view
    }()

    lazy var typeLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont(name: "Lato-Bold", size: 15)
        view.textColor = Colors.gray
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return view
    }()
    
    lazy var valueLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont(name: "Lato-Regular", size: 18)
        view.textColor = Colors.darkestGray
        
        return view
    }()
    
    override init(frame: CGRect) {
        self.isSelected = false
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.radioButtonView)
        self.radioButtonView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        self.addSubview(self.typeLabel)
        self.typeLabel.snp.makeConstraints { make in
            make.left.equalTo(self.radioButtonView.snp.right).offset(24)
            make.top.bottom.equalToSuperview()
        }
        
        self.addSubview(self.valueLabel)
        self.valueLabel.snp.makeConstraints { make in
            make.left.equalTo(self.typeLabel.snp.left).offset(96)
            make.right.equalToSuperview().offset(-24)
            make.top.bottom.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(68)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
