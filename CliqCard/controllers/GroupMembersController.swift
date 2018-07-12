//
//  GroupMembersController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import Kingfisher

class GroupMembersController: UITableViewController {
    
    var group: CCGroup
    var members: [CCContact] = []
    
    init(group: CCGroup) {
        // save the group
        self.group = group
        // initialize
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.tableView.register(ContactCell.self, forCellReuseIdentifier: "ContactCell")
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let closeButton = UIBarButtonItem()
        closeButton.setIcon(icon: .fontAwesome(.times), iconSize: 24, color: Colors.darkGray, cgRect: .zero, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = closeButton
        
        self.title = "\(self.group.name) Members"
        
        // setup the refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
        // load the members
        self.loadMembers()
    }
    
    func loadMembers() {
        CliqCardAPI.shared.getGroupMembers(id: self.group.identifier) { (members, error) in
            if error != nil {
                self.showError(title: "Error", message: "Unable to load members at this time. Please try again later.")
            } else if let members = members {
                self.members = members
                self.tableView.reloadData()
            }
            
            // stop refreshing
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refresh() {
        self.loadMembers()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        
        let member = self.members[indexPath.row]
        
        if let profilePicture = member.profilePicture {
            cell.profileImageView.kf.setImage(with: profilePicture.thumbSmall)
        } else {
            cell.profileImageView.image = UIImage(named: "DefaultUserProfile")
        }
        cell.nameLabel.text = member.fullName
        
        if member.phones.count > 0 {
            cell.detailLabel.text = member.phones[0].number
        } else if member.emails.count > 0 {
            cell.detailLabel.text = member.emails[0].address
        } else {
            cell.detailLabel.text = "Contact"
        }
        
        cell.isTopSeparatorHidden = indexPath.row == 0
        cell.isBottomSeparatorHidden = indexPath.row == self.members.count - 1
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // get the contact
        let contact = self.members[indexPath.row]
        // create a contact controller
        let controller = ContactController(contact: contact)
        // push the controller
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
