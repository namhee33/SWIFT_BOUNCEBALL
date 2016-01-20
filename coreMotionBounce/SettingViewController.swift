//
//  SettingViewController.swift
//  coreMotionBounce
//
//  Created by namhee kim on 1/20/16.
//  Copyright © 2016 namhee kim. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    weak var CancelDelegate: CancelProtocol?
    weak var DoneDelegate: DoneProtocol?
    var gameLevel = 1
    
    @IBOutlet weak var levelSlider: UISlider!
    
    @IBAction func cancelBtnPressed(sender: UIBarButtonItem) {
         CancelDelegate?.cancelSetting()
    }
    
    
    @IBAction func doneBtnPressed(sender: UIBarButtonItem) {
        
        DoneDelegate?.settingInfo(gameLevel)
    }
    
    @IBAction func levelChanged(sender: UISlider) {
        gameLevel = Int(sender.value)
        
    }
}
