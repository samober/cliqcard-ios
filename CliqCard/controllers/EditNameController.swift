//
//  EditNameController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit

class EditNameController: UITableViewController {

    var name: String?
    var placeholder: String
    let callback: (String) -> Void
    
    lazy var editNameCell: EditNameCell! = {
        let view = EditNameCell()
        return view
    }()
    
    init(name: String?, placeholder: String, callback: @escaping (String) -> Void) {
        // save the old name
        self.name = name
        // save the placeholder
        self.placeholder = placeholder
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
        
        self.tableView.register(EditNameCell.self, forCellReuseIdentifier: "EditNameCell")
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        self.tableView.separatorStyle = .none
        
        self.title = self.placeholder
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endEditing))
        
        self.editNameCell.nameField.text = self.name
        self.editNameCell.nameField.placeholder = self.placeholder
        self.editNameCell.nameField.becomeFirstResponder()
    }
    
    @objc func endEditing() {
        // get the name
        guard let name = self.editNameCell.nameField.text, name.count > 0 else {
            // name's can't be blank - display an error
            self.showError(title: "Your name cannot be left blank", message: "")
            return
        }
        
        // send the name through the callback
        self.callback(name)
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
        return self.editNameCell
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
