//
//  BlueViewController.swift
//  SplitViewTester
//
//  Created by Rescue Mission Software on 7/11/15.
//  Copyright (c) 2015 Michael Patrick Ellard. All rights reserved.
//

import Cocoa

class BlueViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.blueColor().CGColor
    }
}
