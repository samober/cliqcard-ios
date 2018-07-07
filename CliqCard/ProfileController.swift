//
//  ProfileController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import PhoneNumberKit
import SwiftIcons
import SimpleImageViewer

class ProfileController: UITableViewController, UITextFieldDelegate {
    
    var account: CCAccount?
    
    // mutable builder versions
    var personalCardBuilder: CCPersonalCardBuilder!
    var workCardBuilder: CCWorkCardBuilder!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.lightestGray
        
        self.tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: "ProfileHeaderCell")
        self.tableView.register(SubHeaderCell.self, forCellReuseIdentifier: "SubHeaderCell")
        self.tableView.register(InlineDataCell.self, forCellReuseIdentifier: "InlineDataCell")
        
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        self.title = "Profile"
        
        let settingsButton = UIBarButtonItem()
        settingsButton.setIcon(icon: .fontAwesome(.cog), iconSize: 24, color: Colors.darkGray, cgRect: CGRect(x: 0, y: 4, width: 24, height: 24), target: self, action: #selector(openSettings))
        self.navigationItem.rightBarButtonItem = settingsButton
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
        self.loadAccount()
    }
    
    func loadAccount() {
        CliqCardAPI.shared.getAccount { (account, error) in
            if error != nil {
                self.showError(title: "Error", message: "Unable to load account at this moment. Please try again later.")
                self.refreshControl?.endRefreshing()
            } else if let account = account {
                // set the account
                self.account = account
                // load up the cards
                CliqCardAPI.shared.getCards(responseHandler: { (personalCard, workCard, error) in
                    if let personalCard = personalCard, let workCard = workCard {
                        // set personal and work cards
                        self.personalCardBuilder = CCPersonalCardBuilder.init(model: personalCard)
                        self.workCardBuilder = CCWorkCardBuilder.init(model: workCard)
                        // reload the table view
                        self.tableView.reloadData()
                    } else {
                        self.showError(title: "Error", message: "Unable to load account at this moment. Please try again later.")
                    }
                    
                    self.refreshControl?.endRefreshing()
                })
            }
        }
    }
    
    @objc func refresh() {
        self.loadAccount()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.account != nil ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // return the header cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            cell.nameLabel.text = self.account?.fullName
            cell.profileImageButton.setImage(UIImage(named: "DefaultUserProfile"), for: .normal)
            cell.profileImageButton.addTarget(self, action: #selector(openImage(sender:)), for: .touchUpInside)
            return cell
        }
        
        if indexPath.row == 1 || indexPath.row == 5 {
            // return a subheader cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubHeaderCell", for: indexPath) as! SubHeaderCell
            switch indexPath.row {
            case 1:
                cell.label.text = "Personal Card"
            case 5:
                cell.label.text = "Work Card"
            default:
                break
            }
            return cell
        }
        
        // return an information editing cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
        switch indexPath.row {
        case 2:
            cell.key = "Mobile"
            cell.value = self.formatPhoneNumber(phoneNumber: self.personalCardBuilder.cellPhone)
            cell.placeholder = "Phone"
        case 3:
            cell.key = "Home"
            cell.value = self.formatPhoneNumber(phoneNumber: self.personalCardBuilder.homePhone)
            cell.placeholder = "Phone"
        case 4:
            cell.key = "Email"
            cell.value = self.personalCardBuilder.email
            cell.placeholder = "Email"
        case 6:
            cell.key = "Office"
            cell.value = self.formatPhoneNumber(phoneNumber: self.workCardBuilder.officePhone)
            cell.placeholder = "Phone"
        case 7:
            cell.key = "Email"
            cell.value = self.workCardBuilder.email
            cell.placeholder = "Email"
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 228
        }
        
        if indexPath.row == 1 || indexPath.row == 5 {
            return 72
        }
        
        return 48
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 2:
            let controller = EditPhoneNumberController(e164PhoneNumber: self.personalCardBuilder.cellPhone) { phoneNumber in
                self.personalCardBuilder.cellPhone = phoneNumber
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(controller, animated: true)
        case 3:
            let controller = EditPhoneNumberController(e164PhoneNumber: self.personalCardBuilder.homePhone) { phoneNumber in
                self.personalCardBuilder.homePhone = phoneNumber
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(controller, animated: true)
        case 4:
            let controller = EditEmailController(email: self.personalCardBuilder.email) { email in
                self.personalCardBuilder.email = email
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(controller, animated: true)
        case 6:
            let controller = EditPhoneNumberController(e164PhoneNumber: self.workCardBuilder.officePhone) { phoneNumber in
                self.workCardBuilder.officePhone = phoneNumber
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(controller, animated: true)
        case 7:
            let controller = EditEmailController(email: self.workCardBuilder.email) { email in
                self.workCardBuilder.email = email
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }
    
    func formatPhoneNumber(phoneNumber: String?) -> String? {
        if let phoneNumber = phoneNumber {
            let phoneNumberKit = PhoneNumberKit()
            if let parsedPhoneNumber = try? phoneNumberKit.parse(phoneNumber) {
                return phoneNumberKit.format(parsedPhoneNumber, toType: PhoneNumberFormat.international)
            }
        }
        return nil
    }
    
    @objc func openImage(sender: UIButton) {
        let configuration = ImageViewerConfiguration { config in
            config.imageView = sender.imageView
        }
        
        let controller = ImageViewerController(configuration: configuration)
        self.present(controller, animated: true, completion: nil)
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            // we are popping the view controller - time to save changes
            
            // build the new cards
            let personalCard = self.personalCardBuilder.build()
            let workCard = self.workCardBuilder.build()
            
            // send the personal card to the server
            CliqCardAPI.shared.updatePersonalCard(personalCard: personalCard) { (personalCard, error) in
                if error == nil {
                    // send the work card to the server
                    CliqCardAPI.shared.updateWorkCard(workCard: workCard, responseHandler: { (workCard, error) in
                        if error == nil {
                            super.willMove(toParentViewController: parent)
                        } else {
                            // show an error message
                            self.showError(title: "Error", message: "Could not save the changes to your profile. Please try again later.") { () -> Void in
                                super.willMove(toParentViewController: parent)
                            }
                        }
                    })
                } else {
                    // show an error message
                    self.showError(title: "Error", message: "Could not save the changes to your profile. Please try again later.") { () -> Void in
                        super.willMove(toParentViewController: parent)
                    }
                }
            }
        } else {
            super.willMove(toParentViewController: parent)
        }
    }
    
    @objc func openSettings() {
        
    }

}
