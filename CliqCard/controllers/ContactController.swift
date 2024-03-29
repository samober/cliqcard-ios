//
//  ContactController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SimpleImageViewer
import MessageUI

class ContactController: UITableViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    var contact: CCContact
    
    init(contact: CCContact) {
        // save the contact
        self.contact = contact
        // initialize
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Colors.lightestGray
        
        self.tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: "ProfileHeaderCell")
        self.tableView.register(SubHeaderCell.self, forCellReuseIdentifier: "SubHeaderCell")
        self.tableView.register(InlineDataCell.self, forCellReuseIdentifier: "InlineDataCell")
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let closeButton = UIBarButtonItem()
        closeButton.setIcon(icon: .fontAwesome(.times), iconSize: 24, color: Colors.darkGray, cgRect: .zero, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = closeButton
        
        self.title = "Contact"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refresh() {
        CliqCardAPI.shared.getContact(id: self.contact.identifier) { (contact, error) in
            if let contact = contact {
                self.contact = contact
                self.tableView.reloadData()
            } else {
                self.showError(title: "Error", message: "Could not load this contact at this time. Please try again later.")
            }
            
            self.refreshControl?.endRefreshing()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // header cell, phones header, phone count, emails header, email count, end buffer
        return 4 + self.contact.phones.count + self.contact.emails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // profile header
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            if let profilePicture = self.contact.profilePicture {
                cell.profileImageButton.kf.setImage(with: profilePicture.original, for: .normal)
                cell.profileImageButton.addTarget(self, action: #selector(openImage(sender:)), for: .touchUpInside)
            } else {
                cell.profileImageButton.setImage(UIImage(named: "DefaultUserProfile"), for: .normal)
                cell.profileImageButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            }
            cell.nameLabel.text = self.contact.fullName
            return cell
        }
        
        if indexPath.row == 1 {
            // header for phones
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubHeaderCell", for: indexPath) as! SubHeaderCell
            cell.label.text = "PHONES"
            cell.isHidden = self.contact.phones.count == 0
            return cell
        }
        
        if indexPath.row < 2 + self.contact.phones.count {
            // phone
            let phone = self.contact.phones[indexPath.row - 2]
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = phone.type.capitalized
            cell.valueLabel.text = Utils.formatPhoneNumber(phoneNumber: phone.number)
            cell.isTopSeparatorHidden = indexPath.row == 2
            cell.isBottomSeparatorHidden = indexPath.row == 1 + self.contact.phones.count
            return cell
        }
        
        if indexPath.row == 2 + self.contact.phones.count {
            // header for emails
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubHeaderCell", for: indexPath) as! SubHeaderCell
            cell.label.text = "EMAILS"
            cell.isHidden = self.contact.emails.count == 0
            return cell
        }
        
        if indexPath.row < 3 + self.contact.phones.count + self.contact.emails.count {
            // email
            let email = self.contact.emails[indexPath.row - 3 - self.contact.phones.count]
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = email.type.capitalized
            cell.valueLabel.text = email.address
            cell.isTopSeparatorHidden = indexPath.row == 3 + self.contact.phones.count
            cell.isBottomSeparatorHidden = indexPath.row == 2 + self.contact.phones.count + self.contact.emails.count
            return cell
        }
        
        // buffer cell
        return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            // profile header cell
            return 192
        }
        
        if indexPath.row == 1 {
            // header for phones
            return self.contact.phones.count == 0 ? 0 : 72
        }
        
        if indexPath.row < 2 + self.contact.phones.count {
            // phone
            return 68
        }
        
        if indexPath.row == 2 + self.contact.phones.count {
            // header for emails
            return self.contact.emails.count == 0 ? 0 : 72
        }
        
        if indexPath.row < 3 + self.contact.phones.count + self.contact.emails.count {
            // email
            return 68
        }
        
        // buffer cell
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < 2 {
            return
        }
        
        if indexPath.row < 2 + self.contact.phones.count {
            let phone = self.contact.phones[indexPath.row - 2]
            // call
            guard let number = URL(string: "tel://\(phone.number)") else { return }
            UIApplication.shared.open(number)
            return
        }
        
        if indexPath.row < 3 + self.contact.phones.count {
            return
        }
        
        if indexPath.row < 3 + self.contact.phones.count + self.contact.emails.count {
            let email = self.contact.emails[indexPath.row - 3 - self.contact.phones.count]
            if !MFMailComposeViewController.canSendMail() {
                self.showError(title: "Not Logged In", message: "Log into the Mail app on your phone to send emails.")
            } else {
                let composeController = MFMailComposeViewController()
                composeController.mailComposeDelegate = self
                composeController.setToRecipients([email.address])
                self.present(composeController, animated: true, completion: nil)
            }
            return
        }
    }
    
    @objc func openImage(sender: UIButton) {
        let configuration = ImageViewerConfiguration { config in
            config.imageView = sender.imageView
        }
        
        let controller = ImageViewerController(configuration: configuration)
        self.present(controller, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }

}
