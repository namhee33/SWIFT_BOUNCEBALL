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
    
    
    
    func addLabel(){
        if let viewWithTag = self.viewWithTag(135){
            //            viewWithTag.removeFromSuperview()
            viewWithTag.hidden = false
        }else{
            let txtField: UILabel = UILabel(frame: CGRectMake(0, 0, 150.00, 300.00));
            txtField.text = "Game Over"
            txtField.backgroundColor = UIColor.whiteColor()
            txtField.tag = 135
            self.addSubview(txtField)
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
        let block = UIView(frame: CGRect(origin:  CGPoint.zero, size: Constants.BlockSize))
        block.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        self.addSubview(block)
        collision = UICollisionBehavior(items: [block])
        collision.collisionDelegate = self
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        return block
    }
    
    func activateMotion(){
        if redBlock == nil {
            redBlock = addBlock()
            redBlock?.backgroundColor = UIColor.redColor()
            bouncer.addBlock(redBlock!)
        }
        let motionManager = AppDelegate.Motion.Manager
        if motionManager.accelerometerAvailable {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue())
                { (data, error) -> Void in
                    self.bouncer.gravity.gravityDirection = CGVector(dx: data!.acceleration.x, dy: -data!.acceleration.y)
                    
                }
        }

    }
    
//
//    func playSound(soundName: String)
//    {
//        let coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ding", ofType: "mp3")!)
//        do{
//            let audioPlayer = try AVAudioPlayer(contentsOfURL:coinSound)
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//        }catch {
//            print("Error getting the audio file")
//        }
//    }

    func playSound(){
        AudioServicesPlaySystemSound(1051)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        
        if count < 18 {
            playSound()
            count++
            if redBlock?.backgroundColor == UIColor.redColor(){
                redBlock?.backgroundColor = UIColor.greenColor()
            }else{
                redBlock?.backgroundColor = UIColor.redColor()
            }
           redBlock?.frame = CGRectMake((redBlock?.frame.minX)!, (redBlock?.frame.minY)!, (redBlock?.frame.width)! * 1.2, (redBlock?.frame.height)! * 1.2)
        }else {
            redBlock!.frame = CGRectMake(0, 0, 0, 0)
            addLabel()
            print("Game Over")
        }
        print("count", count)
    }
}


