//
//  HomeController.swift
//  CliqCard
//
//  Created by Sam Ober on 6/14/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class HomeController: UIViewController {
    
    lazy var welcomeLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 20)
        view.textAlignment = .center
        view.numberOfLines = 0
        
        return view
    }()
    
    lazy var logoutButton: UIButton! = {
        let view = UIButton(type: .custom)
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 4
        view.setTitle("Logout", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.text = "Welcome \(CliqCardAPI.shared.currentUser!.firstName)!"

        self.view.addSubview(welcomeLabel)
        self.view.addSubview(logoutButton)
        
        welcomeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(64)
            make.right.equalToSuperview().offset(-64)
            make.centerY.equalToSuperview().offset(-120)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(32)
        }
        
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
//        self.loadGroups()
        self.loadContacts()
    }

    @objc func logout() {
        CliqCardAPI.shared.logout()
    }
    
    func loadGroups() {
        CliqCardAPI.shared.getGroups { (groups, error) in
            if let groups = groups {
                for group in groups {
                    print(group.createdAt)
                }
            } else if let error = error {
                print(error)
            }
        }
    }
    
    func loadContacts() {
        CliqCardAPI.shared.getContacts { (contacts, error) in
            if let contacts = contacts {
                for contact in contacts {
                    print(contact.fullName)
                }
            } else if let error = error {
                print(error)
            }
        }
    }

}
