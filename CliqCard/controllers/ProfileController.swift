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
import Hero

class ProfileController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    var loading: Bool = true
    
    var account: CCAccount!
    
    var homeController: HomeController!
    
    // mutable builder versions
    var accountBuilder: CCAccountBuilder!
    
    // image picker
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.lightestGray
        
        self.tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: "ProfileHeaderCell")
        self.tableView.register(SubHeaderCell.self, forCellReuseIdentifier: "SubHeaderCell")
        self.tableView.register(InlineDataCell.self, forCellReuseIdentifier: "InlineDataCell")
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        self.tableView.register(SingleLineLinkCell.self, forCellReuseIdentifier: "SingleLineLinkCell")
        
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        self.title = "Profile"
        
        let settingsButton = UIBarButtonItem()
        settingsButton.setIcon(icon: .icofont(.gear), iconSize: 24, color: Colors.darkGray, cgRect: CGRect(x: 0, y: 4, width: 24, height: 24), target: self, action: #selector(openSettings))
        self.navigationItem.rightBarButtonItem = settingsButton
        
        let groupsButton = UIBarButtonItem()
        groupsButton.setIcon(icon: .icofont(.arrowLeft), iconSize: 28, color: Colors.darkGray, cgRect: CGRect(x: 0, y: 0, width: 24, height: 24), target: self, action: #selector(showGroups))
        self.navigationItem.leftBarButtonItem = groupsButton
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
        self.imagePicker.delegate = self
        
        self.loadAccount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func showGroups() {
        self.homeController.showGroupsFromProfile()
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
                // set loading to false
                self.loading = false
                // reload the table view
                self.tableView.reloadData()
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func refresh() {
        self.loadAccount()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.loading ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // header cell, name header, 2 name cells, phones header, phone count, add phone, emails header, email count, add email, end buffer
        return 9 + self.account.phones.count + self.account.emails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // profile header
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            if let profilePicture = self.account.profilePicture {
                cell.profileImageButton.kf.setImage(with: profilePicture.original, for: .normal)
            } else {
                cell.profileImageButton.setImage(UIImage(named: "DefaultUserProfile"), for: .normal)
            }
            cell.profileImageButton.addTarget(self, action: #selector(openImage(sender:)), for: .touchUpInside)
            cell.nameLabel.text = self.account.fullName
            return cell
        }
        
        if indexPath.row == 1 {
            // header for name
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubHeaderCell", for: indexPath) as! SubHeaderCell
            cell.label.text = "NAME"
            return cell
        }
        
        if indexPath.row == 2 {
            // first name
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = "First name"
            cell.valueLabel.text = self.account.firstName
            cell.isTopSeparatorHidden = true
            cell.isBottomSeparatorHidden = false
            return cell
        }
        
        if indexPath.row == 3 {
            // last name
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = "Last name"
            cell.valueLabel.text = self.account.lastName
            cell.isTopSeparatorHidden = false
            cell.isBottomSeparatorHidden = true
            return cell
        }
        
        if indexPath.row == 4 {
            // header for phones
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubHeaderCell", for: indexPath) as! SubHeaderCell
            cell.label.text = "PHONES"
            return cell
        }
        
        if indexPath.row < 5 + self.account.phones.count {
            // phone
            let phone = self.account.phones[indexPath.row - 5]
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = phone.type.capitalized
            cell.valueLabel.text = Utils.formatPhoneNumber(phoneNumber: phone.number)
            cell.isTopSeparatorHidden = indexPath.row == 5
            cell.isBottomSeparatorHidden = false
            return cell
        }
        
        if indexPath.row == 5 + self.account.phones.count {
            // add phone
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLineLinkCell", for: indexPath) as! SingleLineLinkCell
            cell.titleLabel.text = "Add Phone"
            cell.isTopSeparatorHidden = false
            cell.isBottomSeparatorHidden = true
            return cell
        }
        
        if indexPath.row == 6 + self.account.phones.count {
            // header for emails
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubHeaderCell", for: indexPath) as! SubHeaderCell
            cell.label.text = "EMAILS"
            return cell
        }
        
        if indexPath.row < 7 + self.account.phones.count + self.account.emails.count {
            // email
            let email = self.account.emails[indexPath.row - 7 - self.account.phones.count]
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = email.type.capitalized
            cell.valueLabel.text = email.address
            cell.isTopSeparatorHidden = indexPath.row == 7 + self.account.phones.count
            cell.isBottomSeparatorHidden = false
            return cell
        }
        
        if indexPath.row == 7 + self.account.phones.count + self.account.emails.count {
            // add email
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLineLinkCell", for: indexPath) as! SingleLineLinkCell
            cell.titleLabel.text = "Add Email"
            cell.isTopSeparatorHidden = false
            cell.isBottomSeparatorHidden = true
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
            // header for name
            return 72
        }
        
        if indexPath.row == 2 || indexPath.row == 3 {
            return 64
        }
        
        if indexPath.row == 4 {
            // header for phones
            return 72
        }
        
        if indexPath.row < 5 + self.account.phones.count {
            // phone
            return 68
        }
        
        if indexPath.row == 5 + self.account.phones.count {
            // add phone
            return 68
        }
        
        if indexPath.row == 6 + self.account.phones.count {
            // header for emails
            return 72
        }
        
        if indexPath.row < 7 + self.account.phones.count + self.account.emails.count {
            // email
            return 68
        }
        
        if indexPath.row == 7 + self.account.phones.count + self.account.emails.count {
            // add email
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
        
        if indexPath.row == 2 {
            let controller = EditNameController(name: self.account.firstName, placeholder: "First Name") { firstName in
                self.accountBuilder.firstName = firstName
                self.accountBuilder.fullName = "\(firstName) \(self.account.lastName)"
                // save
                self.save() { error -> Void in
                    if error != nil {
                        self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                        self.accountBuilder = CCAccountBuilder.init(model: self.account)
                    }
                    self.dismiss(animated: true, completion: nil)
                    self.tableView.reloadData()
                }
            }
            let navigationController = SJONavigationController(rootViewController: controller)
            navigationController.transitioningDelegate = self
            self.present(navigationController, animated: true, completion: nil)
            return
        }
        
        if indexPath.row == 3 {
            let controller = EditNameController(name: self.account.lastName, placeholder: "Last Name") { lastName in
                self.accountBuilder.lastName = lastName
                self.accountBuilder.fullName = "\(self.account.firstName) \(lastName)"
                // save
                self.save() { error -> Void in
                    if error != nil {
                        self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                        self.accountBuilder = CCAccountBuilder.init(model: self.account)
                    }
                    self.dismiss(animated: true, completion: nil)
                    self.tableView.reloadData()
                }
            }
            let navigationController = SJONavigationController(rootViewController: controller)
            navigationController.transitioningDelegate = self
            self.present(navigationController, animated: true, completion: nil)
            return
        }
        
        if indexPath.row < 5 + self.account.phones.count {
            // update or delete
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            controller.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
                // get the phone
                let phone = self.account.phones[indexPath.row - 5]
                let editController = EditPhoneController(e164PhoneNumber: phone.number) { phoneNumber in
                    // create a phone builder
                    let phoneBuilder = CCPhoneBuilder.init(model: phone)
                    // update
                    phoneBuilder.number = phoneNumber
                    // update on the server
                    CliqCardAPI.shared.updatePhone(phone: phoneBuilder.build(), responseHandler: { (phone, error) in
                        if let phone = phone {
                            // update the phone in the account builder
                            self.accountBuilder.phones[indexPath.row - 5] = phone
                            // build
                            self.account = self.accountBuilder.build()
                        } else {
                            self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                        }
                        self.dismiss(animated: true, completion: nil)
                        self.tableView.reloadData()
                    })
                }
                let navigationController = SJONavigationController(rootViewController: editController)
                navigationController.transitioningDelegate = self
                self.present(navigationController, animated: true, completion: nil)
            }))
            controller.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                // get the phone
                let phone = self.account.phones[indexPath.row - 5]
                // delete on server
                CliqCardAPI.shared.deletePhone(phone: phone, responseHandler: { error in
                    if error != nil {
                        self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                    } else {
                        // remove the phone from the builder
                        self.accountBuilder.phones.remove(at: indexPath.row - 5)
                        // build
                        self.account = self.accountBuilder.build()
                    }
                    self.tableView.reloadData()
                })
            }))
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        if indexPath.row == 5 + self.account.phones.count {
            // select phone type
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            controller.addAction(UIAlertAction(title: "mobile", style: .default, handler: { action in
                self.newPhone(type: "mobile")
            }))
            controller.addAction(UIAlertAction(title: "home", style: .default, handler: { action in
                self.newPhone(type: "home")
            }))
            controller.addAction(UIAlertAction(title: "work", style: .default, handler: { action in
                self.newPhone(type: "work")
            }))
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        if indexPath.row < 7 + self.account.phones.count + self.account.emails.count {
            // update or delete
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            controller.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
                // get the email
                let email = self.account.emails[indexPath.row - 7 - self.account.phones.count]
                let editController = EditEmailController(email: email.address) { emailAddress in
                    // create an email builder
                    let emailBuilder = CCEmailBuilder.init(model: email)
                    // update
                    emailBuilder.address = emailAddress
                    // update on the server
                    CliqCardAPI.shared.updateEmail(email: emailBuilder.build(), responseHandler: { (email, error) in
                        if let email = email {
                            // update the email in the account builder
                            self.accountBuilder.emails[indexPath.row - 7 - self.account.phones.count] = email
                            // build
                            self.account = self.accountBuilder.build()
                        } else {
                            self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                        }
                        self.dismiss(animated: true, completion: nil)
                        self.tableView.reloadData()
                    })
                }
                let navigationController = SJONavigationController(rootViewController: editController)
                navigationController.transitioningDelegate = self
                self.present(navigationController, animated: true, completion: nil)
            }))
            controller.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                // get the email
                let email = self.account.emails[indexPath.row - 7 - self.account.phones.count]
                // delete on server
                CliqCardAPI.shared.deleteEmail(email: email, responseHandler: { error in
                    if error != nil {
                        self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                    } else {
                        // remove the email from the builder
                        self.accountBuilder.emails.remove(at: indexPath.row - 7 - self.account.phones.count)
                        // build
                        self.account = self.accountBuilder.build()
                    }
                    self.tableView.reloadData()
                })
            }))
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        if indexPath.row == 7 + self.account.phones.count + self.account.emails.count {
            // select email type
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            controller.addAction(UIAlertAction(title: "personal", style: .default, handler: { action in
                self.newEmail(type: "personal")
            }))
            controller.addAction(UIAlertAction(title: "work", style: .default, handler: { action in
                self.newEmail(type: "work")
            }))
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
            return
        }
    }
    
    func newPhone(type: String) {
        // create edit phone controller
        let controller = EditPhoneController(e164PhoneNumber: nil) { phoneNumber in
            // create on the server
            CliqCardAPI.shared.createPhone(type: type, number: phoneNumber, ext: nil, responseHandler: { (phone, error) in
                if let phone = phone {
                    // add the phone in the account builder
                    self.accountBuilder.phones.append(phone)
                    // build
                    self.account = self.accountBuilder.build()
                } else {
                    self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                }
                self.dismiss(animated: true, completion: nil)
                self.tableView.reloadData()
            })
        }
        let navigationController = SJONavigationController(rootViewController: controller)
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func newEmail(type: String) {
        // create edit email controller
        let controller = EditEmailController(email: nil) { emailAddress in
            // create on the server
            CliqCardAPI.shared.createEmail(type: type, address: emailAddress, responseHandler: { (email, error) in
                if let email = email {
                    // add the email in the account builder
                    self.accountBuilder.emails.append(email)
                    // build
                    self.account = self.accountBuilder.build()
                } else {
                    self.showError(title: "Error", message: "There was an error updating your information. Please try again later.")
                }
                self.dismiss(animated: true, completion: nil)
                self.tableView.reloadData()
            })
        }
        let navigationController = SJONavigationController(rootViewController: controller)
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
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
        
        // send the account to the server
        CliqCardAPI.shared.updateAccount(account: account) { (account, error) in
            if let account = account {
                // recreate the account builder
                self.account = account
                self.accountBuilder = CCAccountBuilder.init(model: account)
                // send the callback
                callback(nil)
            } else {
                // send back the error
                callback(error)
            }
        }
    }
    
    @objc func openSettings() {
        // create a new settings controller
        let controller = SettingsController()
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
