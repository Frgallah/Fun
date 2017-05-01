//
//  FunAnimatedInteractiveTransitioning.swift
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

enum FunGestureDirection: Int {
    case None
    case LeftToRight
    case RightToLeft
    case TopToBottom
    case BottomToTop
}



class FunAnimatedInteractiveTransitioning: NSObject {
    fileprivate var initiallyInteractive = false
    private let transitionType: FunTransitionType
    fileprivate var duration: TimeInterval = 0
    var panGestureRecognizer: UIPanGestureRecognizer? {
        didSet {
            panGestureRecognizer?.addTarget(self, action: #selector(updateInteractionFor(gesture:)))
            initiallyInteractive = true
        }
    }
    var transitionBackgroundColor: UIColor = UIColor.black {
        willSet {
            transition.backgroundColor = newValue
        }
    }
    var gestureDirection: FunGestureDirection?
    fileprivate var context: UIViewControllerContextTransitioning?
    var transition: FunTransitionAnimator!
    fileprivate var initialTranslation =  CGPoint.zero
    private var lastPercentage: CGFloat = 0
    
    init(transitionType: FunTransitionType, duration:TimeInterval, panGestureRecognizer:UIPanGestureRecognizer?, gestureDirection: FunGestureDirection?, backgroundColor: UIColor?) {
        self.transitionType = transitionType
        self.gestureDirection = gestureDirection
        if let color = backgroundColor {
            self.transitionBackgroundColor = color
        }
        
        super.init()
        transition = FunTransitionLoader.transitionForType(transitionType: transitionType)
        transition.duration = duration > 0 ? duration : transition.defaultDuration
        self.duration = transition.duration
        
        if let gesture = panGestureRecognizer {
            gesture.addTarget(self, action: #selector(updateInteractionFor(gesture:)))
            self.panGestureRecognizer = gesture
            self.initiallyInteractive = true
            
        }
        
    }
    
    deinit {
        NSLog(" AnimatedInteractiveTransitioning has been deinit ")
    }
    
    @objc private func updateInteractionFor(gesture: UIPanGestureRecognizer)
    {
        switch gesture.state {
        case .began: break
            
        case .changed:
            let percentage = percentFor(gesture: gesture)
            if percentage < 0.0 {
                context?.cancelInteractiveTransition()
                panGestureRecognizer?.removeTarget(self, action: #selector(updateInteractionFor(gesture:)))
                
            } else {
                transition.fractionComplete = percentage
                context?.updateInteractiveTransition(percentage)
                
            }
            
        case .ended:
            lastPercentage = 0
            endInteraction()
            
        default:
            context?.cancelInteractiveTransition()
        }
        
        
    }
    
    private func percentFor(gesture: UIPanGestureRecognizer) -> CGFloat {
        
        guard let containerView = context?.containerView else {
            return lastPercentage
        }
        let translation: CGPoint = gesture.translation(in: containerView)
        var percentage:CGFloat = 0.0
        if gestureDirection == .LeftToRight && translation.x > 0.0 {
            if initialTranslation.x < 0.0 {
                percentage = -1.0
            } else {
                percentage = translation.x/(containerView.bounds.width)
            }
        } else if gestureDirection == .RightToLeft && translation.x < 0.0 {
            if initialTranslation.x > 0.0 {
                percentage = -1.0
            } else {
                percentage = -1.0 * (translation.x/(containerView.bounds.width))
            }
        } else if gestureDirection == .TopToBottom && translation.y > 0.0 {
            if initialTranslation.y < 0.0 {
                percentage = -1.0
            } else {
                percentage = translation.y/(containerView.bounds.height)
            }
        } else if gestureDirection == .BottomToTop && translation.y < 0.0 {
            if initialTranslation.y > 0.0 {
                percentage = -1.0
            } else {
                percentage = -1.0 * (translation.y/(containerView.bounds.height))
            }
        }
        lastPercentage = percentage
        return percentage
    }
    
    private func completionPosition() -> UIViewAnimatingPosition {
        if transition.fractionComplete < transition.midDuration {
            return .start;
        } else {
            return .end;
        }
    }
    
    private func endInteraction() {
        
        guard let transitiContext = context , transitiContext.isInteractive else { return }
        let position = completionPosition()
        if position == .end {
            transitiContext.finishInteractiveTransition()
        } else {
            transitiContext.cancelInteractiveTransition()
        }
        
        transition.animateTo(position: position, isResume: true)
        
    }
    
    private func transitionAnimator() -> FunTransitionAnimator {
        if transition == nil {
            return FunTransitionLoader.transitionForType(transitionType: transitionType)
            
        } else {
            return transition
        }
    }
    
    
}

extension FunAnimatedInteractiveTransitioning : UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transition.setupTranisition(transitionContext: transitionContext, transitionCompletion: {
            (completed) in
            transitionContext.completeTransition(completed)
        })
        transition.animateTo(position: .end, isResume: false)
        
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        transition = nil
    }
    
}

extension FunAnimatedInteractiveTransitioning : UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        context = transitionContext
        initialTranslation = (panGestureRecognizer?.translation(in: transitionContext.containerView))!
        transition.isInteractive = true
        transition.setupTranisition(transitionContext: transitionContext, transitionCompletion: { (completed) in
            transitionContext.completeTransition(completed)
        })
        
    }
    
    var wantsInteractiveStart: Bool {
        
        return initiallyInteractive
    }
    
}
