//
//  HomeViewController.swift
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

class HomeViewController: UITableViewController {
    
    private var transitions: [String] = Array()
    private var transitionType: FunTransitionType = .ZoomBlur
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitions = ["Zoom Blur","Crystallize","Circle Splash","Circular Screen","Kaleidoscope"]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = transitions[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if index > -1 && index < FunTransitionType.Max.rawValue {
            transitionType = FunTransitionType.init(rawValue: index)!
        } else {
            transitionType = .ZoomBlur
        }
        
        let modalFirstController = storyboard?.instantiateViewController(withIdentifier: "ModalFVC") as! ModalFirstViewController
        modalFirstController.transitionType = transitionType
        self.navigationController?.pushViewController(modalFirstController, animated: true)
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
