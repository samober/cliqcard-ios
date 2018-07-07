//
//  NewAccountController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class NewAccountController: UIViewController, UITextFieldDelegate {
    
    var phoneNumber: String
    var registrationToken: String
    
    var lastActive: UITextField!
    
    lazy var firstNameField: UITextField! = {
        let view = UITextField()
        view.placeholder = "First name"
        view.autocapitalizationType = .words
        view.autocorrectionType = .no
        view.returnKeyType = .next
        view.enablesReturnKeyAutomatically = true
        
        return view
    }()
    
    lazy var lastNameField: UITextField! = {
        let view = UITextField()
        view.placeholder = "Last name"
        view.autocapitalizationType = .words
        view.autocorrectionType = .no
        view.returnKeyType = .next
        view.enablesReturnKeyAutomatically = true
        
        return view
    }()
    
    lazy var emailField: UITextField! = {
        let view = UITextField()
        view.placeholder = "Email (optional)"
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.returnKeyType = .join
        view.enablesReturnKeyAutomatically = true
        view.keyboardType = .emailAddress
        
        return view
    }()
    
    lazy var submitButton: UIButton! = {
        let view = UIButton(type: .custom)
        view.backgroundColor = UIColor.red
        view.setTitle("Register", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView! = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        return view
    }()
    
    init(phoneNumber: String, registrationToken: String) {
        self.phoneNumber = phoneNumber
        self.registrationToken = registrationToken
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(firstNameField)
        firstNameField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.view.addSubview(lastNameField)
        lastNameField.snp.makeConstraints { make in
            make.top.equalTo(firstNameField.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.view.addSubview(emailField)
        emailField.snp.makeConstraints { make in
            make.top.equalTo(lastNameField.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(64)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(160)
        }
        
        self.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(submitButton)
        }
        
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        
        firstNameField.becomeFirstResponder()
        self.lastActive = firstNameField
    }

    @objc func submit() {
        // get all of the required values
        guard let firstName = firstNameField.text, firstName.count > 0 else {
            self.showError(title: "Error", message: "First name cannot be blank")
            return
        }
        guard let lastName = lastNameField.text, lastName.count > 0 else {
            self.showError(title: "Error", message: "Last name cannot be blank")
            return
        }
        // get optional values
        let email = emailField.text
        
        // show the loading animation
        self.showLoading()
        
        // create the new account
        CliqCardAPI.shared.createAccount(phoneNumber: phoneNumber, token: registrationToken, firstName: firstName, lastName: lastName, email: email) { (account, error) in
            if let _ = account {
                // hide the loading screen
                self.hideLoading()
            } else if let error = error {
                switch error {
                case .InvalidRequestError(let message):
                    // display the error
                    self.showError(title: "Error", message: message)
                case .UnauthorizedError():
                    self.showError(title: "Error", message: "Too much time has passed since you verified this phone number.")
                default:
                    // display an error message
                    self.showError(title: "Error", message: "An unknown error occurred. Please try again later.")
                }
                
                // hide the loading screen
                self.hideLoading()
            }
        }
    }
    
    func showLoading() {
        // hide the submit button
        submitButton.isHidden = true
        // show the activity indicator
        activityIndicator.startAnimating()
        // close editing
        self.view.endEditing(true)
    }
    
    func hideLoading() {
        // show the submit button
        submitButton.isHidden = false
        // hide the activity indicator
        activityIndicator.stopAnimating()
        // bring the keyboard back up
        self.lastActive.becomeFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lastActive = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            self.submit()
        }
        
        return true
    }

}
