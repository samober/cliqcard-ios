//
//  HomeController.swift
//  CliqCard
//
//  Created by Sam Ober on 6/14/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class HomeController: UITableViewController {
    
    var groups: [CCGroup] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
        
        self.title = "CliqCard"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Contacts", style: .plain, target: self, action: #selector(viewContacts))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(viewProfile))
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl

        self.loadGroups()
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
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        
        let group = self.groups[indexPath.row]
        cell.nameLabel.text = group.name
        cell.membersLabel.text = "\(group.memberCount) member\(group.memberCount == 1 ? "" : "s")"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func refresh() {
        self.loadGroups()
    }
    
    @objc func viewContacts() {
        // create a new contacts controller
        let controller = ContactsController()
        // push
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func viewProfile() {
        // create a new profile controller
        let controller = ProfileController()
        // push
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
