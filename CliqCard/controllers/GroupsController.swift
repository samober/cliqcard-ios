//
//  HomeController.swift
//  CliqCard
//
//  Created by Sam Ober on 6/14/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import SwiftIcons
import Kingfisher
import pop

class GroupsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    var groups: [CCGroup] = []
    
    var homeController: HomeController!
    
    lazy var profileButton: UIButton! = {
        let view = UIButton(type: .custom)
        view.backgroundColor = Colors.lightGray
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.imageView?.contentMode = .scaleAspectFill
        view.snp.makeConstraints({ make in
            make.width.height.equalTo(30)
        })
        
        return view
    }()
    
    lazy var tableView: UITableView! = {
        let view = UITableView()
        view.backgroundColor = UIColor.white
        view.separatorStyle = .none
        view.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
        view.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        
        return view
    }()
    
    lazy var addGroupButtonContainer: UIView! = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 1.5
        
        return view
    }()
    
    lazy var addGroupButton: UIButton! = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 28
        view.layer.masksToBounds = true
        view.setBackgroundImage(UIImage(color: Colors.bondiBlue), for: .normal)
        view.setIcon(icon: .fontAwesome(.plus), iconSize: 24, color: UIColor.white, backgroundColor: UIColor.clear, forState: .normal)
        
        return view
    }()
    
    let refreshControl = UIRefreshControl()

    var addGroupButtonBottomConstraint: Constraint!
    
    var lastContentOffset: CGFloat = 0
    var buttonsHidden: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register for model update notifications
        NotificationCenter.default.addObserver(self, selector: #selector(modelDidUpdate(notification:)), name: Notification.Name(rawValue: kPlankDidInitializeNotification), object: nil)
        
        self.view.backgroundColor = UIColor.white
        
        self.title = "Groups"
        
        // remove back button titles
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.delegate = self
        
        // create an empty bar button item for contacts
        let contactsButton = UIBarButtonItem()
        // set the icon and add a target to open up the contacts view
        contactsButton.setIcon(icon: .icofont(.contacts), iconSize: 22, color: Colors.darkGray, cgRect: CGRect(x: 0, y: 2, width: 24, height: 24), target: self, action: #selector(viewContacts))
        // add it the left
        self.navigationItem.leftBarButtonItem = contactsButton

        // load the user image for the profile button
        if let currentUser = CliqCardAPI.shared.currentUser, let profilePicture = currentUser.profilePicture {
            self.profileButton.kf.setImage(with: profilePicture.thumbBig, for: .normal)
        } else {
            self.profileButton.setImage(UIImage(named: "DefaultUserProfile"), for: .normal)
        }
        // hook up the profile button to open the profile page
        self.profileButton.addTarget(self, action: #selector(viewProfile), for: .touchUpInside)
        // wrap it in a bar button item
        let profileBarButton = UIBarButtonItem(customView: self.profileButton)
        // assign it the right spot
        self.navigationItem.rightBarButtonItem = profileBarButton
        
        // setup a refresh control
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        // hook up the table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // position the table view
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(0)
            make.left.right.bottom.equalToSuperview()
        }
        
        // position the add button
        self.addGroupButtonContainer.addSubview(self.addGroupButton)
        self.addGroupButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(56)
        }
        self.view.addSubview(self.addGroupButtonContainer)
        self.addGroupButtonContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            self.addGroupButtonBottomConstraint = make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin).offset(-24).constraint
        }
        
        self.addGroupButton.addTarget(self, action: #selector(addGroup), for: .touchUpInside)

        self.loadGroups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refresh()
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func hideButtons() {
        if !self.buttonsHidden {
            if let anim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant) {
                anim.toValue = 48 + self.addGroupButton.bounds.height
                self.addGroupButtonBottomConstraint.layoutConstraints.first?.pop_add(anim, forKey: "slide")
            }
            
            self.buttonsHidden = true
        }
    }
    
    func showButtons() {
        if self.buttonsHidden {
            if let anim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant) {
                anim.toValue = -24
                self.addGroupButtonBottomConstraint.layoutConstraints.first?.pop_add(anim, forKey: "slide")
            }
            
            self.buttonsHidden = false
        }
    }
    
    func loadGroups() {
        CliqCardAPI.shared.getGroups { (groups, error) in
            if error != nil {
                self.showError(title: "Error", message: "Unable to load groups at this time. Please try again later.")
            } else if let groups = groups {
                self.groups = groups
                self.tableView.reloadData()
            }
            
            // stop refreshing
            self.refreshControl.endRefreshing()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == self.groups.count + 1 {
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        
        let group = self.groups[indexPath.row - 1]
        if let picture = group.picture {
            cell.groupImageView.kf.setImage(with: picture.thumbBig)
        } else {
            cell.groupImageView.image = UIImage(named: "DefaultGroupProfile")
        }
        cell.nameLabel.text = group.name
        cell.membersLabel.text = "\(group.memberCount) member\(group.memberCount == 1 ? "" : "s")"
        
        cell.shareButton.tag = indexPath.row - 1
        cell.shareButton.addTarget(self, action: #selector(shareGroup(sender:)), for: .touchUpInside)
        
        cell.isTopSeparatorHidden = false
        cell.isBottomSeparatorHidden = false
        if indexPath.row == 1 {
            cell.isTopSeparatorHidden = true
        }
        if indexPath.row == self.groups.count {
            cell.isBottomSeparatorHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == self.groups.count + 1 {
            return 0
        }
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row > 0 && indexPath.row < self.groups.count + 1 {
            // get the group
            let group = self.groups[indexPath.row - 1]
            // create a new group controller
            let controller = GroupController(group: group)
            let navigationController = SJONavigationController(rootViewController: controller)
            navigationController.transitioningDelegate = self
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 32) {
            // scrolling down
            self.hideButtons()
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            // scrolling up
            self.showButtons()
        }
    }
    
    @objc func refresh() {
        self.loadGroups()
    }
    
    @objc func shareGroup(sender: UIButton) {
        let group = self.groups[sender.tag]
        CliqCardAPI.shared.getGroupCode(id: group.identifier) { (code, error) in
            if let code = code {
                let controller = ShareJoinCodeController(code: code)
                let navigationController = SJONavigationController(rootViewController: controller)
                navigationController.transitioningDelegate = self
                self.present(navigationController, animated: true, completion: nil)
            } else {
                self.showError(title: "Error", message: "Could not share this group right now.")
            }
        }
    }
    
    @objc func viewContacts() {
        self.homeController.showContacts()
    }
    
    @objc func viewProfile() {
        self.homeController.showProfile()
    }
    
    @objc func addGroup() {
        // enter manually or scan
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Create Group", style: .default, handler: { action in
            // push a new group controller
            let controller = NewGroupController()
            let navigationController = SJONavigationController(rootViewController: controller)
            navigationController.transitioningDelegate = self
            self.present(navigationController, animated: true, completion: nil)
        }))
        controller.addAction(UIAlertAction(title: "Enter Code", style: .default, handler: { action in
            // create a new enter join code controller
            let controller = EnterJoinCodeController(callback: { group in
                // refresh our group list
                self.refresh()
                // push a group controller
                let controller = GroupController(group: group)
                let navigationController = SJONavigationController(rootViewController: controller)
                navigationController.transitioningDelegate = self
                self.present(navigationController, animated: true, completion: nil)
            })
            // create a new navigation controller
            let navigationController = SJONavigationController(rootViewController: controller)
            navigationController.transitioningDelegate = self
            // present modal
            self.present(navigationController, animated: true, completion: nil)
        }))
        controller.addAction(UIAlertAction(title: "Scan QR Code", style: .default, handler: { action in
            // create a new scan controller
            let controller = ScanQRController(callback: { group in
                // refresh our group list
                self.refresh()
                // push a group controller
                let controller = GroupController(group: group)
                let navigationController = SJONavigationController(rootViewController: controller)
                navigationController.transitioningDelegate = self
                self.present(navigationController, animated: true, completion: nil)
            })
            // create a new navigation controller
            let navigationController = SJONavigationController(rootViewController: controller)
            navigationController.transitioningDelegate = self
            // present
            self.present(navigationController, animated: true, completion: nil)
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func modelDidUpdate(notification: Notification) {
        // check for new group
        if let newGroup = notification.object as? CCGroup {
            let index = self.groups.index { group -> Bool in
                return newGroup.identifier == group.identifier
            }
            if let index = index {
                self.groups.remove(at: index)
                self.groups.insert(newGroup, at: index)
                self.tableView.reloadData()
            }
        }
        // check for new account
        else if let newAccount = notification.object as? CCAccount {
            // load the user image for the profile button
            if let profilePicture = newAccount.profilePicture {
                self.profileButton.kf.setImage(with: profilePicture.thumbBig, for: .normal)
            } else {
                self.profileButton.setImage(UIImage(named: "DefaultUserProfile"), for: .normal)
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let toVC = toVC as? ContactsController {
            return SlideRightNavigationAnimator()
        }
        
        return nil
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
