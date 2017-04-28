//
//  FunCrystallizeTransition.swift
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


class FunCrystallizeTransition: FunCoreImageTransition {
    
    var firstFilter: CIFilter?
    var secondFilter: CIFilter?
    let minValue: Float = 0.0
    let maxValue: Float = 200.0
    var range: Float = 0
    var rect1: CGRect = CGRect.zero
    var rect2: CGRect = CGRect.zero
    private var firstImage: CIImage?
    private var secondImage: CIImage?
    
    override init() {
        super.init()
    }
    
    deinit {
        print("coreImage Transition has been deinit")
    }
    
    override func setupTranisition(firstImage: CIImage?, secondImageView: UIView) {
        guard let image1 = firstImage else { return }
        guard let filter1 = CIFilter.init(name: "CICrystallize") else { return  }
        filter1.setDefaults()
        filter1.setValue(NSNumber.init(value: minValue), forKey: kCIInputRadiusKey)
        rect1 = image1.extent
        filter1.setValue(CIVector(x: rect1.midX, y: rect1.midY), forKey: kCIInputCenterKey)
        filter1.setValue(image1, forKey: kCIInputImageKey)
        firstFilter = filter1
        self.firstImage = image1
        
        guard let filter2 = CIFilter.init(name: "CICrystallize") else { return  }
        filter2.setDefaults()
        filter2.setValue(NSNumber.init(value: maxValue), forKey: kCIInputRadiusKey)
        
        DispatchQueue.main.async { [unowned self] in
            UIGraphicsBeginImageContextWithOptions(secondImageView.bounds.size, true, 2)
            secondImageView.drawHierarchy(in: secondImageView.bounds, afterScreenUpdates: false)
            let toViewSnapshot: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let image = toViewSnapshot else { return }
            guard let image2 = CIImage.init(image: image) else { return }
            self.rect2 = image2.extent
            filter2.setValue(CIVector(x: self.rect2.midX, y: self.rect2.midY), forKey: kCIInputCenterKey)
            filter2.setValue(image2, forKey: kCIInputImageKey)
            self.secondFilter = filter2
            self.secondImage = image2
        }
        range = maxValue - minValue
        if isInteractive {
            drawingView?.setNeedsDisplay()
        } else {
            startAnimation()
        }
    }
    
    override func updateFirstFilter(fraction: CGFloat) {
        firstFilter?.setValue(filterValue(fracton: Float(fraction)), forKey: kCIInputRadiusKey)
        outputImage = firstFilter?.outputImage
        if let image = outputImage {
            outputImage = image.cropping(to: rect1)
        }
        drawingView?.setNeedsDisplay()
    }
    
    override func updateSecondFilter(fraction: CGFloat) {
        secondFilter?.setValue(filterValue(fracton: Float(fraction)), forKey: kCIInputRadiusKey)
        outputImage = secondFilter?.outputImage
        if let image = outputImage {
            outputImage = image.cropping(to: rect2)
        }
        drawingView?.setNeedsDisplay()
    }
    
    override func updateFirstFilter() {
        outputImage = firstImage
        drawingView?.setNeedsDisplay()
    }
    
    override func updateSecondFilter() {
        outputImage = secondImage
        drawingView?.setNeedsDisplay()
    }
    
    func filterValue(fracton: Float) -> NSNumber {
        return NSNumber.init(value: minValue + range * fracton * 2.0)
    }
    
    override func drawFirstImage() {
        updateFirstFilter()
    }
    
    override func drawSecondImage() {
        updateSecondFilter()
    }
    
    override func endTransition() {
        firstImage = nil
        secondImage = nil
        firstFilter = nil
        secondFilter = nil
        super.endTransition()
    }
    
}
