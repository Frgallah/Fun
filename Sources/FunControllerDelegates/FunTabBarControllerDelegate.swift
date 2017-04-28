//
//  FunTabBarControllerDelegate.swift
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

let FunTabBarControllerTransitionDelegateAssociationKey = "FunTabBarControllerTransitionDelegateAssociationKey"

public class FunTabBarControllerDelegate: NSObject {
    
    /**
     TabBar view controller.
     */
    @IBOutlet public weak var tabBarController:UITabBarController? {
        didSet {
            objc_setAssociatedObject(tabBarController, UnsafeRawPointer.init(FunTabBarControllerTransitionDelegateAssociationKey), self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            tabBarController?.delegate = self
            
            if isInteractive {
                configurePanGestureRecognizer()
            }
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
     Gesture direction, default value is set to direction left to right for left tab and right to left for right tab.
     */
    @IBInspectable public var direction: UInt = 0 {
        willSet(newDirection) {
            if newDirection < UInt(FunGestureDirection.None.rawValue) {
                gestureDirection = FunGestureDirection(rawValue: Int(newDirection))!
            } else {
                gestureDirection = FunGestureDirection.LeftToRight
            }
        }
    }

    /**
     Transition duration (in seconds), default value is set to 2 seconds.
     */
    @IBInspectable public var duration: Double = 2.0
    
    /**
     If is Interactive is true it will  make the transition interactive by adding pan gesture to tabBar controller view.
     */
    @IBInspectable public var isInteractive: Bool = false {
        willSet(newIsInteractive) {
            if tabBarController != nil {
                if newIsInteractive {
                    configurePanGestureRecognizer()
                } else {
                    removeGestureRecognizer()
                }
            }
        }
    }
    
    public var transitionType: FunTransitionType = .ZoomBlur
    public var transitionBackgroundColor: UIColor = UIColor.black
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer?
    fileprivate var gestureDirection: FunGestureDirection = .LeftToRight
    
    public override init() {
        super.init()
    }
    
    public init(tabBarController: UITabBarController, transitionType: FunTransitionType, isInteractive: Bool) {
        self.tabBarController = tabBarController
        self.transitionType = transitionType
        self.isInteractive = isInteractive
        super.init()
        tabBarController.delegate = self
        objc_setAssociatedObject(tabBarController, UnsafeRawPointer.init(FunTabBarControllerTransitionDelegateAssociationKey), self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        if isInteractive {
            configurePanGestureRecognizer()
        }
        
    }
    
    deinit {
        NSLog(" tabBar delegate has been deinit ")
    }
    
    func configurePanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer?.delegate = self
        panGestureRecognizer?.maximumNumberOfTouches = 1
        panGestureRecognizer?.addTarget(self, action: #selector(panGestureRecognizerDidPan(_:)))
        tabBarController?.view.addGestureRecognizer(panGestureRecognizer!)
        
    }
    
    func removeGestureRecognizer() {
        //
    }
    
    func panGestureRecognizerDidPan(_ gesture: UIPanGestureRecognizer) {
        
        if ((tabBarController?.transitionCoordinator) != nil) {
            return
        }
        
        if gesture.state == .began || gesture.state == .changed {
            beginInteractiveTransitionIfPossible(gesture: gesture)
        }
    }
    
    func beginInteractiveTransitionIfPossible(gesture: UIPanGestureRecognizer) {
        
        let translation: CGPoint = gesture.translation(in: tabBarController!.view)
        if translation.x > 0.0 && (tabBarController?.selectedIndex)! > 0 {
            gestureDirection = .LeftToRight
            tabBarController?.selectedIndex -= 1
        } else if translation.x < 0.0 && (tabBarController?.selectedIndex)! + 1 < (tabBarController?.viewControllers?.count)!{
            gestureDirection = .RightToLeft
            tabBarController?.selectedIndex += 1
        } else {
            if !translation.equalTo(CGPoint.zero) {
                gesture.isEnabled = false
                gesture.isEnabled = true
            }
        }
        tabBarController?.transitionCoordinator?.animate(alongsideTransition: nil, completion: { [unowned self] (context) in
            if context.isCancelled && gesture.state == .changed {
                self.beginInteractiveTransitionIfPossible(gesture: gesture)
            }
        })
        
    }
    
}

extension FunTabBarControllerDelegate : UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension FunTabBarControllerDelegate : UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return FunAnimatedInteractiveTransitioning.init(transitionType: transitionType, duration: duration, panGestureRecognizer: nil, gestureDirection: nil, backgroundColor: transitionBackgroundColor)
        
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let gesture = panGestureRecognizer, gesture.state == .began || gesture.state == .changed else {
            return nil
        }
        
        let animatedInteractiveTransitioning = animationController as! FunAnimatedInteractiveTransitioning
        animatedInteractiveTransitioning.gestureDirection = gestureDirection
        animatedInteractiveTransitioning.panGestureRecognizer = panGestureRecognizer
        
        return animatedInteractiveTransitioning
        
    }
    
    
}

