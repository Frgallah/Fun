//
//  FunTransitionLoader.swift
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

public enum FunTransitionType: Int {
    case ZoomBlur
    case Crystallize
    case CircleSplash
    case CircularScreen
    case Kaleidoscope
    case Max
}


class FunTransitionLoader: NSObject {
    
    class func transitionForType(transitionType: FunTransitionType) -> FunTransitionAnimator! {
        if transitionType == .ZoomBlur {
            return FunZoomBlurTransition()
        }else if transitionType == .Crystallize {
            return FunCrystallizeTransition()
        } else if transitionType == .CircleSplash {
            return FunCircleSplashTransition()
        } else if transitionType == .CircularScreen {
            return FunCircularScreenTransition()
        } else if transitionType == .Kaleidoscope {
            return FunKaleidoscopeTransition()
        } else {
            return FunZoomBlurTransition()
        }
    }
    
}
