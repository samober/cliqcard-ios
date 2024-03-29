//
//  GroupSettingsController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SwiftSpinner

class GroupSettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    var group: CCGroup!
    var groupBuilder: CCGroupBuilder!
    
    var phoneIds: [Int] = []
    var emailIds: [Int] = []
    
    // image picker
    let imagePicker = UIImagePickerController()
    
    init(group: CCGroup) {
        // save the group
        self.group = group
        // create a builder
        self.groupBuilder = CCGroupBuilder.init(model: group)
        // initialize
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.tableView.register(InlineDataCell.self, forCellReuseIdentifier: "InlineDataCell")
        self.tableView.register(UpdatePictureCell.self, forCellReuseIdentifier: "UpdatePictureCell")
        self.tableView.register(LargeActionButtonCell.self, forCellReuseIdentifier: "LargeActionButtonCell")
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        self.tableView.register(SingleLineLinkCell.self, forCellReuseIdentifier: "SingleLineLinkCell")
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let closeButton = UIBarButtonItem()
        closeButton.setIcon(icon: .fontAwesome(.times), iconSize: 24, color: Colors.darkGray, cgRect: .zero, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = closeButton
        
        self.title = "\(self.group.name) Settings"
        
        self.imagePicker.delegate = self
        
        self.loadSharing()
    }
    
    func loadSharing() {
        SwiftSpinner.show("Loading...")
        
        CliqCardAPI.shared.getGroupSharing(id: self.group.identifier) { (phones, emails, error) in
            SwiftSpinner.hide({
                if let phones = phones, let emails = emails {
                    // map phones and emails to ids
                    self.phoneIds = phones.map { phone -> Int in
                        return phone.identifier
                    }
                    self.emailIds = emails.map { email -> Int in
                        return email.identifier
                    }
                } else {
                    self.showError(title: "Error", message: "An unexpected error occurred. Please try again later.") { () -> Void in
                        self.close()
                    }
                }
            })
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.group.isAdmin {
            return 8
        }
        return 7
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpdatePictureCell", for: indexPath) as! UpdatePictureCell
            if let picture = self.group.picture {
                cell.descriptionLabel.text = "Change group picture"
                cell.pictureView.kf.setImage(with: picture.thumbBig)
            } else {
                cell.descriptionLabel.text = "Upload a group picture"
                cell.pictureView.image = UIImage(named: "DefaultGroupProfile")
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = "Name"
            cell.valueLabel.text = self.group.name
            cell.valueLabel.isHidden = false
            cell.placeholderLabel.isHidden = true
            return cell
        case 3:
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLineLinkCell", for: indexPath) as! SingleLineLinkCell
            cell.titleLabel.text = "Sharing"
            return cell
        case 5:
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LargeActionButtonCell", for: indexPath) as! LargeActionButtonCell
            cell.actionButton.setTitle("LEAVE GROUP", for: .normal)
            cell.buttonColor = Colors.carminePink
            cell.actionButton.addTarget(self, action: #selector(leaveGroup), for: .touchUpInside)
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LargeActionButtonCell", for: indexPath) as! LargeActionButtonCell
            cell.actionButton.setTitle("DELETE GROUP", for: .normal)
            cell.buttonColor = Colors.carminePink
            cell.actionButton.addTarget(self, action: #selector(deleteGroup), for: .touchUpInside)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 32
        case 1:
            return 128
        case 2:
            return 64
        case 3:
            return 72
        case 4:
            return 64
        case 5:
            return 72
        case 6:
            return 72
        case 7:
            return 72
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 1:
            // present image options
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            controller.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .camera
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
            controller.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
            // only add remove option if there is an image
            if self.group.picture != nil {
                controller.addAction(UIAlertAction(title: "Remove Image", style: .destructive, handler: { action in
                    // remove the group image
                    CliqCardAPI.shared.removeGroupPicture(groupId: self.group.identifier, responseHandler: { (group, error) in
                        if let group = group {
                            // update the UI
                            self.group = group
                            self.groupBuilder = CCGroupBuilder.init(model: group)
                            self.title = "\(group.name) Settings"
                            self.tableView.reloadData()
                        } else {
                            // display error message
                            self.showError(title: "Error", message: "An unknown error occured removing this group's image. Please try again later.")
                        }
                    })
                }))
            }
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
        case 2:
            let controller = EditNameController(name: self.group.name, placeholder: "Name") { name in
                self.groupBuilder.name = name
                // save
                self.save() { error in
                    if error != nil {
                        self.showError(title: "Error", message: "We were unable to update your group at this moment. Sorry for the inconvenience.")
                        self.groupBuilder = CCGroupBuilder.init(model: self.group)
                    }
                    self.title = "\(self.group.name) Settings"
                    self.tableView.reloadData()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            let navigationController = SJONavigationController(rootViewController: controller)
            navigationController.transitioningDelegate = self
            self.present(navigationController, animated: true, completion: nil)
        case 4:
            let controller = GroupSharingController(phoneIds: self.phoneIds, emailIds: self.emailIds, callback: { (phoneIds, emailIds) in
                self.phoneIds = phoneIds
                self.emailIds = emailIds
                SwiftSpinner.show("Saving...")
                // save
                self.save() { error in
                    SwiftSpinner.hide({
                        if error != nil {
                            self.showError(title: "Error", message: "We were unable to update your group at this moment. Sorry for the inconvenience.")
                            self.groupBuilder = CCGroupBuilder.init(model: self.group)
                        }
                        self.title = "\(self.group.name) Settings"
                        self.tableView.reloadData()
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            })
            let navigationController = SJONavigationController(rootViewController: controller)
            navigationController.transitioningDelegate = self
            self.present(navigationController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // upload the new image
            CliqCardAPI.shared.uploadGroupPicture(groupId: self.group.identifier, image: pickedImage) { (group, error) in
                if let group = group {
                    // update the UI
                    self.group = group
                    self.groupBuilder = CCGroupBuilder.init(model: group)
                    self.title = "\(group.name) Settings"
                    self.tableView.reloadData()
                } else {
                    // display error message
                    self.showError(title: "Error", message: "An unknown error occured uploading this group's new image. Please try again later.")
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func save(callback: @escaping (APIError?) -> Void) {
        // build the new group
        let group = self.groupBuilder.build()
        
        // send the group to the server
        CliqCardAPI.shared.updateGroup(group: group, phoneIds: self.phoneIds, emailIds: self.emailIds) { (group, error) in
            if let group = group {
                // update
                self.group = group
                self.groupBuilder = CCGroupBuilder.init(model: group)
                // send callback
                callback(nil)
            } else {
                // send back the error
                callback(error)
            }
        }
    }
    
    @objc func leaveGroup() {
        // confirm
        let controller = UIAlertController(title: "Are you sure?", message: "You will lose any contacts you have in this group and you may not be able to get back in.", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { action in
            // leave the group
            CliqCardAPI.shared.leaveGroup(id: self.group.identifier, responseHandler: { (error) in
                if error != nil {
                    // display error message
                    self.showError(title: "Error", message: "An unknown error occurred.")
                } else {
                    // pop two controllers back
//                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    self.presentingViewController?.dismiss(animated: false, completion: nil)
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            })
        }))
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func deleteGroup() {
        // confirm
        let controller = UIAlertController(title: "Are you sure?", message: "Everyone in this group will lose each other's contact information and the group will be permanently removed.", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            // delete the group
            CliqCardAPI.shared.deleteGroup(group: self.group, responseHandler: { (error) in
                if error != nil {
                    self.showError(title: "Error", message: "An unknown error occurred.")
                } else {
                    // pop two controllers back
                    self.presentingViewController?.dismiss(animated: false, completion: nil)
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            })
        }))
        self.present(controller, animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverPresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverDismissAnimator()
    }

}
