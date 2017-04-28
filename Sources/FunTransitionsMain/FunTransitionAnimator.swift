//
//  FunTransitionAnimator.swift
//  Pods
//
//  Created by Frgallah on 4/11/17.
//
//  Copyright (c) 2017 Mohammed Frgallah. All rights reserved.
//
//  Licensed under the MIT license, can be found at:  https://github.com/Frgallah/Fun/blob/master/LICENSE  or  https://opensource.org/licenses/MIT
//

//  For last updated version of this code check the github page at https://github.com/Frgallah/Fun
//
//

import UIKit


class FunTransitionAnimator: NSObject {
    
    var isInteractive: Bool = false
    var duration: TimeInterval = 0
    var midDuration: CGFloat = 0.5
    fileprivate(set) var defaultDuration = 1.0;
    var backgroundColor: UIColor = UIColor.black
    
    var transitionCompletion: ((Bool) -> ())?

    var fractionComplete: CGFloat = 0
    
       override init() {
        super.init()
    }
    
    func setupTranisition(transitionContext: UIViewControllerContextTransitioning, transitionCompletion: @escaping (Bool) -> ()) {
        
        self.transitionCompletion = transitionCompletion
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView
        var fromView: UIView!
        var toView: UIView!
        
        if transitionContext.responds(to:#selector(transitionContext.view(forKey:))) {
            fromView = transitionContext.view(forKey: .from)
            toView = transitionContext.view(forKey: .to)
        } else {
            fromView = fromViewController?.view
            toView = toViewController?.view
        }
        
        let fromViewFrame = transitionContext.initialFrame(for: fromViewController!)
        let toViewFrame = transitionContext.finalFrame(for: toViewController!)
        
        setupTranisition(containerView: containerView, fromView: fromView, toView: toView, fromViewFrame: fromViewFrame, toViewFrame: toViewFrame)
        
    }
    
    func setupTranisition(containerView: UIView, fromView: UIView, toView: UIView, fromViewFrame:CGRect, toViewFrame:CGRect) {
        
    }
    
    func animateTo(position: UIViewAnimatingPosition, isResume: Bool) {
 
    }
    
}


class FunInterruptibleTransitionAnimator: FunTransitionAnimator {
    
    func startAnimation() {
        
    }
    
    func startAnimation(afterDelay delay: TimeInterval) {
        
    }
    
    func startInteractiveAnimation() {
        
    }
    
    func pauseAnimation() {
        
    }
    
    func updateAnimationTime() {
        
    }
    
}
