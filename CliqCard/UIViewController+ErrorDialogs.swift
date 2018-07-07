//
//  UIViewController+ErrorDialogs.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showError(title: String, message: String) {
        self.showError(title: title, message: message, completionHandler: nil)
    }
    
    func showError(title: String, message: String, completionHandler: (() -> Void)?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completionHandler?()
        }))
        self.present(controller, animated: true, completion: nil)
    }
    
}
