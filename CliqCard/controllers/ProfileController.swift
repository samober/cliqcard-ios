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
import Kingfisher

class ProfileController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var loading: Bool = true
    
    var account: CCAccount!
    var personalCard: CCPersonalCard!
    var workCard: CCWorkCard!
    
    // mutable builder versions
    var accountBuilder: CCAccountBuilder!
    var personalCardBuilder: CCPersonalCardBuilder!
    var workCardBuilder: CCWorkCardBuilder!
    
    // image picker
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.lightestGray
        
        self.tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: "ProfileHeaderCell")
        self.tableView.register(SubHeaderCell.self, forCellReuseIdentifier: "SubHeaderCell")
        self.tableView.register(InlineDataCell.self, forCellReuseIdentifier: "InlineDataCell")
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        self.title = "Profile"
        
        let settingsButton = UIBarButtonItem()
        settingsButton.setIcon(icon: .fontAwesome(.cog), iconSize: 24, color: Colors.darkGray, cgRect: CGRect(x: 0, y: 4, width: 24, height: 24), target: self, action: #selector(openSettings))
        self.navigationItem.rightBarButtonItem = settingsButton
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
        self.imagePicker.delegate = self
        
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
                self.accountBuilder = CCAccountBuilder.init(model: account)
                // load up the cards
                CliqCardAPI.shared.getCards(responseHandler: { (personalCard, workCard, error) in
                    if let personalCard = personalCard, let workCard = workCard {
                        // set personal and work cards
                        self.personalCard = personalCard
                        self.personalCardBuilder = CCPersonalCardBuilder.init(model: personalCard)
                        self.workCard = workCard
                        self.workCardBuilder = CCWorkCardBuilder.init(model: workCard)
                        // set loading to false
                        self.loading = false
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
        return self.loading ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // return the header cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            cell.nameLabel.text = self.account.fullName
            if let profilePicture = self.account.profilePicture {
                cell.profileImageButton.kf.setImage(with: profilePicture.original, for: .normal)
            } else {
                cell.profileImageButton.setImage(UIImage(named: "DefaultUserProfile"), for: .normal)
            }
            cell.profileImageButton.addTarget(self, action: #selector(openImage(sender:)), for: .touchUpInside)
            return cell
        }
        
        if indexPath.row == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            return cell
        }
        
        if indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 8 {
            // return a subheader cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubHeaderCell", for: indexPath) as! SubHeaderCell
            switch indexPath.row {
            case 1:
                cell.label.text = "Account"
            case 4:
                cell.label.text = "Personal Card"
            case 8:
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
            cell.keyLabel.text = "First name"
            cell.valueLabel.text = self.account.firstName
            cell.valueLabel.isHidden = false
            cell.placeholderLabel.text = "First name"
            cell.placeholderLabel.isHidden = true
        case 3:
            cell.keyLabel.text = "Last name"
            cell.valueLabel.text = self.account.lastName
            cell.valueLabel.isHidden = false
            cell.placeholderLabel.text = "Last name"
            cell.placeholderLabel.isHidden = true
        case 5:
            cell.keyLabel.text = "Mobile"
            cell.valueLabel.text = Utils.formatPhoneNumber(phoneNumber: self.personalCard.cellPhone)
            cell.valueLabel.isHidden = self.personalCard.cellPhone == nil || self.personalCard.cellPhone!.count == 0
            cell.placeholderLabel.text = "Phone"
            cell.placeholderLabel.isHidden = self.personalCard.cellPhone != nil && self.personalCard.cellPhone!.count > 0
        case 6:
            cell.keyLabel.text = "Home"
            cell.valueLabel.text = Utils.formatPhoneNumber(phoneNumber: self.personalCard.homePhone)
            cell.valueLabel.isHidden = self.personalCard.homePhone == nil || self.personalCard.homePhone!.count == 0
            cell.placeholderLabel.text = "Phone"
            cell.placeholderLabel.isHidden = self.personalCard.homePhone != nil && self.personalCard.homePhone!.count > 0
        case 7:
            cell.keyLabel.text = "Email"
            cell.valueLabel.text = self.personalCard.email
            cell.valueLabel.isHidden = self.personalCard.email == nil || self.personalCard.email!.count == 0
            cell.placeholderLabel.text = "Email"
            cell.placeholderLabel.isHidden = self.personalCard.email != nil && self.personalCard.email!.count > 0
        case 9:
            cell.keyLabel.text = "Office"
            cell.valueLabel.text = Utils.formatPhoneNumber(phoneNumber: self.workCard.officePhone)
            cell.valueLabel.isHidden = self.workCard.officePhone == nil || self.workCard.officePhone!.count == 0
            cell.placeholderLabel.text = "Phone"
            cell.placeholderLabel.isHidden = self.workCard.officePhone != nil && self.workCard.officePhone!.count > 0
        case 10:
            cell.keyLabel.text = "Email"
            cell.valueLabel.text = self.workCard.email
            cell.valueLabel.isHidden = self.workCard.email == nil || self.workCard.email!.count == 0
            cell.placeholderLabel.text = "Email"
            cell.placeholderLabel.isHidden = self.workCard.email != nil && self.workCard.email!.count > 0
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 284
        }
        
        if indexPath.row == 11 {
            return 64
        }
        
        if indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 8 {
            return 72
        }
        
        return 48
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 2:
            let controller = EditNameController(name: self.account.firstName, placeholder: "First Name") { firstName in
                self.accountBuilder.firstName = firstName
                self.accountBuilder.fullName = "\(firstName) \(self.account.lastName)"
                // save
                self.save() { error -> Void in
                    if error != nil {
                        self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                        self.accountBuilder = CCAccountBuilder.init(model: self.account)
                    }
                    self.navigationController?.popViewController(animated: true)
                    self.tableView.reloadData()
                }
            }
            self.navigationController?.pushViewController(controller, animated: true)
        case 3:
            let controller = EditNameController(name: self.account.lastName, placeholder: "Last Name") { lastName in
                self.accountBuilder.lastName = lastName
                self.accountBuilder.fullName = "\(self.account.firstName) \(lastName)"
                // save
                self.save() { error -> Void in
                    if error != nil {
                        self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                        self.accountBuilder = CCAccountBuilder.init(model: self.account)
                    }
                    self.navigationController?.popViewController(animated: true)
                    self.tableView.reloadData()
                }
            }
            self.navigationController?.pushViewController(controller, animated: true)
        case 5:
            let controller = EditPhoneNumberController(e164PhoneNumber: self.personalCard.cellPhone) { phoneNumber in
                self.personalCardBuilder.cellPhone = phoneNumber
                // save
                self.save() { error -> Void in
                    if error != nil {
                        self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                        self.personalCardBuilder = CCPersonalCardBuilder.init(model: self.personalCard)
                    }
                    self.navigationController?.popViewController(animated: true)
                    self.tableView.reloadData()
                }
            }
            self.navigationController?.pushViewController(controller, animated: true)
        case 6:
            let controller = EditPhoneNumberController(e164PhoneNumber: self.personalCard.homePhone) { phoneNumber in
                self.personalCardBuilder.homePhone = phoneNumber
                // save
                self.save() { error -> Void in
                    if error != nil {
                        self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                        self.personalCardBuilder = CCPersonalCardBuilder.init(model: self.personalCard)
                    }
                    self.navigationController?.popViewController(animated: true)
                    self.tableView.reloadData()
                }
            }
            self.navigationController?.pushViewController(controller, animated: true)
        case 7:
            let controller = EditEmailController(email: self.personalCard.email) { email in
                self.personalCardBuilder.email = email
                // save
                self.save() { error -> Void in
                    if error != nil {
                        self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                        self.personalCardBuilder = CCPersonalCardBuilder.init(model: self.personalCard)
                    }
                    self.navigationController?.popViewController(animated: true)
                    self.tableView.reloadData()
                }
            }
            self.navigationController?.pushViewController(controller, animated: true)
        case 9:
            let controller = EditPhoneNumberController(e164PhoneNumber: self.workCard.officePhone) { phoneNumber in
                self.workCardBuilder.officePhone = phoneNumber
                // save
                self.save() { error -> Void in
                    if error != nil {
                        self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                        self.workCardBuilder = CCWorkCardBuilder.init(model: self.workCard)
                    }
                    self.navigationController?.popViewController(animated: true)
                    self.tableView.reloadData()
                }
            }
            self.navigationController?.pushViewController(controller, animated: true)
        case 10:
            let controller = EditEmailController(email: self.workCard.email) { email in
                self.workCardBuilder.email = email
                // save
                self.save() { error -> Void in
                    if error != nil {
                        self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                        self.workCardBuilder = CCWorkCardBuilder.init(model: self.workCard)
                    }
                    self.navigationController?.popViewController(animated: true)
                    self.tableView.reloadData()
                }
            }
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }
    
    @objc func openImage(sender: UIButton) {
        // create a prompt asking for camera, photo library, view image, or remove image
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            // take a new image with the camera
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        controller.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            // choose an image from the photo library
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        // only add view and remove if there is an image
        if self.account.profilePicture != nil {
            controller.addAction(UIAlertAction(title: "View Image", style: .default, handler: { action in
                // open image with SimpleImageViewer
                let configuration = ImageViewerConfiguration { config in
                    config.imageView = sender.imageView
                }
                
                let controller = ImageViewerController(configuration: configuration)
                self.present(controller, animated: true, completion: nil)
            }))
            controller.addAction(UIAlertAction(title: "Remove Image", style: .destructive, handler: { action in
                // remove the user's profile picture
                CliqCardAPI.shared.removeProfilePicture(responseHandler: { (account, error) in
                    if let account = account {
                        // update UI
                        self.account = account
                        self.accountBuilder = CCAccountBuilder.init(model: account)
                        self.tableView.reloadData()
                    } else {
                        // display error
                        self.showError(title: "Error", message: "There was an unknown error removing your profile picture. Please try again later.")
                    }
                })
            }))
        }
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // upload the image
            CliqCardAPI.shared.uploadProfilePicture(image: pickedImage) { (account, error) in
                if let account = account {
                    // update the UI with the new account info
                    self.account = account
                    self.accountBuilder = CCAccountBuilder.init(model: account)
                    self.tableView.reloadData()
                } else {
                    // display an error message
                    self.showError(title: "Error", message: "There was an unknown error uploading your profile picture. Please try again later.")
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func save(callback: @escaping (APIError?) -> Void) {
        // build the new account cards
        let account = self.accountBuilder.build()
        let personalCard = self.personalCardBuilder.build()
        let workCard = self.workCardBuilder.build()
        
        // send the account to the server
        CliqCardAPI.shared.updateAccount(account: account) { (account, error) in
            if let account = account {
                // recreate the account builder
                self.account = account
                self.accountBuilder = CCAccountBuilder.init(model: account)
                // send the personal card to the server
                CliqCardAPI.shared.updatePersonalCard(personalCard: personalCard) { (personalCard, error) in
                    if let personalCard = personalCard {
                        // recreate the personal card builder
                        self.personalCard = personalCard
                        self.personalCardBuilder = CCPersonalCardBuilder.init(model: personalCard)
                        // send the work card to the server
                        CliqCardAPI.shared.updateWorkCard(workCard: workCard, responseHandler: { (workCard, error) in
                            if let workCard = workCard {
                                // recreate the work card builder
                                self.workCard = workCard
                                self.workCardBuilder = CCWorkCardBuilder.init(model: workCard)
                                // send the callback
                                callback(nil)
                            } else {
                                // send back the error
                                callback(error)
                            }
                        })
                    } else {
                        // send back the error
                        callback(error)
                    }
                }
            } else {
                // send back the error
                callback(error)
            }
        }
    }
    
    @objc func openSettings() {
        // create a new settings controller
        let controller = SettingsController()
        // push the controller
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
