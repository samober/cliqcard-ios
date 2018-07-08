//
//  ContactsController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class ContactsController: UITableViewController {
    
    var contacts: [CCContact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.lightestGray

        self.tableView.register(ContactCell.self, forCellReuseIdentifier: "ContactCell")
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.title = "Contacts"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
        self.loadContacts()
    }

    func loadContacts() {
        CliqCardAPI.shared.getContacts { (contacts, error) in
            if error != nil {
                self.showError(title: "Error", message: "Unable to load contacts at this time. Please try again later.")
            } else if let contacts = contacts {
                self.contacts = contacts
                self.tableView.reloadData()
            }
            
            // stop refreshing
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func refresh() {
        self.loadContacts()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell

        let contact = self.contacts[indexPath.row]
        if let profilePicture = contact.profilePicture {
            cell.profileImageView.kf.setImage(with: profilePicture.thumbSmall)
        } else {
            cell.profileImageView.image = UIImage(named: "DefaultUserProfile")
        }
        cell.nameLabel.text = contact.fullName

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // get the contact
        let contact = self.contacts[indexPath.row]
        // create a contact controller
        let controller = ContactController(contact: contact)
        // push the controller
        self.navigationController?.pushViewController(controller, animated: true)
    }

}