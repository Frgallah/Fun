//
//  ModalFirstViewController.swift
//  Fun
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
import Fun

class ModalFirstViewController: UIViewController {
    
    var transitionType: FunTransitionType = .ZoomBlur

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
    }

    @IBAction func back(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMSVC" {
            let destinationController = segue.destination
            destinationController.modalPresentationStyle = .fullScreen
            let controllerDelegate = FunModalControllerDelegate.init(destinationController: destinationController, transitionType: transitionType)
            controllerDelegate.addInteractiveToDestinationController(panGesture: nil)
            controllerDelegate.duration = 2
            controllerDelegate.transitionBackgroundColor = .black
            
        }
        
    }

}
