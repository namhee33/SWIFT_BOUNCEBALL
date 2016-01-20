//
//  ViewController.swift
//  coreMotionBounce
//
//  Created by namhee kim on 1/19/16.
//  Copyright © 2016 namhee kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var bounceView: BouncingViewController!
    
    @IBAction func playBtnPressed(sender: AnyObject) {
        
        bounceView.resetView()
        bounceView.activateMotion()
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        bounceView.animator.addBehavior(bounceView.bouncer)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.Motion.Manager.stopAccelerometerUpdates()
    }
   
}

