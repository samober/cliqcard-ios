//
//  GroupController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SimpleImageViewer
import SwiftIcons

class GroupController: UITableViewController, UIViewControllerTransitioningDelegate {
    
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

        self.view.backgroundColor = UIColor.white
        
        self.tableView.register(GroupHeaderCell.self, forCellReuseIdentifier: "GroupHeaderCell")
        self.tableView.register(SingleLineLinkCell.self, forCellReuseIdentifier: "SingleLineLinkCell")
        self.tableView.register(SingleLineIconLinkCell.self, forCellReuseIdentifier: "SingleLineIconLinkCell")
        self.tableView.register(SingleLineToggleCell.self, forCellReuseIdentifier: "SingleLineToggleCell")
        self.tableView.register(LargeActionButtonCell.self, forCellReuseIdentifier: "LargeActionButtonCell")
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let closeButton = UIBarButtonItem()
        closeButton.setIcon(icon: .fontAwesome(.times), iconSize: 24, color: Colors.darkGray, cgRect: .zero, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = closeButton
        
        self.title = self.group.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "LargeActionButtonCell", for: indexPath) as! LargeActionButtonCell
            cell.actionButton.setIcon(prefixText: "", prefixTextColor: UIColor.white, icon: .fontAwesome(.userPlus), iconColor: UIColor.white, postfixText: "  INVITE", postfixTextColor: UIColor.white, forState: .normal)
            cell.buttonColor = Colors.bondiBlue
            cell.actionButton.addTarget(self, action: #selector(shareCode), for: .touchUpInside)
            return cell
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLineToggleCell", for: indexPath) as! SingleLineToggleCell
            cell.titleLabel.text = "Notifications"
            cell.toggleView.isOn = true
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLineIconLinkCell", for: indexPath) as! SingleLineIconLinkCell
            cell.iconImageView.setIcon(icon: .fontAwesome(.users), textColor: Colors.darkGray, backgroundColor: UIColor.clear, size: CGSize(width: 28, height: 28))
            cell.titleLabel.text = "\(self.group.memberCount) member\(self.group.memberCount == 1 ? "" : "s")"
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLineIconLinkCell", for: indexPath) as! SingleLineIconLinkCell
            cell.iconImageView.setIcon(icon: .fontAwesome(.cog), textColor: Colors.darkGray, backgroundColor: UIColor.clear, size: CGSize(width: 32, height: 32))
            cell.titleLabel.text = "Settings"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 280
        case 1:
            return 64
        case 2:
            return 32
        default:
            return 64
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 4:
            // create a new group members controller
            let controller = GroupMembersController(group: self.group)
            let navigationController = SJONavigationController(rootViewController: controller)
            navigationController.transitioningDelegate = self
            self.present(navigationController, animated: true, completion: nil)
        case 5:
            // create a new group settings controller
            let controller = GroupSettingsController(group: self.group)
            let navigationController = SJONavigationController(rootViewController: controller)
            navigationController.transitioningDelegate = self
            self.present(navigationController, animated: true, completion: nil)
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
    
    @objc func shareCode() {
        // get the code
        CliqCardAPI.shared.getGroupCode(id: self.group.identifier) { (code, error) in
            if let code = code {
                // create a new share code controller
                let controller = ShareJoinCodeController(code: code)
                // create a new navigation controller
                let navigationController = SJONavigationController(rootViewController: controller)
                navigationController.transitioningDelegate = self
                self.present(navigationController, animated: true, completion: nil)
            } else {
                // present error message
                self.showError(title: "Error", message: "An error occurred while retrieving the join code. Please try again later.")
            }
        }
    }
    
    @objc func modelDidUpdate(notification: Notification) {
        if let newGroup = notification.object as? CCGroup, self.group.identifier == newGroup.identifier {
            // the group was updated
            self.group = newGroup
            self.title = newGroup.name
            self.tableView.reloadData()
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverPresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverDismissAnimator()
    }
    
    deinit {
        // remove observer
        NotificationCenter.default.removeObserver(self)
    }
    
}
