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
    
    lazy var newAccountLabel: UILabel! = {
        let view = UILabel()
        view.text = "Welcome to CliqCard! Enter your name and we can create your account!"
        view.backgroundColor = UIColor.clear
        view.textAlignment = .center
        view.font = UIFont(name: "Lato-Regular", size: 22)
        view.textColor = Colors.darkestGray
        view.numberOfLines = 0
        
        return view
    }()
    
    lazy var firstNameField: SJOTextField! = {
        let view = SJOTextField()
        view.font = UIFont(name: "Lato-Regular", size: 18)
        view.textColor = Colors.darkestGray
        view.placeholder = "First name"
        view.placeholderColor = Colors.gray
        view.autocapitalizationType = .words
        view.autocorrectionType = .no
        view.returnKeyType = .next
        view.enablesReturnKeyAutomatically = true
        
        return view
    }()
    
    lazy var lastNameField: SJOTextField! = {
        let view = SJOTextField()
        view.font = UIFont(name: "Lato-Regular", size: 18)
        view.textColor = Colors.darkestGray
        view.placeholder = "Last name"
        view.placeholderColor = Colors.gray
        view.autocapitalizationType = .words
        view.autocorrectionType = .no
        view.returnKeyType = .next
        view.enablesReturnKeyAutomatically = true
        
        return view
    }()
    
    lazy var submitButton: UIButton! = {
        let view = UIButton(type: .custom)
        view.backgroundColor = Colors.bondiBlue
        view.setTitle("REGISTER", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Lato-Bold", size: 15)
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
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.newAccountLabel)
        self.newAccountLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(64)
            make.right.equalToSuperview().offset(-64)
            make.top.equalToSuperview().offset(120)
        }

        self.view.addSubview(firstNameField)
        firstNameField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(64)
            make.right.equalToSuperview().offset(-64)
            make.top.equalTo(self.newAccountLabel.snp.bottom).offset(48)
        }
        
        self.view.addSubview(lastNameField)
        lastNameField.snp.makeConstraints { make in
            make.top.equalTo(firstNameField.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(64)
            make.right.equalToSuperview().offset(-64)
        }
        
        self.view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(lastNameField.snp.bottom).offset(64)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(160)
        }
        
        self.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(submitButton)
        }
        
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        
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
        
        // show the loading animation
        self.showLoading()
        
        // create the new account
        CliqCardAPI.shared.createAccount(phoneNumber: phoneNumber, token: registrationToken, firstName: firstName, lastName: lastName, email: nil) { (account, error) in
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
            self.submit()
        }
        
        return true
    }

}
