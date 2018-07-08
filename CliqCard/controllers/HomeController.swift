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
import Kingfisher

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
            make.width.height.equalTo(32)
        })
        
        return view
    }()
    
    lazy var tableView: UITableView! = {
        let view = UITableView()
        view.backgroundColor = Colors.lightestGray
        view.separatorStyle = .none
        view.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
        
        return view
    }()
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register for model update notifications
        NotificationCenter.default.addObserver(self, selector: #selector(modelDidUpdate(notification:)), name: Notification.Name(rawValue: kPlankDidInitializeNotification), object: nil)
        
        self.view.backgroundColor = Colors.lightestGray
        
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
        if let currentUser = CliqCardAPI.shared.currentUser, let profilePicture = currentUser.profilePicture {
            self.profileButton.kf.setImage(with: profilePicture.thumbSmall, for: .normal)
        } else {
            self.profileButton.setImage(UIImage(named: "DefaultUserProfile"), for: .normal)
        }
        // hook up the profile button to open the profile page
        self.profileButton.addTarget(self, action: #selector(viewProfile), for: .touchUpInside)
        // wrap it in a bar button item
        let profileBarButton = UIBarButtonItem(customView: self.profileButton)
        // assign it the right spot
        self.navigationItem.rightBarButtonItem = profileBarButton
        
        // setup a refresh control
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        // hook up the table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // position the table view
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

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
            self.refreshControl.endRefreshing()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        
        let group = self.groups[indexPath.row]
        if let picture = group.picture {
            cell.groupImageView.kf.setImage(with: picture.thumbBig)
        } else {
            cell.groupImageView.image = UIImage(named: "DefaultGroupProfile")
        }
        cell.nameLabel.text = group.name
        cell.membersLabel.text = "\(group.memberCount) member\(group.memberCount == 1 ? "" : "s")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // get the group
        let group = self.groups[indexPath.row]
        // create a new group controller
        let controller = GroupController(group: group)
        // push the controller
        self.navigationController?.pushViewController(controller, animated: true)
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
    
    @objc func modelDidUpdate(notification: Notification) {
        // check for new group
        if let newGroup = notification.object as? CCGroup {
            let index = self.groups.index { group -> Bool in
                return newGroup.identifier == group.identifier
            }
            if let index = index {
                self.groups.remove(at: index)
                self.groups.insert(newGroup, at: index)
                self.tableView.reloadData()
            }
        }
        // check for new account
        else if let newAccount = notification.object as? CCAccount {
            // load the user image for the profile button
            if let profilePicture = newAccount.profilePicture {
                self.profileButton.kf.setImage(with: profilePicture.thumbSmall, for: .normal)
            } else {
                self.profileButton.setImage(UIImage(named: "DefaultUserProfile"), for: .normal)
            }
        }
    }
    
    deinit {
        // remove observer
        NotificationCenter.default.removeObserver(self)
    }

}
