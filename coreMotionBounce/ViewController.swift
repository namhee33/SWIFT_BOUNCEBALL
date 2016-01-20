//
//  ViewController.swift
//  coreMotionBounce
//
//  Created by namhee kim on 1/19/16.
//  Copyright © 2016 namhee kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CancelProtocol, DoneProtocol{
    
    @IBOutlet weak var bounceView: BouncingViewController!
    var gameLevel = 1
    
    @IBAction func playBtnPressed(sender: AnyObject) {
        bounceView.gameLevel = gameLevel
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let controller = navigationController.topViewController as! SettingViewController
        controller.CancelDelegate = self
        controller.DoneDelegate = self
   
    }
    
    func cancelSetting(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func settingInfo(level: Int) {
        gameLevel = level
        print("gameLevel: ", level)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

