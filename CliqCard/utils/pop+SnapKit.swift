//
//  pop+SnapKit.swift
//  CliqCard
//
//  Created by Sam Ober on 7/11/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import Foundation
import pop
import SnapKit

public extension Constraint {
    
//    public var layoutConstraint: LayoutConstraint? {
//        return layoutConstraints?.first
//    }
//    
//    public var layoutConstraints: [LayoutConstraint]? {
//        return _valueForKey(key: "layoutConstraints", self) as? [LayoutConstraint]
//    }
    
}

private func _valueForKey(key: String, _ fromObject: AnyObject) -> AnyObject? {
    guard let ivar = class_getInstanceVariable(type(of: fromObject), key) else { return nil }
    return object_getIvar(fromObject, ivar) as AnyObject?
}
