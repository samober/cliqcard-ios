//
//  EditEmailController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit

class EditEmailController: UITableViewController {
    
    var email: String?
    let callback: (String?) -> Void
    
    lazy var editEmailCell: EditEmailCell! = {
        let view = EditEmailCell()
        return view
    }()
    
    init(email: String?, callback: @escaping (String?) -> Void) {
        // save the old email
        self.email = email
        // set the callback that sends back the new value
        self.callback = callback
        // initialize
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.lightestGray

        self.tableView.register(EditEmailCell.self, forCellReuseIdentifier: "EditEmailCell")
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        self.tableView.separatorStyle = .none
        
        self.title = "Email"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endEditing))
        
        self.editEmailCell.emailField.text = self.email
        self.editEmailCell.emailField.becomeFirstResponder()
    }

    @objc func endEditing() {
        // get the email
        guard let email = self.editEmailCell.emailField.text, email.count > 0 else {
            // pass back blank (deleting the email)
            self.callback(nil)
            return
        }
        
        // send the email through the callback
        self.callback(email)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            return cell
        }
        
        // return the edit cell
        return self.editEmailCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 32
        case 1:
            return 48
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
