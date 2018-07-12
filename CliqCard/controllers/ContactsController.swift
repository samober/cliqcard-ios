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

class ContactsController: UITableViewController, UIViewControllerTransitioningDelegate, UITextFieldDelegate {
    
    var contacts: [CCContact] = []
    
    var homeController: HomeController!
    
    lazy var searchCell: SearchFieldCell! = {
        let view = SearchFieldCell()
        view.isTopSeparatorHidden = true
        view.isBottomSeparatorHidden = false
        
        return view
    }()
    
    var searchQuery: String = ""
    var searchResults: [CCContact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        self.tableView.register(ContactCell.self, forCellReuseIdentifier: "ContactCell")
        self.tableView.register(SearchFieldCell.self, forCellReuseIdentifier: "SearchFieldCell")
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let groupsButton = UIBarButtonItem()
        groupsButton.setIcon(icon: .icofont(.arrowRight), iconSize: 28, color: Colors.darkGray, cgRect: CGRect(x: 0, y: 0, width: 24, height: 24), target: self, action: #selector(showGroups))
        self.navigationItem.rightBarButtonItem = groupsButton
        
        self.title = "Contacts"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
        self.searchCell.searchField.addTarget(self, action: #selector(textFieldUpdated(textField:)), for: .editingChanged)
        self.searchCell.searchField.delegate = self
        
        self.loadContacts()
    }
    
    @objc func showGroups() {
        self.view.endEditing(true)
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if self.searchQuery.count > 0 {
            return self.searchResults.count
        }
        return self.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return self.searchCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell

        let contact = self.searchQuery.count > 0 ? self.searchResults[indexPath.row] : self.contacts[indexPath.row]
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
        
        cell.isTopSeparatorHidden = false
        cell.isBottomSeparatorHidden = indexPath.row == self.contacts.count

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 64
        }
        return 88
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            // get the contact
            let contact = self.searchQuery.count > 0 ? self.searchResults[indexPath.row] : self.contacts[indexPath.row]
            // create a contact controller
            let controller = ContactController(contact: contact)
            let navigationController = SJONavigationController(rootViewController: controller)
            navigationController.transitioningDelegate = self
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverPresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverDismissAnimator()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @objc func textFieldUpdated(textField: UITextField) {
        if let text = textField.text, text.count > 0 {
            self.searchQuery = text
            self.search()
        } else {
            self.searchQuery = ""
            self.tableView.reloadSections(IndexSet(integer: 1), with: UITableViewRowAnimation.none)
        }
    }
    
    func search() {
        let query = self.searchQuery
        self.searchResults = self.contacts.filter({ contact -> Bool in
            return contact.fullName.lowercased().contains(query.lowercased())
        })
        self.tableView.reloadSections(IndexSet(integer: 1), with: UITableViewRowAnimation.none)
    }

}
