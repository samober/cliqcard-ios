//
//  NewGroupController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/12/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import SwiftIcons
import SwiftSpinner

class NewGroupController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    var name: String = ""
    var image: UIImage?
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.title = "New Group"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(submit))
        
        self.tableView.register(InlineDataCell.self, forCellReuseIdentifier: "InlineDataCell")
        self.tableView.register(UpdatePictureCell.self, forCellReuseIdentifier: "UpdatePictureCell")
        self.tableView.register(LargeActionButtonCell.self, forCellReuseIdentifier: "LargeActionButtonCell")
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        self.tableView.separatorStyle = .none
        
        self.imagePicker.delegate = self
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func submit() {
        if self.name.count == 0 {
            self.showError(title: "Error", message: "Name cannot be blank.")
            return
        }
        
        // grab the sharing options
        let controller = GroupSharingController { (phoneIds, emailIds) in
            // dismiss share controller and show loader
            self.dismiss(animated: false, completion: nil)
            SwiftSpinner.show("Creating group...")
            
            CliqCardAPI.shared.createGroup(name: self.name, phoneIds: phoneIds, emailIds: emailIds) { (group, error) in
                if let group = group {
                    // check if we need to upload a picture
                    if let image = self.image {
                        CliqCardAPI.shared.uploadGroupPicture(groupId: group.identifier, image: image, responseHandler: { (group, error) in
                            if group != nil {
                                // were good
                                SwiftSpinner.hide()
                                self.cancel()
                            } else {
                                SwiftSpinner.hide({
                                    self.showError(title: "Image Upload Error", message: "The group was successfully created but there was a problem uploading the image.")
                                })
                            }
                        })
                    } else {
                        SwiftSpinner.hide()
                        self.cancel()
                    }
                } else {
                    SwiftSpinner.hide({
                        self.showError(title: "Error", message: "An unknown error occurred. Please try again later.")
                    })
                }
            }
        }
        let navigationController = SJONavigationController(rootViewController: controller)
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpdatePictureCell", for: indexPath) as! UpdatePictureCell
            if let image = self.image {
                cell.descriptionLabel.text = "Change picture"
                cell.pictureView.image = image
            } else {
                cell.descriptionLabel.text = "Upload a picture"
                cell.pictureView.image = UIImage(named: "DefaultGroupProfile")
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = "Name"
            cell.valueLabel.text = self.name
            cell.valueLabel.isHidden = self.name.count == 0
            cell.placeholderLabel.isHidden = self.name.count > 0
            return cell
        case 3:
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LargeActionButtonCell", for: indexPath) as! LargeActionButtonCell
            cell.actionButton.setTitle("CREATE", for: .normal)
            cell.buttonColor = Colors.bondiBlue
            cell.actionButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
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
            return 68
        case 3:
            return 72
        case 4:
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
            if self.image != nil {
                controller.addAction(UIAlertAction(title: "Remove Image", style: .destructive, handler: { action in
                    // remove the image
                    self.image = nil
                    self.tableView.reloadData()
                }))
            }
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
        case 2:
            let controller = EditNameController(name: self.name, placeholder: "Name") { name in
                self.name = name
                self.tableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
            let navigationController = SJONavigationController(rootViewController: controller)
            navigationController.transitioningDelegate = self
            self.present(navigationController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = pickedImage
            self.tableView.reloadData()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverPresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverDismissAnimator()
    }

}
