//
//  FunCoreImageTransition.swift
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
import GLKit


class FunCoreImageTransition : FunInterruptibleTransitionAnimator {
    
    var currentDuration: TimeInterval = 0
    var timerElapsedTime: TimeInterval = 0
    var startTime:TimeInterval = 0.0
    var baseFraction:Double = 0
    var outputImage: CIImage?
    var timer: CADisplayLink?
    var drawingView: GLKView?
    var drawingContext: CIContext?
    private var secondView: UIView?
    private var isRunning: Bool = false
    private var isReversed: Bool = false
    private var percentage: CGFloat = 0
    private var fractions: CGFloat = 0 {
        willSet {
            updateFilter(fraction: fractions)
        }
    }
    
    override var fractionComplete: CGFloat {
        get {
            return fractions
        }
        set(newFractionComplete) {
            fractions = newFractionComplete
        }
    }
    
    override init() {
        super.init()
        
    }
    
    override func setupTranisition(containerView: UIView, fromView: UIView, toView: UIView, fromViewFrame:CGRect, toViewFrame:CGRect) {
        
        fromView.frame = fromViewFrame
        toView.frame = toViewFrame
        containerView.addSubview(toView)
        secondView = toView
        
        var fromViewSnapshot: UIImage?
        //    var toViewSnapshot: UIImage?
        
        UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, true, (containerView.window?.screen.scale)!)
        fromView.drawHierarchy(in: fromView.bounds, afterScreenUpdates: false)
        fromViewSnapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var firstImage: CIImage?
        
        if let image = fromViewSnapshot {
            firstImage = CIImage.init(image: image)
        }
        let context: EAGLContext = EAGLContext.init(api: .openGLES2)
        let drawingView: GLKView = GLKView.init(frame: containerView.bounds, context: context)
        drawingView.contentScaleFactor = 1
        drawingView.enableSetNeedsDisplay = true
        drawingView.delegate = self
        EAGLContext.setCurrent(context)
        let drawingContext: CIContext = CIContext.init(eaglContext: context)
        containerView.addSubview(drawingView)
        
        self.drawingView = drawingView
        self.drawingContext = drawingContext
        outputImage = firstImage
        
