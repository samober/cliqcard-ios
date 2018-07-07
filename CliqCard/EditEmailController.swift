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
            // pop the view controller
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        // send the email through the callback
        self.callback(email)
        // pop the view controller
        self.navigationController?.popViewController(animated: true)
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
