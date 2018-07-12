//
//  EnterJoinCodeController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/8/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import SwiftSpinner

class EnterJoinCodeController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    var callback: (CCGroup) -> Void
    
    lazy var codeField: SJOTextField! = {
        let view = SJOTextField()
        view.borderStyle = .none
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 32)
        view.textAlignment = .center
        view.placeholder = "Enter Code"
        view.placeholderColor = Colors.gray
        view.textColor = Colors.darkestGray
        view.returnKeyType = .done
        view.enablesReturnKeyAutomatically = true
        
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView! = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        return view
    }()
    
    init(callback: @escaping (CCGroup) -> Void) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        self.title = "Join Group"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        self.view.addSubview(self.codeField)
        self.codeField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.codeField.delegate = self
        self.codeField.addTarget(self, action: #selector(codeChanged), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.codeField.becomeFirstResponder()
    }
    
    @objc func cancel() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func codeChanged() {
        if let code = self.codeField.text {
            self.codeField.text = code.uppercased()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // get the code
        guard let code = self.codeField.text, code.count == 6 else {
            self.showError(title: "Invalid Code", message: "A valid join code must have exactly 6 characters.")
            return false
        }
        
        // get the sharing details
        let controller = GroupSharingController { (phoneIds, emailIds) in
            // dismiss share controller
            self.dismiss(animated: false, completion: nil)
            // show the activity indicator
            SwiftSpinner.show("Joining group...")
            // end editing
            self.view.endEditing(true)
            
            // try to join the group
            CliqCardAPI.shared.joinGroup(code: code, phoneIds: phoneIds, emailIds: emailIds) { (group, error) in
                SwiftSpinner.hide({
                    if let group = group {
                        // callback
                        self.callback(group)
                        // dismiss
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        // display error message
                        self.showError(title: "Error", message: "An unknown error occurred.") { () -> Void in
                            self.codeField.becomeFirstResponder()
                        }
                    }
                })
            }
        }
        let navigationController = SJONavigationController(rootViewController: controller)
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
        
        return false
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverPresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverDismissAnimator()
    }

}
