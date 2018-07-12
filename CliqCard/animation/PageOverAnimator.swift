//
//  PageOverAnimator.swift
//  CliqCard
//
//  Created by Sam Ober on 7/12/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import TweenKit

class PageOverPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let scheduler = ActionScheduler()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to), let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let snapshot = toViewController.view.snapshotView(afterScreenUpdates: true) else { return }
        
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.black
        
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapshot)
        
        toViewController.view.frame = finalFrame
        toViewController.view.isHidden = true
        
        snapshot.frame = finalFrame.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        let snapshotFrameAction = InterpolationAction(from: snapshot.frame, to: finalFrame, duration: duration, easing: .exponentialInOut) { [unowned snapshot] in
            snapshot.frame = $0
        }
        
        let fromViewAlphaAction = InterpolationAction(from: 1.0, to: 0.2, duration: duration, easing: .exponentialInOut) { [unowned fromViewController] in
            fromViewController.view.alpha = $0
        }
        
        let fromViewScaleAction = InterpolationAction(from: 1.0, to: 0.9, duration: duration, easing: .exponentialInOut) { [unowned fromViewController] in
            fromViewController.view.transform = CGAffineTransform(scaleX: $0, y: $0)
        }
        
        let animationActions = ActionGroup(actions: snapshotFrameAction, fromViewAlphaAction, fromViewScaleAction)
        
        let completeAction = RunBlockAction {
            toViewController.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        let actionSequence = ActionSequence(actions: animationActions, completeAction)
        
        self.scheduler.run(action: actionSequence)
    }
    
}

class PageOverDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let scheduler = ActionScheduler()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to), let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let snapshot = fromViewController.view.snapshotView(afterScreenUpdates: false) else { return }
        
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.black
        
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        containerView.addSubview(snapshot)
        
        fromViewController.view.isHidden = true
        
        toViewController.view.alpha = 0.2
        toViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        let endFrame = finalFrame.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)
        
        snapshot.frame = finalFrame
        
        let duration = self.transitionDuration(using: transitionContext)
        
        let snapshotFrameAction = InterpolationAction(from: snapshot.frame, to: endFrame, duration: duration, easing: .exponentialInOut) { [unowned snapshot] in
            snapshot.frame = $0
        }
        
        let toViewAlphaAction = InterpolationAction(from: toViewController.view.alpha, to: 1.0, duration: duration, easing: .exponentialInOut) { [unowned toViewController] in
            toViewController.view.alpha = $0
        }
        
        let toViewScaleAction = InterpolationAction(from: 0.9, to: 1.0, duration: duration, easing: .exponentialInOut) { [unowned toViewController] in
            toViewController.view.transform = CGAffineTransform(scaleX: $0, y: $0)
        }
        
        let animationActions = ActionGroup(actions: snapshotFrameAction, toViewAlphaAction, toViewScaleAction)
        
        let completeAction = RunBlockAction {
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        let actionSequence = ActionSequence(actions: animationActions, completeAction)
        
        self.scheduler.run(action: actionSequence)
    }
    
}
