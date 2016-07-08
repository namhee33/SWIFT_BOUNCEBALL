//
//  ViewController.swift
//  coreMotionBounce
//
//  Created by namhee kim on 1/19/16.
//  Copyright © 2016 namhee kim. All rights reserved.
//

import UIKit
import AVFoundation

class BouncingViewController: UIView, UICollisionBehaviorDelegate {
    var count = 0
    var collision: UICollisionBehavior!
    let bouncer = BouncingBall()
    lazy var animator: UIDynamicAnimator = {UIDynamicAnimator(referenceView: self)}()
    var redBlock: UIView?
    var audioPlayer = AVAudioPlayer()
    var gameLevel = 1
    var barrier: UIView?
    var block: UIView?
    var btxtField: UILabel?
    
    
    func addLabel(){
        if let viewWithTag = self.viewWithTag(135){
            //            viewWithTag.removeFromSuperview()
            viewWithTag.hidden = false
        }else{
            let txtField: UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.maxX-15, self.frame.maxY-10));
            txtField.text = "Game Over"
            
            if gameLevel == 1 {
                txtField.textColor = UIColor.whiteColor()
                txtField.backgroundColor = UIColor.redColor()
            }else{
                print("gameLevel 2. transparent background color")
                txtField.textColor = UIColor.redColor()
                txtField.backgroundColor = UIColor(white: 1, alpha: 0.5)
            }
           
//            txtField.font = UIFont(name: "System", size: 40)
            txtField.font = UIFont(name: "System", size: 20.0)
//            txtField.alignmentRectInsets()
            txtField.textAlignment = NSTextAlignment.Center
            txtField.tag = 135
            self.addSubview(txtField)
        }
    }
    
    func addBalancedText(){
        if let viewWithTag = self.viewWithTag(235){
            viewWithTag.hidden = false
        }else{
            let bx = ((self.frame.maxX - self.frame.minX)/2.0) - 3.0
            let by = ((self.frame.maxY-self.frame.minY)/2.0) - 3.0
            btxtField = UILabel(frame: CGRectMake(bx,by, 100, 30))
            btxtField!.text = "Balanced!"
            btxtField!.textColor = UIColor.redColor()
            btxtField!.backgroundColor = UIColor.whiteColor()
            btxtField!.font = UIFont(name: "System", size: 10.0)
            btxtField!.tag = 235
            self.addSubview(btxtField!)
            
           
           
        }
    }
    
    func removeLabel(){
        if let viewWithTag = self.viewWithTag(135){
//            viewWithTag.removeFromSuperview()
            viewWithTag.hidden = true
        }
    }
    
    struct Constants {
        static let BlockSize = CGSize(width: 40, height: 40)
    }
    
    func addBlock() -> UIView {
        block = UIView(frame: CGRect(origin:  CGPoint.zero, size: Constants.BlockSize))
        block!.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        self.addSubview(block!)
        collision = UICollisionBehavior(items: [block!])
        collision.collisionDelegate = self
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        return block!
    }
    
    func addBarrior() -> UIView{
        
        print("add one more barrier")
        if barrier == nil {
            barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
            barrier!.backgroundColor = UIColor.grayColor()
            self.addSubview(barrier!)
        }
        animator.removeBehavior(collision)
        collision = UICollisionBehavior(items: [block!])
        collision.addBoundaryWithIdentifier("barrier", forPath: UIBezierPath(rect: barrier!.frame))
        collision.collisionDelegate = self
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        return barrier!
    }
    
    
    func resetView(){
    
        count = 0
        removeLabel()
        
        if redBlock != nil {
            redBlock!.frame = CGRectMake(0 , 0, 40, 40)
            redBlock!.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.05)
            redBlock!.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        }
        
        if barrier != nil {
            barrier!.frame = CGRectMake(0 , 300, 130, 20)
            barrier!.backgroundColor = UIColor.grayColor()
        }
    }
    
    func activateMotion(){
        var wait_count = 0
        print("gameLevel: ", gameLevel)
        if redBlock == nil {
            redBlock = addBlock()
            redBlock?.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.05)
            bouncer.addBlock(redBlock!)
        }
        if gameLevel == 2 {
            barrier = addBarrior()
        }
        
        let motionManager = AppDelegate.Motion.Manager
        if motionManager.accelerometerAvailable {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue())
                { (data, error) -> Void in
                    self.bouncer.gravity.gravityDirection = CGVector(dx: data!.acceleration.x, dy: -data!.acceleration.y)
                    
                   let min = 0.00000001
                    let max = 0.005
                    let curr_x = data!.acceleration.x
                    let curr_y = data!.acceleration.y
                    
                    if min < fabs(curr_x) && fabs(curr_x) < max && min < fabs(curr_y) && fabs(curr_y) < max  {
                        print("acceleration X, acceleration Y: ", data!.acceleration.x, data!.acceleration.y)
                        self.addBalancedText()
                        
                    }else{
                        wait_count++
                        if self.btxtField != nil && wait_count >= 5 {
                        
                            self.btxtField?.hidden = true
                            wait_count = 0
                        }
                    }
                    
                }
        }

    }
    

    func playSound(){
        AudioServicesPlaySystemSound(1051)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        var maxCount = 1
        
        if gameLevel == 1 {
            maxCount = 18
        }else{
            maxCount = 20
        }
        
        if count < maxCount {
            playSound()
            count++

            redBlock?.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.05 * CGFloat(count))
            if gameLevel == 1 {
                redBlock?.frame = CGRectMake((redBlock?.frame.minX)!, (redBlock?.frame.minY)!, (redBlock?.frame.width)! * 1.2, (redBlock?.frame.height)! * 1.2)
            }
            
        }else {
            
            redBlock!.frame = CGRectMake(0, 0, 0, 0)
            if barrier != nil {
                    barrier!.frame = CGRectMake(0, 0, 0, 0)
            }
            
            addLabel()
            print("Game Over")
            AppDelegate.Motion.Manager.stopAccelerometerUpdates()
        }
        print("count", count)
    }
}


