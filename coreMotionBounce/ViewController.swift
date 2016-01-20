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
        bounceView.count = 0
        bounceView.removeLabel()
        
        if bounceView.redBlock != nil {
            bounceView.redBlock!.frame = CGRectMake(0 , 0, 40, 40)
            bounceView.redBlock!.backgroundColor = UIColor.redColor()
        }
       
        
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

