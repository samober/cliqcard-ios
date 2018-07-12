//
//  GroupSettingsController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit

class GroupSettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var group: CCGroup!
    var groupBuilder: CCGroupBuilder!
    
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
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let closeButton = UIBarButtonItem()
        closeButton.setIcon(icon: .fontAwesome(.times), iconSize: 24, color: Colors.darkGray, cgRect: .zero, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = closeButton
        
        self.title = "\(self.group.name) Settings"
        
        self.imagePicker.delegate = self
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "LargeActionButtonCell", for: indexPath) as! LargeActionButtonCell
            cell.actionButton.setTitle("Leave Group", for: .normal)
            cell.buttonColor = Colors.carminePink
            cell.actionButton.addTarget(self, action: #selector(leaveGroup), for: .touchUpInside)
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
                    self.navigationController?.popViewController(animated: true)
                }
            }
            self.navigationController?.pushViewController(controller, animated: true)
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
        CliqCardAPI.shared.updateGroup(group: group) { (group, error) in
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
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }))
        self.present(controller, animated: true, completion: nil)
    }

}
