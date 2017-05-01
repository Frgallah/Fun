//
//  FunModalControllerDelegate.swift
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

let FunModalControllerTransitionDelegateAssociationKey = "FunModalControllerTransitionDelegateAssociationKey"

public class FunModalControllerDelegate: NSObject {
    
    /**
     Pan gesture for interactive presentation, Not supported yet.
     */
    @IBOutlet weak var panGestureForPresentation: UIPanGestureRecognizer? {
        didSet {
            panGestureForPresentation?.addTarget(self, action: #selector(panGestureForPresentationDidPan(_:)))
        }
    }
    
    /**
     Pan gesture for interactive dismissal.
     */
    @IBOutlet public weak var panGestureForDismissal: UIPanGestureRecognizer? {
        didSet {
            panGestureForDismissal?.addTarget(self, action: #selector(panGestureForDismissalDidPan(_:)))
        }
    }
    
    /**
     Source view controller for interactive presentation, Not supported yet.
     */
    @IBOutlet weak var sourceController:UIViewController?
    
    /**
     Destination view controller.
     */
    @IBOutlet public weak var destinationController:UIViewController? {
        didSet {
            objc_setAssociatedObject(destinationController, UnsafeRawPointer.init(FunModalControllerTransitionDelegateAssociationKey), self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            destinationController?.transitioningDelegate = self
            
        }
        
    }
    
    /**
     Transition Type (enum), default value is set to Push2.
     */
    @IBInspectable public var type: UInt = 0 {
        willSet(newType) {
            if newType < UInt(FunTransitionType.Max.rawValue) {
                transitionType = FunTransitionType(rawValue: Int(newType))!
            } else {
                transitionType = FunTransitionType.ZoomBlur
            }
        }
    }
    
    /**
     Gesture direction, default value is set to direction left to right for Dismissal and right to left for Presentation.
     */
    @IBInspectable public var direction: UInt = 0 {
        willSet(newDirection) {
            if newDirection < UInt(FunGestureDirection.None.rawValue) {
                gestureDismissalDirection = FunGestureDirection(rawValue: Int(newDirection))!
            } else {
                gestureDismissalDirection = FunGestureDirection.LeftToRight
            }
        }
    }
    
    /**
     Gesture dismissal direction (enum), default value is set to direction left to right.
     */
    @IBInspectable var gestureDismissalDirection:FunGestureDirection = .LeftToRight
    
    
    /**
     Transition duration (in seconds), default value is set to 2 seconds.
     */
    @IBInspectable public var duration: Double = 2
    
    public var transitionType: FunTransitionType = .ZoomBlur
    public var transitionBackgroundColor: UIColor = UIColor.black
    
    
    public override init() {
        
        super.init()
        
    }
    
    
    public init(destinationController:UIViewController,transitionType: FunTransitionType) {
        self.destinationController = destinationController
        self.transitionType = transitionType
        super.init()
        destinationController.transitioningDelegate = self
        destinationController.modalPresentationStyle = .fullScreen
        objc_setAssociatedObject(destinationController, UnsafeRawPointer.init(FunModalControllerTransitionDelegateAssociationKey), self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
    
    deinit {
        print("modal delegate has been deinit")
    }
    
    func addInteractiveTo(sourceController:UIViewController,panGesture: UIPanGestureRecognizer?) {
        self.sourceController = sourceController
        var gesture = panGesture
        if gesture == nil {
            gesture = UIPanGestureRecognizer()
            gesture?.delegate = self
            gesture?.maximumNumberOfTouches = 1
        }
        gesture?.addTarget(self, action: #selector(panGestureForPresentationDidPan(_:)))
        sourceController.view.addGestureRecognizer(gesture!)
        panGestureForPresentation = gesture
        
    }
    
    public func addInteractiveToDestinationController(panGesture: UIPanGestureRecognizer?) {
        var gesture = panGesture
        if gesture == nil {
            gesture = UIPanGestureRecognizer()
            gesture?.delegate = self
            gesture?.maximumNumberOfTouches = 1
        }
        gesture?.addTarget(self, action: #selector(panGestureForDismissalDidPan(_:)))
        destinationController?.view.addGestureRecognizer(gesture!)
        panGestureForDismissal = gesture
        
    }
    
    private func removeGestureForDismissalRecognizer() {
        //
    }
    
    @objc private func panGestureForPresentationDidPan(_ gesture: UIPanGestureRecognizer) {
        
        if ((sourceController?.transitionCoordinator) != nil) {
            return
        }
        
        if gesture.state == .began || gesture.state == .changed {
            beginInteractivePresentationTransitionIfPossible(gesture: gesture)
        }
    }
    
    @objc private func panGestureForDismissalDidPan(_ gesture: UIPanGestureRecognizer) {
        
        if ((destinationController?.transitionCoordinator) != nil) {
            return
        }
        
        if gesture.state == .began || gesture.state == .changed {
            beginInteractiveDismissalTransitionIfPossible(gesture: gesture)
        }
        
    }
    
    private func beginInteractivePresentationTransitionIfPossible(gesture: UIPanGestureRecognizer) {
        
        let translation: CGPoint = gesture.translation(in: sourceController?.view)
        guard let toController = destinationController else { return }
        
        if gestureDismissalDirection == .LeftToRight && translation.x < 0.0 {
            
            let _ = sourceController?.present(toController, animated: true, completion: nil)
            
        } else if gestureDismissalDirection == .RightToLeft && translation.x > 0.0 {
            
            let _ = sourceController?.present(toController, animated: true, completion: nil)
            
        } else if gestureDismissalDirection == .TopToBottom && translation.y < 0.0 {
            
            let _ = sourceController?.present(toController, animated: true, completion: nil)
            
        } else if gestureDismissalDirection == .BottomToTop && translation.y > 0.0 {
            
            let _ = sourceController?.present(toController, animated: true, completion: nil)
            
        } else {
            if !translation.equalTo(CGPoint.zero) {
                gesture.isEnabled = false
                gesture.isEnabled = true
            }
        }
        
        destinationController?.transitionCoordinator?.animate(alongsideTransition: nil, completion: { [unowned self] (context) in
            if context.isCancelled && gesture.state == .changed {
                self.beginInteractivePresentationTransitionIfPossible(gesture: gesture)
            }
        })
        
    }
    
    private func beginInteractiveDismissalTransitionIfPossible(gesture: UIPanGestureRecognizer) {
        
        let translation: CGPoint = gesture.translation(in: destinationController?.view)
        guard let presentingController = destinationController?.presentingViewController else { return }
        
        if gestureDismissalDirection == .LeftToRight && translation.x > 0.0 {
            
            presentingController.dismiss(animated: true, completion: nil)
            
        } else if gestureDismissalDirection == .RightToLeft && translation.x < 0.0 {
            
            presentingController.dismiss(animated: true, completion: nil)
            
        } else if gestureDismissalDirection == .TopToBottom && translation.y > 0.0 {
            
            presentingController.dismiss(animated: true, completion: nil)
            
        } else if gestureDismissalDirection == .BottomToTop && translation.y < 0.0 {
            
            presentingController.dismiss(animated: true, completion: nil)
            
        } else {
            if !translation.equalTo(CGPoint.zero) {
                gesture.isEnabled = false
                gesture.isEnabled = true
            }
        }
        
        destinationController?.transitionCoordinator?.animate(alongsideTransition: nil, completion: { [unowned self] (context) in
            if context.isCancelled && gesture.state == .changed {
                self.beginInteractivePresentationTransitionIfPossible(gesture: gesture)
            }
        })
    }
 
}

extension FunModalControllerDelegate : UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension FunModalControllerDelegate : UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return FunAnimatedInteractiveTransitioning.init(transitionType: transitionType, duration: duration, panGestureRecognizer: nil, gestureDirection: nil, backgroundColor: transitionBackgroundColor)
        
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return FunAnimatedInteractiveTransitioning.init(transitionType: transitionType, duration: duration, panGestureRecognizer: nil, gestureDirection: nil, backgroundColor: transitionBackgroundColor)
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        guard let gesture = panGestureForPresentation, gesture.state == .began || gesture.state == .changed else { return nil}
        
        let animatedInteractiveTransitioning = animator as! FunAnimatedInteractiveTransitioning
        animatedInteractiveTransitioning.gestureDirection = gestureDismissalDirection
        animatedInteractiveTransitioning.panGestureRecognizer = gesture
        
        return animatedInteractiveTransitioning
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        guard let gesture = panGestureForDismissal, gesture.state == .began || gesture.state == .changed else { return nil}
        
        let animatedInteractiveTransitioning = animator as! FunAnimatedInteractiveTransitioning
        animatedInteractiveTransitioning.gestureDirection = gestureDismissalDirection
        animatedInteractiveTransitioning.panGestureRecognizer = gesture
        
        return animatedInteractiveTransitioning
        
    }
    
}
