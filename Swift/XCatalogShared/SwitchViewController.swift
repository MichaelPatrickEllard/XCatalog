//
//  SwitchViewController.swift
//  XCatalog
//
//  Created by Rescue Mission Software on 7/12/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import Foundation

class SwitchViewController: XDisplayController {
    // MARK: Properties
    
    @IBOutlet weak var defaultSwitch: XSwitchBox!
    
    @IBOutlet weak var tintedSwitch: XSwitchBox!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDefaultSwitch()
        configureTintedSwitch()
    }
    
    // MARK: Configuration
    
    func configureDefaultSwitch() {
        defaultSwitch.setOnState(true)
        
        defaultSwitch.setAction("switchValueDidChange:", target: self)
    }
    
    func configureTintedSwitch()
    {
        tintedSwitch.setColorScheme(XColor.applicationBlueColor(), onTint: XColor.applicationGreenColor(), thumbTint: XColor.applicationPurpleColor())
        
        tintedSwitch.setAction("switchValueDidChange:", target: self)
    }
    
    // MARK: Actions
    
    func switchValueDidChange(aSwitch: XSwitchBox) {
        NSLog("A switchbox changed its value: \(aSwitch).")
    }
}
