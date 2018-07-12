//
//  GroupSharingController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/12/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit

class GroupSharingController: UIViewController {
    
    var phoneIds: [Int] = []
    var emailIds: [Int] = []
    
    var callback: ([Int], [Int]) -> Void
    
    lazy var messageLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont(name: "Lato-Regular", size: 22)
        view.textColor = Colors.darkestGray
        view.text = "What would you like to share?"
        view.textAlignment = .center
        
        return view
    }()
    
    lazy var phonesStack: UIStackView! = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = UIStackViewDistribution.equalSpacing
        view.alignment = UIStackViewAlignment.fill
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var emailsStack: UIStackView! = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = UIStackViewDistribution.equalSpacing
        view.alignment = UIStackViewAlignment.fill
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var submitButton: UIButton! = {
        let view = UIButton()
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.setBackgroundImage(UIImage(color: Colors.bondiBlue), for: .normal)
        view.setTitle("SUBMIT", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Lato-Bold", size: 15)
        
        return view
    }()
    
    lazy var mainStack: UIStackView! = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = UIStackViewDistribution.equalSpacing
        view.alignment = UIStackViewAlignment.fill
        view.spacing = 48
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(callback: @escaping ([Int], [Int]) -> Void) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(phoneIds: [Int], emailIds: [Int], callback: @escaping ([Int], [Int]) -> Void) {
        self.init(callback: callback)
        self.phoneIds = phoneIds
        self.emailIds = emailIds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

//        self.title = "Share"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        // get the current user
        guard let currentUser = CliqCardAPI.shared.currentUser else { return }
        
        for phone in currentUser.phones {
            // create an information select view
            let view = InformationSelectView()
            view.typeLabel.text = phone.type
            view.valueLabel.text = phone.number
            // tag this view with the phone id
            view.tag = phone.identifier
            // check if already selected
            if self.phoneIds.contains(view.tag) {
                view.isSelected = true
            }
            // add a tap recognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePhoneTap(sender:)))
            view.addGestureRecognizer(tapGesture)
            view.isUserInteractionEnabled = true
            // add to the phones stack
            self.phonesStack.addArrangedSubview(view)
        }
        
        for email in currentUser.emails {
            // create an information select view
            let view = InformationSelectView()
            view.typeLabel.text = email.type
            view.valueLabel.text = email.address
            // tag this view with the email id
            view.tag = email.identifier
            // check if already selected
            if self.emailIds.contains(view.tag) {
                view.isSelected = true
            }
            // add a tap recognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEmailTap(sender:)))
            view.addGestureRecognizer(tapGesture)
            view.isUserInteractionEnabled = true
            // add to the emails stack
            self.emailsStack.addArrangedSubview(view)
        }
        
        // add the message label
        self.mainStack.addArrangedSubview(self.messageLabel)
        
        // add the phones and emails to the main stack
        self.mainStack.addArrangedSubview(self.phonesStack)
        self.mainStack.addArrangedSubview(self.emailsStack)
        
        // setup the submit button
        self.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        self.submitButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(160)
        }
        self.mainStack.addArrangedSubview(self.submitButton)
        
        // add the stack to the view
        self.view.addSubview(self.mainStack)
        self.mainStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.left.right.equalToSuperview()
        }
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func submit() {
        if self.phoneIds.count + self.emailIds.count == 0 {
            self.showError(title: "Error", message: "You have to select at least one item to share to be a part of a group.")
            return
        }
        
        // call the callback
        self.callback(self.phoneIds, self.emailIds)
    }
    
    @objc func handlePhoneTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let view = sender.view as? InformationSelectView else { return }
            view.isSelected = !view.isSelected
            if view.isSelected {
                self.phoneIds.append(view.tag)
            } else if let index = self.phoneIds.index(of: view.tag) {
                self.phoneIds.remove(at: index)
            }
        }
    }
    
    @objc func handleEmailTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let view = sender.view as? InformationSelectView else { return }
            view.isSelected = !view.isSelected
            if view.isSelected {
                self.emailIds.append(view.tag)
            } else if let index = self.emailIds.index(of: view.tag) {
                self.emailIds.remove(at: index)
            }
        }
    }

}
