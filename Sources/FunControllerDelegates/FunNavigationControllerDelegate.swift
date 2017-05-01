//
//  FunNavigationControllerDelegate.swift
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


let FunNavigationControllerTransitionDelegateAssociationKey = "FunNavigationControllerTransitionDelegateAssociationKey"

import UIKit

public class FunNavigationControllerDelegate: NSObject {
    
    /**
     Navigation view controller.
     */
    @IBOutlet public weak var navigationController:UINavigationController? {
        didSet {
            objc_setAssociatedObject(navigationController, UnsafeRawPointer.init(FunNavigationControllerTransitionDelegateAssociationKey), self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.delegate = self
            
            if isInteractive {
                configurePanGestureRecognizer()
            }
        }
    }
    
    // @IBOutlet weak var toViewController:UIViewController?
    
    /**
     Transition Type (enum), default value is set to ZoomBlur.
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
     Gesture direction, default value is set to direction left to right for Pop operation and right to left for Push operation.
     */
    @IBInspectable public var direction: UInt = 0 {
        willSet(newDirection) {
            if newDirection < UInt(FunGestureDirection.None.rawValue) {
                gesturePopDirection = FunGestureDirection(rawValue: Int(newDirection))!
            } else {
                gesturePopDirection = FunGestureDirection.LeftToRight
            }
        }
    }
    
    /**
     Transition duration (in seconds), default value is set to 2 seconds.
     */
    @IBInspectable public var duration: Double = 2.0
    
    /**
     If is Interactive is true it will  make the transition interactive by adding pan gesture to navigation controller view.
     */
    @IBInspectable public var isInteractive: Bool = false {
        willSet(newIsInteractive) {
            if navigationController != nil {
                if newIsInteractive {
                    configurePanGestureRecognizer()
                } else {
                    removeGestureRecognizer()
                }
            }
        }
    }
    
    /**
     Gesture pop direction (enum), default value is set to direction left to right.
     */
    @IBInspectable var gesturePopDirection:FunGestureDirection = .LeftToRight
    
    public var transitionType:FunTransitionType = .ZoomBlur
    
    public var transitionBackgroundColor: UIColor = UIColor.black
    
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer?
    fileprivate var navigationOperation: UINavigationControllerOperation = .none
    
    public override init() {
        super.init()
    }
    
    public init(navigationController: UINavigationController, transitionType: FunTransitionType, isInteractive: Bool) {
        
        self.transitionType = transitionType
        self.isInteractive = isInteractive
        self.navigationController = navigationController
        super.init()
        navigationController.delegate = self
        objc_setAssociatedObject(self.navigationController, UnsafeRawPointer.init(FunNavigationControllerTransitionDelegateAssociationKey), self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        if isInteractive {
            configurePanGestureRecognizer()
        }
        
    }
    
    private func configurePanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer?.delegate = self
        panGestureRecognizer?.maximumNumberOfTouches = 1
        panGestureRecognizer?.addTarget(self, action: #selector(panGestureRecognizerDidPan(_:)))
        navigationController?.view.addGestureRecognizer(panGestureRecognizer!)
        
        guard let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer else { return }
        panGestureRecognizer?.require(toFail: interactivePopGestureRecognizer)
    }
    
    private func removeGestureRecognizer() {
        //
    }
    
    @objc private func panGestureRecognizerDidPan(_ gesture: UIPanGestureRecognizer) {
        if ((navigationController?.transitionCoordinator) != nil) {
            return
        }
        if gesture.state == .began || gesture.state == .changed {
            beginInteractiveTransitionIfPossible(gesture: gesture)
        }
    }
    
    private
    func beginInteractiveTransitionIfPossible(gesture: UIPanGestureRecognizer) {
        
        let translation: CGPoint = gesture.translation(in: navigationController?.view)
        
        if gesturePopDirection == .LeftToRight {
            if translation.x > 0.0 {
                navigationOperation = .pop
                let _ = navigationController?.popViewController(animated: true)
            }/* else if translation.x < 0.0 &&  toViewController != nil {
                 navigationOperation = .push
                 navigationController?.pushViewController(toViewController!, animated: true)
             }*/ else {
                if !translation.equalTo(CGPoint.zero) {
                    gesture.isEnabled = false
                    gesture.isEnabled = true
                }
            }
            
        } else if gesturePopDirection == .RightToLeft {
            if translation.x < 0.0 {
                navigationOperation = .pop
                let _ = navigationController?.popViewController(animated: true)
            }/* else if translation.x > 0.0 &&  toViewController != nil {
                 navigationOperation = .push
                 navigationController?.pushViewController(toViewController!, animated: true)
             }*/ else {
                if !translation.equalTo(CGPoint.zero) {
                    gesture.isEnabled = false
                    gesture.isEnabled = true
                }
            }
        } else if gesturePopDirection == .TopToBottom {
            if translation.y > 0.0 {
                navigationOperation = .pop
                let _ = navigationController?.popViewController(animated: true)
            }/* else if translation.y < 0.0 &&  toViewController != nil {
                 navigationOperation = .push
                 navigationController?.pushViewController(toViewController!, animated: true)
             }*/ else {
                if !translation.equalTo(CGPoint.zero) {
                    gesture.isEnabled = false
                    gesture.isEnabled = true
                }
            }
        } else if gesturePopDirection == .BottomToTop {
            if translation.y < 0.0 {
                navigationOperation = .pop
                let _ = navigationController?.popViewController(animated: true)
            }/* else if translation.y > 0.0 &&  toViewController != nil {
                 navigationOperation = .push
                 navigationController?.pushViewController(toViewController!, animated: true)
             }*/ else {
                if !translation.equalTo(CGPoint.zero) {
                    gesture.isEnabled = false
                    gesture.isEnabled = true
                }
            }
        }
        
        navigationController?.transitionCoordinator?.animate(alongsideTransition: nil, completion: { [unowned self] (context) in
            if context.isCancelled && gesture.state == .changed {
                self.beginInteractiveTransitionIfPossible(gesture: gesture)
            }
        })
        
    }
    
    deinit {
        NSLog(" navigation delegate has been deinit ")
    }
    
}

extension FunNavigationControllerDelegate : UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension FunNavigationControllerDelegate : UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
  
        return FunAnimatedInteractiveTransitioning.init(transitionType: transitionType, duration: duration, panGestureRecognizer: nil, gestureDirection: nil, backgroundColor: transitionBackgroundColor)
        
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        guard let gesture = panGestureRecognizer, gesture.state == .began || gesture.state == .changed else {
            
            return nil
        }
        
        let animatedInteractiveTransitioning = animationController as! FunAnimatedInteractiveTransitioning
        animatedInteractiveTransitioning.gestureDirection = gesturePopDirection
        animatedInteractiveTransitioning.panGestureRecognizer = panGestureRecognizer
        
        return animatedInteractiveTransitioning
        
    }
    
}
