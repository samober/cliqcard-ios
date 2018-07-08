//
//  PhoneVerificationController.swift
//  CliqCard
//
//  Created by Sam Ober on 6/13/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import PhoneNumberKit
import Alamofire

class PhoneVerificationController: UIViewController {
    
    var phoneNumber: String
    var newUser: Bool = false
    
    lazy var verificationLabel: UILabel! = {
        let view = UILabel()
        view.text = "We have sent you a verification code. Please enter it below..."
        view.backgroundColor = UIColor.clear
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 20)
        view.numberOfLines = 0
        
        return view
    }()
    
    lazy var verificationCodeField: UITextField! = {
        let view = UITextField()
        view.placeholder = "485493"
        view.textAlignment = .center
        view.keyboardType = .numberPad
        
        return view
    }()
    
    lazy var submitButton: UIButton! = {
        let view = UIButton(type: .custom)
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 4
        view.setTitle("Submit", for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.setTitleColor(UIColor.white, for: .normal)
        
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView! = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        return view
    }()
    
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        self.view.addSubview(verificationLabel)
        self.view.addSubview(verificationCodeField)
        self.view.addSubview(activityIndicator)
        self.view.addSubview(submitButton)
        
        verificationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(64)
            make.right.equalTo(self.view).offset(-64)
            make.centerY.equalToSuperview().offset(-120)
        }
        
        verificationCodeField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(64)
            make.right.equalToSuperview().offset(-64)
            make.top.equalTo(verificationLabel.snp.bottom).offset(32)
        }
        
        submitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(verificationCodeField.snp.bottom).offset(32)
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        self.verifyPhoneNumber()
    }
    
    func showLoader() {
        // show the loading indicator and hide everything else
        verificationLabel.isHidden = true
        verificationCodeField.isHidden = true
        submitButton.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        // show the validation code form and hide everything else
        self.verificationLabel.isHidden = false
        self.verificationCodeField.isHidden = false
        self.submitButton.isHidden = false
        self.activityIndicator.stopAnimating()
    }
    
    func verifyPhoneNumber() {
        self.showLoader()
        
        // create a verification request to the server with the phone number
        CliqCardAPI.shared.verifyPhone(phoneNumber: phoneNumber) { (firstName, error) in
            if let _ = error {
                // go back to the previous screen
                self.showError(title: "Error", message: "An unknown error occurred. Please try again later.", completionHandler: {
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                // determine message based on whether user info is present
                if let firstName = firstName {
                    self.newUser = false
                    self.verificationLabel.text = "Welcome back \(firstName)! Check your phone for the verification code we just sent you..."
                } else {
                    self.newUser = true
                    let phoneNumberKit = PhoneNumberKit()
                    let formattedPhoneNumber = try! phoneNumberKit.format(phoneNumberKit.parse(self.phoneNumber), toType: .national)
                    self.verificationLabel.text = "We have sent a verification code to \(formattedPhoneNumber). Please enter it below..."
                }
                
                // show the validation code form and hide the loader
                self.hideLoader()
                
                // focus the validation code field
                self.verificationCodeField.becomeFirstResponder()
            }
        }
    }
    
    @objc func submit() {
        if let validationCode = verificationCodeField.text {
            // show the loading animation
            self.showLoader()
            
            if self.newUser {
                // request a registration token
                CliqCardAPI.shared.register(phoneNumber: phoneNumber, code: validationCode) { (registrationToken, error) in
                    if let registrationToken = registrationToken {
                        // create a new account controller
                        let controller = NewAccountController(phoneNumber: self.phoneNumber, registrationToken: registrationToken)
                        // push the controller
                        self.navigationController?.pushViewController(controller, animated: true)
                    } else if let error = error {
                        switch error {
                        case .UnauthorizedError():
                            // display an error message for the wrong token
                            self.showError(title: "Invalid Token", message: "This token does not match the one sent to this phone number.")
                        default:
                            // display an error message
                            self.showError(title: "Error", message: "An unknown error occurred. Please try again later.")
                        }
                        
                        // show the form again
                        self.hideLoader()
                    }
                }
            } else {
                // login to the existing account
                CliqCardAPI.shared.login(phoneNumber: phoneNumber, validationCode: validationCode) { (user, error) in
                    if let _ = user {
                        // hide the loading screen
                        self.hideLoader()
                    } else if let error = error {
                        switch error {
                        case .UnauthorizedError():
                            // display an error message for the wrong token
                            self.showError(title: "Invalid Token", message: "This token does not match the one sent to this phone number.")
                        default:
                            // display an error message
                            self.showError(title: "Error", message: "An unknown error occurred. Please try again later.")
                        }
                        
                        // show the form again
                        self.hideLoader()
                    }
                }
            }
        } else {
            // display an error message
            self.showError(title: "Error", message: "You did not enter a phone number.")
        }
    }

}
