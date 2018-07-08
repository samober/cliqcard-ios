//
//  GroupSettingsController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit

class GroupSettingsController: UITableViewController {
    
    var group: CCGroup!
    var groupBuilder: CCGroupBuilder!
    
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
        
        self.view.backgroundColor = Colors.lightestGray
        
        self.tableView.register(InlineDataCell.self, forCellReuseIdentifier: "InlineDataCell")
        self.tableView.register(LargeActionButtonCell.self, forCellReuseIdentifier: "LargeActionButtonCell")
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.title = "\(self.group.name) Settings"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InlineDataCell", for: indexPath) as! InlineDataCell
            cell.keyLabel.text = "Name"
            cell.valueLabel.text = self.group.name
            cell.valueLabel.isHidden = false
            cell.placeholderLabel.isHidden = true
            return cell
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LargeActionButtonCell", for: indexPath) as! LargeActionButtonCell
            cell.actionButton.setTitle("Leave Group", for: .normal)
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
            return 48
        case 2:
            return 104
        case 3:
            return 72
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 1:
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
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(controller, animated: true, completion: nil)
    }

}