        setupTranisition(firstImage: firstImage, secondImageView: toView)
        
    }
    
    func setupTranisition(firstImage: CIImage?, secondImageView: UIView) {
        
        
    }
    
    func updateFilter(fraction: CGFloat) {
        if fraction < 0.5 {
            updateFirstFilter(fraction: fraction)
        } else {
            updateSecondFilter(fraction: 0.5 - (fraction - 0.5))
        }
    }
    
    func updateFirstFilter(fraction: CGFloat) {
        
    }
    
    func updateSecondFilter(fraction: CGFloat) {
        
    }
    
    func updateFirstFilter() {
        
    }
    
    func updateSecondFilter() {
        
    }
    
    func endTransition() {
        drawingView = nil
        drawingContext = nil
        outputImage = nil
        timer = nil
    }
    
    
    func startAnimationAfterDelay() {
        startAnimation()
    }
    
    func stopTimer(isAnimationEnded: Bool) {
        isRunning = false
        timer?.isPaused = true
        timer?.invalidate()
        timerElapsedTime = 0
        if !isAnimationEnded {
            secondView?.removeFromSuperview()
        }
        drawingView?.removeFromSuperview()
        if let completion = transitionCompletion {
            completion(isAnimationEnded)
            
            endTransition()
            
        }
        
    }
    
    func timerForAnimation(isInterruptible: Bool, isReversed: Bool) -> CADisplayLink {
        if isInterruptible {
            if isReversed {
                
                let displaylink = CADisplayLink(target: self, selector: #selector(updateInterruptibleReversedTransition))
                displaylink.preferredFramesPerSecond = 10
                startTime = CACurrentMediaTime()
                displaylink.add(to: .current, forMode: .defaultRunLoopMode)
                return displaylink
                
            } else {
                
                let displaylink = CADisplayLink(target: self, selector: #selector(updateInterruptibleTransition))
                displaylink.preferredFramesPerSecond = 10
                startTime = CACurrentMediaTime()
                displaylink.add(to: .current, forMode: .defaultRunLoopMode)
                return displaylink
                
            }
        } else {
            if isReversed {
                
                let displaylink = CADisplayLink(target: self, selector: #selector(updateNonInterruptibleReversedTransition))
                displaylink.preferredFramesPerSecond = 10
                startTime = CACurrentMediaTime()
                displaylink.add(to: .current, forMode: .defaultRunLoopMode)
                return displaylink
                
            } else {
                
                let displaylink = CADisplayLink(target: self, selector: #selector(updateNonInterruptibleTransition))
                displaylink.preferredFramesPerSecond = 10
                startTime = CACurrentMediaTime()
                displaylink.add(to: .current, forMode: .defaultRunLoopMode)
                return displaylink
                
            }
        }
    }
    
    func updateNonInterruptibleTransition() {
        guard isRunning else {
            return }
        timerElapsedTime = (timer?.timestamp)! - startTime
        if timerElapsedTime > currentDuration {
            percentage = 1
            updateSecondFilter()
            stopTimer(isAnimationEnded: true)
            
        } else {
            percentage = CGFloat(timerElapsedTime / currentDuration)
            updateFilter(fraction: percentage)
            
        }
    }
    
    func updateNonInterruptibleReversedTransition() {
        guard isRunning else {
            return }
        timerElapsedTime -= (timer?.targetTimestamp)! - startTime
        if timerElapsedTime < 0 {
            percentage = 0
            updateFirstFilter()
            stopTimer(isAnimationEnded: false)
        } else {
            percentage = CGFloat(timerElapsedTime / currentDuration)
            updateFilter(fraction: percentage)
        }
    }
    
    func updateInterruptibleTransition() {
        guard isRunning else {
            return }
        timerElapsedTime += (timer?.targetTimestamp)! - startTime
        if timerElapsedTime > duration {
            percentage = 1
            updateSecondFilter()
            stopTimer(isAnimationEnded: true)
        } else {
            percentage = CGFloat(timerElapsedTime / duration)
            if percentage > 1 {
                percentage = 1
                updateSecondFilter()
                stopTimer(isAnimationEnded: true)
            } else {
                updateFilter(fraction: percentage)
            }
        }
    }
    
    func updateInterruptibleReversedTransition() {
        guard isRunning else {
            return }
        timerElapsedTime -= (timer?.targetTimestamp)! - startTime
        if timerElapsedTime < 0 {
            percentage = 0
            updateFirstFilter()
            stopTimer(isAnimationEnded: false)
        } else {
            percentage = CGFloat(timerElapsedTime / duration)
            if percentage < 0 {
                percentage = 0
                updateFirstFilter()
                stopTimer(isAnimationEnded: false)
            } else {
                updateFilter(fraction: percentage)
            }
        }
    }
    
    override func startAnimation() {
        isRunning = true
        currentDuration = duration
        if isReversed {
            timerElapsedTime = currentDuration
            timer = timerForAnimation(isInterruptible: false, isReversed: true)
            
        } else {
            timerElapsedTime = 0
            timer = timerForAnimation(isInterruptible: false, isReversed: false)
            
        }
    }
    
    override func startAnimation(afterDelay delay: TimeInterval) {
        perform(#selector(startAnimationAfterDelay), with: nil, afterDelay: delay)
    }
    
    override func startInteractiveAnimation() {
        pauseAnimation()
    }
    
    override func pauseAnimation() {
        stopTimer(isAnimationEnded: false)
    }
    
    override func animateTo(position: UIViewAnimatingPosition, isResume: Bool) {
        isReversed = position == .start
        if isResume {
            resumeAnimation()
        } else {
            startAnimation()
        }
        
    }
    
    func resumeAnimation() {
        isRunning = true
        if isReversed {
            baseFraction = Double(fractions)
            currentDuration = baseFraction * duration
            timerElapsedTime = currentDuration
            timer = timerForAnimation(isInterruptible: true, isReversed: true)
            
        } else {
            baseFraction = Double(fractions)
            currentDuration = (1.0 - baseFraction) * duration
            timerElapsedTime = baseFraction * duration
            timer = timerForAnimation(isInterruptible: true, isReversed: false)
            
        }
    }
    
    override func updateAnimationTime() {
        
        
    }
    
    func stopAnimation(_ withoutFinishing: Bool) {
        //
        
    }
    
    func drawFirstImage() {
        
    }
    
    func drawSecondImage() {
        
    }

}

extension FunCoreImageTransition : GLKViewDelegate {
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        if let image = outputImage {
            
            if let context = drawingContext {
                context.draw(image, in: rect, from: image.extent)
            }
        }
        
    }

}
