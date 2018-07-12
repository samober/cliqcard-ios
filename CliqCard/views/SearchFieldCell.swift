//
//  SearchFieldCell.swift
//  CliqCard
//
//  Created by Sam Ober on 7/12/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import SwiftIcons

class SearchFieldCell: SeparatorCell {
    
    lazy var searchField: SJOTextField! = {
        let view = SJOTextField()
        view.borderStyle = .none
        view.font = UIFont(name: "Lato-Regular", size: 18)
        view.textColor = Colors.darkestGray
        view.placeholder = "Search..."
        view.placeholderColor = Colors.gray
        view.returnKeyType = .search
        view.enablesReturnKeyAutomatically = true
        view.autocorrectionType = .no
        view.autocapitalizationType = .words
        view.setLeftViewIcon(icon: .fontAwesome(.search), leftViewMode: .always, textColor: Colors.gray, backgroundColor: .clear, size: nil)
        view.clearButtonMode = .whileEditing
        
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        
        self.addSubview(self.searchField)
        self.searchField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
