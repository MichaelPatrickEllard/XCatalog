//
//  SliderViewController.swift
//  XCatalog
//
//  Created by Michael L Mehr on 8/3/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import Foundation

class SliderViewController: XTableViewController {
    // MARK: Properties
    
    @IBOutlet weak var defaultSlider: XSlider!
    
    @IBOutlet weak var tintedSlider: XSlider!
    
    @IBOutlet weak var customSlider: XSlider!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDefaultSlider()
        configureTintedSlider()
        configureCustomSlider()
    }
    
    // MARK: Configuration
    
    func configureDefaultSlider() {
        defaultSlider.minimumValue = 0
        defaultSlider.maximumValue = 100
        defaultSlider.currentValue = 42
        defaultSlider.continuous = true
        
        defaultSlider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
    }
    
    func configureTintedSlider() {
        tintedSlider.minimumTrackTintColor = XColor.applicationBlueColor()
        tintedSlider.maximumTrackTintColor = XColor.applicationPurpleColor()

        tintedSlider.maximumValue = 1.0 // default on iOS, must override for OS X
        tintedSlider.continuous = true // default on iOS, must override for OS X

        tintedSlider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
    }
    
    func configureCustomSlider() {
        let leftTrackImage = XImage(named: "slider_blue_track")
        customSlider.setMinimumTrackImage(leftTrackImage, forState: .Normal)
        
        let rightTrackImage = XImage(named: "slider_green_track")
        customSlider.setMaximumTrackImage(rightTrackImage, forState: .Normal)
        
        let thumbImage = XImage(named: "slider_thumb")
        customSlider.setThumbImage(thumbImage, forState: .Normal)
        
        customSlider.minimumValue = 0
        customSlider.maximumValue = 100
        customSlider.continuous = false
        customSlider.currentValue = 84
        
        customSlider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
    }
    
    // MARK: Actions
    
    func sliderValueDidChange(slider: XSlider) {
        NSLog("A slider changed its value: \(slider.currentValue).")
    }
}
