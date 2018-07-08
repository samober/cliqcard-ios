//
//  Utils.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import Foundation
import PhoneNumberKit

class Utils {
    
    static let phoneNumberKit = PhoneNumberKit()
    
    class func formatPhoneNumber(phoneNumber: String?) -> String? {
        if let phoneNumber = phoneNumber {
            if let parsedPhoneNumber = try? phoneNumberKit.parse(phoneNumber) {
                return phoneNumberKit.format(parsedPhoneNumber, toType: PhoneNumberFormat.international)
            }
        }
        return nil
    }
    
}
