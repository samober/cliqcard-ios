//
//  SeparatorCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit

class SeparatorCell: UITableViewCell {
    
    var isTopSeparatorHidden: Bool {
        didSet {
            self.topSeparator.isHidden = self.isTopSeparatorHidden
        }
    }
    
    var isBottomSeparatorHidden: Bool {
        didSet {
            self.bottomSeparator.isHidden = self.isBottomSeparatorHidden
        }
    }
    
    private lazy var topSeparator: UIView! = {
        let view = UIView()
        view.backgroundColor = Colors.lightestGray
        view.layer.zPosition = 1
        
        return view
    }()
    
    private lazy var bottomSeparator: UIView! = {
        let view = UIView()
        view.backgroundColor = Colors.lightestGray
        view.layer.zPosition = 1
        
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.isTopSeparatorHidden = false
        self.isBottomSeparatorHidden = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(topSeparator)
        topSeparator.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(0.5)
        }
        
        self.addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(0.5)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = self.topSeparator.backgroundColor
        super.setSelected(selected, animated: animated)
        self.topSeparator.backgroundColor = color
        self.bottomSeparator.backgroundColor = color
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = self.topSeparator.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        self.topSeparator.backgroundColor = color
        self.bottomSeparator.backgroundColor = color
    }
    
}
