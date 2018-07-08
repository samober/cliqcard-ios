//
//  ContactController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SimpleImageViewer

class ContactController: UITableViewController {
    
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
        
        self.title = self.contact.fullName
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc func refresh() {
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // header cell, personal header, 3 personal items, work header, 2 work items, end buffer
        return 9
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
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
        case 1:
            // header for personal card
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubHeaderCell", for: indexPath) as! SubHeaderCell
            cell.label.text = "Personal Card"
            cell.isHidden = self.contact.personalCard == nil
            return cell
        case 2:
            // personal cell phone
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = "Mobile"
            cell.isHidden = true
            if let personalCard = self.contact.personalCard {
                cell.valueLabel.text = Utils.formatPhoneNumber(phoneNumber: personalCard.cellPhone)
                cell.isHidden = personalCard.cellPhone == nil
                cell.valueLabel.isHidden = cell.valueLabel.text == nil
                cell.placeholderLabel.isHidden = cell.valueLabel.text != nil
            }
            return cell
        case 3:
            // personal home phone
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = "Home"
            cell.isHidden = true
            if let personalCard = self.contact.personalCard {
                cell.valueLabel.text = Utils.formatPhoneNumber(phoneNumber: personalCard.homePhone)
                cell.isHidden = personalCard.homePhone == nil
                cell.valueLabel.isHidden = cell.valueLabel.text == nil
                cell.placeholderLabel.isHidden = cell.valueLabel.text != nil
            }
            return cell
        case 4:
            // personal email
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = "Email"
            cell.isHidden = true
            if let personalCard = self.contact.personalCard {
                cell.valueLabel.text = personalCard.email
                cell.isHidden = personalCard.email == nil
                cell.valueLabel.isHidden = cell.valueLabel.text == nil
                cell.placeholderLabel.isHidden = cell.valueLabel.text != nil
            }
            return cell
        case 5:
            // header for work card
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubHeaderCell", for: indexPath) as! SubHeaderCell
            cell.label.text = "Work Card"
            cell.isHidden = self.contact.workCard == nil
            return cell
        case 6:
            // work office phone
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = "Office"
            cell.isHidden = true
            if let workCard = self.contact.workCard {
                cell.valueLabel.text = Utils.formatPhoneNumber(phoneNumber: workCard.officePhone)
                cell.isHidden = workCard.officePhone == nil
                cell.valueLabel.isHidden = cell.valueLabel.text == nil
                cell.placeholderLabel.isHidden = cell.valueLabel.text != nil
            }
            return cell
        case 7:
            // work email
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = "Email"
            cell.isHidden = true
            if let workCard = self.contact.workCard {
                cell.valueLabel.text = workCard.email
                cell.isHidden = workCard.email == nil
                cell.valueLabel.isHidden = cell.valueLabel.text == nil
                cell.placeholderLabel.isHidden = cell.valueLabel.text != nil
            }
            return cell
        default:
            // buffer cell
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 284
        case 1:
            return self.contact.personalCard != nil ? 72 : 0
        case 2:
            guard let personalCard = self.contact.personalCard else { return 0 }
            return personalCard.cellPhone != nil ? 48 : 0
        case 3:
            guard let personalCard = self.contact.personalCard else { return 0 }
            return personalCard.homePhone != nil ? 48 : 0
        case 4:
            guard let personalCard = self.contact.personalCard else { return 0 }
            return personalCard.email != nil ? 48 : 0
        case 5:
            return self.contact.workCard != nil ? 72 : 0
        case 6:
            guard let workCard = self.contact.workCard else { return 0 }
            return workCard.officePhone != nil ? 48 : 0
        case 7:
            guard let workCard = self.contact.workCard else { return 0 }
            return workCard.email != nil ? 48 : 0
        default:
            return 64
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func openImage(sender: UIButton) {
        let configuration = ImageViewerConfiguration { config in
            config.imageView = sender.imageView
        }
        
        let controller = ImageViewerController(configuration: configuration)
        self.present(controller, animated: true, completion: nil)
    }

}
