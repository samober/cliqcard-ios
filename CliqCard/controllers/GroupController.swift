//
//  GroupController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SimpleImageViewer

class GroupController: UITableViewController {
    
    var group: CCGroup
    
    init(group: CCGroup) {
        // save the group
        self.group = group
        // initialize
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register for model update notifications
        NotificationCenter.default.addObserver(self, selector: #selector(modelDidUpdate(notification:)), name: Notification.Name(rawValue: kPlankDidInitializeNotification), object: nil)

        self.view.backgroundColor = Colors.lightestGray
        
        self.tableView.register(GroupHeaderCell.self, forCellReuseIdentifier: "GroupHeaderCell")
        self.tableView.register(SingleLineLinkCell.self, forCellReuseIdentifier: "SingleLineLinkCell")
        self.tableView.register(SingleLineIconLinkCell.self, forCellReuseIdentifier: "SingleLineIconLinkCell")
        self.tableView.register(SingleLineToggleCell.self, forCellReuseIdentifier: "SingleLineToggleCell")
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.title = self.group.name
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupHeaderCell", for: indexPath) as! GroupHeaderCell
            if let picture = self.group.picture {
                cell.imageButton.kf.setImage(with: picture.original, for: .normal)
            } else {
                cell.imageButton.setImage(UIImage(named: "DefaultGroupProfile"), for: .normal)
            }
            cell.imageButton.addTarget(self, action: #selector(openImage(sender:)), for: .touchUpInside)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLineToggleCell", for: indexPath) as! SingleLineToggleCell
            cell.titleLabel.text = "Notifications"
            cell.toggleView.isOn = true
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLineIconLinkCell", for: indexPath) as! SingleLineIconLinkCell
            cell.iconImageView.setIcon(icon: .fontAwesome(.users), textColor: Colors.darkGray, backgroundColor: UIColor.clear, size: CGSize(width: 28, height: 28))
            cell.titleLabel.text = "\(self.group.memberCount) member\(self.group.memberCount == 1 ? "" : "s")"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLineIconLinkCell", for: indexPath) as! SingleLineIconLinkCell
            cell.iconImageView.setIcon(icon: .fontAwesome(.cog), textColor: Colors.darkGray, backgroundColor: UIColor.clear, size: CGSize(width: 32, height: 32))
            cell.titleLabel.text = "Settings"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 280
        }
        return 56
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 2:
            // create a new group members controller
            let controller = GroupMembersController(group: self.group)
            // push the controller
            self.navigationController?.pushViewController(controller, animated: true)
        case 3:
            // create a new group settings controller
            let controller = GroupSettingsController(group: self.group)
            // push the controller
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }
    
    @objc func openImage(sender: UIButton) {
        let configuration = ImageViewerConfiguration { config in
            config.imageView = sender.imageView
        }
        
        let controller = ImageViewerController(configuration: configuration)
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func modelDidUpdate(notification: Notification) {
        if let newGroup = notification.object as? CCGroup, self.group.identifier == newGroup.identifier {
            // the group was updated
            self.group = newGroup
            self.title = newGroup.name
            self.tableView.reloadData()
        }
    }
    
    deinit {
        // remove observer
        NotificationCenter.default.removeObserver(self)
    }
    
}