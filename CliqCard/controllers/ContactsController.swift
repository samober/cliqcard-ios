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
import SwiftIcons

class ContactsController: UITableViewController, UIViewControllerTransitioningDelegate {
    
    var contacts: [CCContact] = []
    
    var homeController: HomeController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        self.tableView.register(ContactCell.self, forCellReuseIdentifier: "ContactCell")
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let groupsButton = UIBarButtonItem()
        groupsButton.setIcon(icon: .icofont(.arrowRight), iconSize: 28, color: Colors.darkGray, cgRect: CGRect(x: 0, y: 0, width: 24, height: 24), target: self, action: #selector(showGroups))
        self.navigationItem.rightBarButtonItem = groupsButton
        
        self.title = "Contacts"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
        self.loadContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func showGroups() {
        self.homeController.showGroupsFromContacts()
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
        
        if contact.phones.count > 0 {
            cell.detailLabel.text = contact.phones[0].number
        } else if contact.emails.count > 0 {
            cell.detailLabel.text = contact.emails[0].address
        } else {
            cell.detailLabel.text = "Contact"
        }
        
        cell.isTopSeparatorHidden = indexPath.row == 0
        cell.isBottomSeparatorHidden = indexPath.row == self.contacts.count - 1

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // get the contact
        let contact = self.contacts[indexPath.row]
        // create a contact controller
        let controller = ContactController(contact: contact)
        let navigationController = SJONavigationController(rootViewController: controller)
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverPresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverDismissAnimator()
    }

}
