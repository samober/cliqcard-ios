//
//  HomeController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/11/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import pop

class HomeController: UIViewController {
    
    lazy var groupsController: UIViewController! = {
        let controller = GroupsController()
        controller.homeController = self
        let navigationController = SJONavigationController(rootViewController: controller)
        
        return navigationController
    }()
    
    lazy var contactsController: UIViewController! = {
        let controller = ContactsController()
        controller.homeController = self
        let navigationController = SJONavigationController(rootViewController: controller)
        
        return navigationController
    }()
    
    lazy var profileController: UIViewController! = {
        let controller = ProfileController()
        controller.homeController = self
        let navigationController = SJONavigationController(rootViewController: controller)
        
        return navigationController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        self.view.layer.masksToBounds = true

        // add the groups controller
        self.addChildViewController(self.groupsController)
        self.view.addSubview(self.groupsController.view)
        self.groupsController.view.frame = self.view.bounds
        self.groupsController.didMove(toParentViewController: self)
        
        // add the contacts controller
        self.addChildViewController(self.contactsController)
        self.view.addSubview(self.contactsController.view)
        self.contactsController.view.frame = CGRect(x: -self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.contactsController.didMove(toParentViewController: self)
        
        // add the profile controller
        self.addChildViewController(self.profileController)
        self.view.addSubview(self.profileController.view)
        self.profileController.view.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.profileController.didMove(toParentViewController: self)
    }
    
    func showContacts() {
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewFrame) {
            anim.toValue = self.groupsController.view.frame
            self.contactsController.view.pop_add(anim, forKey: "slide_right")
        }
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewFrame) {
            anim.toValue = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.groupsController.view.pop_add(anim, forKey: "slide_right")
        }
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewAlpha) {
            anim.toValue = 0.6
            self.groupsController.view.pop_add(anim, forKey: "alpha")
        }
    }
    
    func showGroupsFromContacts() {
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewFrame) {
            anim.toValue = self.contactsController.view.frame
            self.groupsController.view.pop_add(anim, forKey: "slide_left")
        }
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewFrame) {
            anim.toValue = CGRect(x: -self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.contactsController.view.pop_add(anim, forKey: "slide_left")
        }
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewAlpha) {
            anim.toValue = 1
            self.groupsController.view.pop_add(anim, forKey: "alpha")
        }
    }
    
    func showProfile() {
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewFrame) {
            anim.toValue = self.groupsController.view.frame
            self.profileController.view.pop_add(anim, forKey: "slide_left")
        }
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewFrame) {
            anim.toValue = CGRect(x: -self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.groupsController.view.pop_add(anim, forKey: "slide_left")
        }
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewAlpha) {
            anim.toValue = 0.6
            self.groupsController.view.pop_add(anim, forKey: "alpha")
        }
    }
    
    func showGroupsFromProfile() {
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewFrame) {
            anim.toValue = self.profileController.view.frame
            self.groupsController.view.pop_add(anim, forKey: "slide_right")
        }
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewFrame) {
            anim.toValue = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.profileController.view.pop_add(anim, forKey: "slide_right")
        }
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewAlpha) {
            anim.toValue = 1
            self.groupsController.view.pop_add(anim, forKey: "alpha")
        }
    }

}
