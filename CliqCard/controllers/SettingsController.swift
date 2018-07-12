//
//  SettingsController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.tableView.register(LargeActionButtonCell.self, forCellReuseIdentifier: "LargeActionButtonCell")
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        self.tableView.separatorStyle = .none
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        self.title = "Settings"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LargeActionButtonCell", for: indexPath) as! LargeActionButtonCell
            cell.buttonColor = Colors.carminePink
            cell.actionButton.setTitle("Logout", for: .normal)
            cell.actionButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 72
        }
        return 48
    }
    
    @objc func logout() {
        let controller = UIAlertController(title: "Are you sure?", message: "Logging out will remove any data associated with your account and stop contacts from being synced.", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
            CliqCardAPI.shared.logout()
        }))
        self.present(controller, animated: true, completion: nil)
    }

}
