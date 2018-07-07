//
//  EditPhoneNumberController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import PhoneNumberKit
import SwiftIcons

class EditPhoneNumberController: UITableViewController {
    
    var e164PhoneNumber: String?
    
    var callback: (String?) -> Void
    
    let phoneNumberKit = PhoneNumberKit()
    
    lazy var editPhoneNumberCell: EditPhoneNumberCell! = {
        let view = EditPhoneNumberCell(countryCode: "+1", region: "US")
        return view
    }()
    
    init(e164PhoneNumber: String?, callback: @escaping (String?) -> Void) {
        // set the phone number (should be in E164 format)
        self.e164PhoneNumber = e164PhoneNumber
        // set the callback that sends back the new value
        self.callback = callback
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.lightestGray
        
        self.tableView.register(EditPhoneNumberCell.self, forCellReuseIdentifier: "EditPhoneNumberCell")
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        self.tableView.separatorStyle = .none

        self.title = "Phone Number"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endEditing))
        
        // update the national phone number
        self.parseE164PhoneNumber()
        
        // setup the country selection callbacks
        self.editPhoneNumberCell.showCountryPicker = { () -> Void in
            // create a new phone code picker controller
            let controller = PhoneCodePickerController(callback: { data in
                if let data = data {
                    self.editPhoneNumberCell.countryCode = data.code
                    self.editPhoneNumberCell.region = data.shortName
                }
            })
            // create a new navigation controller
            let navigationController = UINavigationController(rootViewController: controller)
            // present it as a modal
            self.present(navigationController, animated: true, completion: nil)
        }
        
        // show the keyboard
        self.editPhoneNumberCell.phoneNumberField.becomeFirstResponder()
    }
    
    func parseE164PhoneNumber() {
        // get the e164 phone number
        guard let e164PhoneNumber = self.e164PhoneNumber else { return }
        // parse the phone number
        guard let parsedPhoneNumber = try? phoneNumberKit.parse(e164PhoneNumber, withRegion: self.editPhoneNumberCell.region, ignoreType: true) else { return }
        // format it
        self.editPhoneNumberCell.phoneNumber = phoneNumberKit.format(parsedPhoneNumber, toType: .national)
    }
    
    @objc func endEditing() {
        // get the national number from the text field
        guard let nationalNumber = self.editPhoneNumberCell.phoneNumber, nationalNumber.count > 0 else {
            self.callback(nil)
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        // try to parse the national number
        guard let parsedNumber = try? phoneNumberKit.parse(nationalNumber, withRegion: self.editPhoneNumberCell.region, ignoreType: true) else {
            self.showError(title: "Invalid Phone Number", message: "The number you entered is not a valid phone number.")
            return
        }
        
        // convert it back into e164 format
        let e164Number = phoneNumberKit.format(parsedNumber, toType: .e164)
        
        // send it through the callback
        self.callback(e164Number)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return a buffer
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
            return cell
        }
        
        // return the edit cell
        return editPhoneNumberCell
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
