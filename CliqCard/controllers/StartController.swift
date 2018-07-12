//
//  StartController.swift
//  CliqCard
//
//  Created by Sam Ober on 6/13/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import PhoneNumberKit
import Alamofire

class StartController: UIViewController {
    
    lazy var phoneNumberLabel: UILabel! = {
        let view = UILabel()
        view.text = "Enter your phone number"
        view.backgroundColor = UIColor.clear
        view.textAlignment = .center
        view.font = UIFont(name: "Lato-Regular", size: 22)
        view.textColor = Colors.darkestGray
        
        return view
    }()
    
    lazy var countryCodeLabel: UILabel! = {
        let view = UILabel()
        view.text = "+1"
        view.backgroundColor = UIColor.clear
        view.font = UIFont(name: "Lato-Regular", size: 18)
        view.textAlignment = .center
        view.textColor = Colors.darkGray
        
        return view
    }()
    
    lazy var phoneNumberField: SJOPhoneNumberTextField! = {
        let view = SJOPhoneNumberTextField()
        view.borderStyle = .none
        view.keyboardType = .numberPad
        view.font = UIFont(name: "Lato-Regular", size: 18)
        view.textColor = Colors.darkestGray
        view.placeholder = "(555) 555-5555"
        view.placeholderColor = Colors.gray
        
        return view
    }()
    
    lazy var submitButton: UIButton! = {
        let view = UIButton(type: .custom)
        view.backgroundColor = Colors.bondiBlue
        view.setTitle("NEXT", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Lato-Bold", size: 15)
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView! = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(phoneNumberLabel)
        self.view.addSubview(countryCodeLabel)
        self.view.addSubview(phoneNumberField)
        self.view.addSubview(activityIndicator)
        self.view.addSubview(submitButton)
        
        phoneNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-120)
        }
        
        countryCodeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(112)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(32)
            make.width.height.equalTo(32)
        }
        
        phoneNumberField.snp.makeConstraints { (make) in
            make.left.equalTo(countryCodeLabel.snp.right).offset(8)
            make.right.equalTo(self.view).offset(-64)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(32)
            make.height.equalTo(32)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(phoneNumberField.snp.bottom).offset(32)
            make.height.equalTo(48)
            make.width.equalTo(160)
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(submitButton)
        }
        
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // set phone number field to selected
        phoneNumberField.becomeFirstResponder()
    }
    
    @objc func submit() {
        // show animation
        activityIndicator.startAnimating()
        submitButton.isHidden = true
        
        let phoneNumberKit = PhoneNumberKit()
        do {
            // format phone number
            let phoneNumber = try phoneNumberKit.format(phoneNumberKit.parse(phoneNumberField.text!), toType: .e164)
            
            // create a new phone verification controller
            let phoneVerificationController = PhoneVerificationController(phoneNumber: phoneNumber)
            // push
            self.navigationController?.pushViewController(phoneVerificationController, animated: true)
            
            // reset the view in case we come back
            activityIndicator.stopAnimating()
            submitButton.isHidden = false
        } catch {
            // present an error
            let alertController = UIAlertController(title: "Invalid Number", message: "The number you entered is not a valid phone number", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            activityIndicator.stopAnimating()
            submitButton.isHidden = false
        }
    }
    
}
