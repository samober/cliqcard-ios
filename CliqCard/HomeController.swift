//
//  HomeController.swift
//  CliqCard
//
//  Created by Sam Ober on 6/14/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import SwiftIcons

class HomeController: UITableViewController {
    
    var groups: [CCGroup] = []
    
    lazy var profileButton: UIButton! = {
        let view = UIButton(type: UIButtonType.custom)
        view.backgroundColor = Colors.lightGray
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.layer.borderColor = Colors.lightGray.cgColor
        view.layer.borderWidth = 1.0
        view.imageView?.contentMode = .scaleAspectFill
        view.snp.makeConstraints({ make in
            make.width.height.equalTo(30)
        })
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.lightestGray
        
        // register custom cells for this view
        self.tableView.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
        // remove default separators
        self.tableView.separatorStyle = .none
        
        self.title = "CliqCard"
        
        // remove back button titles
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // create an empty bar button item for contacts
        let contactsButton = UIBarButtonItem()
        // set the icon and add a target to open up the contacts view
        contactsButton.setIcon(icon: .fontAwesome(.listUl), iconSize: 24, color: Colors.darkGray, cgRect: CGRect(x: 0, y: 2, width: 24, height: 24), target: self, action: #selector(viewContacts))
        // add it the left
        self.navigationItem.leftBarButtonItem = contactsButton
        
        // load the user image for the profile button
        self.profileButton.setImage(UIImage(named: "DefaultUserProfile"), for: .normal)
        // hook up the profile button to open the profile page
        self.profileButton.addTarget(self, action: #selector(viewProfile), for: .touchUpInside)
        // wrap it in a bar button item
        let profileBarButton = UIBarButtonItem(customView: self.profileButton)
        // assign it the right spot
        self.navigationItem.rightBarButtonItem = profileBarButton
        
        // setup a refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl

        self.loadGroups()
    }
    
    func loadGroups() {
        CliqCardAPI.shared.getGroups { (groups, error) in
            if error != nil {
                self.showError(title: "Error", message: "Unable to load groups at this time. Please try again later.")
            } else if let groups = groups {
                self.groups = groups
                self.tableView.reloadData()
            }
            
            // stop refreshing
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        
        let group = self.groups[indexPath.row]
        cell.nameLabel.text = group.name
        cell.membersLabel.text = "\(group.memberCount) member\(group.memberCount == 1 ? "" : "s")"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func refresh() {
        self.loadGroups()
    }
    
    @objc func viewContacts() {
        // create a new contacts controller
        let controller = ContactsController()
        // push
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func viewProfile() {
        // create a new profile controller
        let controller = ProfileController()
        // push
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
