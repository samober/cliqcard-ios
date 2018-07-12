//
//  SlideRightNavigationAnimator.swift
//  CliqCard
//
//  Created by Sam Ober on 7/11/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import pop

class SlideRightNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        container.addSubview(toView)
        
        toView.frame = CGRect(x: -toView.bounds.width, y: fromView.frame.origin.y, width: toView.bounds.width, height: toView.bounds.height)
        toView.layoutIfNeeded()
        
        guard let anim = POPSpringAnimation(propertyNamed: kPOPViewFrame) else { return }
        anim.toValue = fromView.frame
        anim.completionBlock = { (animation, finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        toView.pop_add(anim, forKey: "slide_right")
        
        guard let anim2 = POPSpringAnimation(propertyNamed: kPOPViewFrame) else { return }
        anim2.toValue = CGRect(origin: CGPoint(x: fromView.bounds.width, y: fromView.frame.origin.y), size: fromView.bounds.size)
        fromView.pop_add(anim2, forKey: "slide_right")
    }
    
}
