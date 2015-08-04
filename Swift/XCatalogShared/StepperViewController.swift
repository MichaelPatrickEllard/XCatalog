//
//  StepperViewController.swift
//  XCatalog
//
//  Created by Michael L Mehr on 8/3/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import Foundation

class StepperViewController: XTableViewController {
    // MARK: Properties
    
    @IBOutlet weak var defaultStepper: XStepper!
    
    @IBOutlet weak var tintedStepper: XStepper!
    
    @IBOutlet weak var customStepper: XStepper!
    
    @IBOutlet weak var defaultStepperLabel: XLabel!
    
    @IBOutlet weak var tintedStepperLabel: XLabel!
    
    @IBOutlet weak var customStepperLabel: XLabel!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDefaultStepper()
        configureTintedStepper()
        configureCustomStepper()
    }
    
    // MARK: Configuration
    
    func configureDefaultStepper() {
        defaultStepper.currentValue = 0
        defaultStepper.minimumValue = 0
        defaultStepper.maximumValue = 10
        defaultStepper.stepValue = 1
        
        defaultStepperLabel.text = "\(Int(defaultStepper.currentValue))"
        defaultStepper.addTarget(self, action: "stepperValueDidChange:", forControlEvents: .ValueChanged)
    }
    
    func configureTintedStepper() {
        tintedStepper.tintColor = XColor.applicationBlueColor()
        
        tintedStepperLabel.text = "\(Int(tintedStepper.currentValue))"
        tintedStepper.addTarget(self, action: "stepperValueDidChange:", forControlEvents: .ValueChanged)
    }
    
    func configureCustomStepper() {
        // Set the background image.
        let stepperBackgroundImage = XImage(named: "stepper_and_segment_background")
        customStepper.setBackgroundImage(stepperBackgroundImage, forState: .Normal)
        
        let stepperHighlightedBackgroundImage = XImage(named: "stepper_and_segment_background_highlighted")
        customStepper.setBackgroundImage(stepperHighlightedBackgroundImage, forState: .Highlighted)
        
        let stepperDisabledBackgroundImage = XImage(named: "stepper_and_segment_background_disabled")
        customStepper.setBackgroundImage(stepperDisabledBackgroundImage, forState: .Disabled)
        
        // Set the image which will be painted in between the two stepper segments (depends on the states of both segments).
        let stepperSegmentDividerImage = XImage(named: "stepper_and_segment_divider")
        customStepper.setDividerImage(stepperSegmentDividerImage, forLeftSegmentState: .Normal, rightSegmentState: .Normal)
        
        // Set the image for the + button.
        let stepperIncrementImage = XImage(named: "stepper_increment")
        customStepper.setIncrementImage(stepperIncrementImage, forState: .Normal)
        
        // Set the image for the - button.
        let stepperDecrementImage = XImage(named: "stepper_decrement")
        customStepper.setDecrementImage(stepperDecrementImage, forState: .Normal)
        
        customStepperLabel.text = "\(Int(customStepper.currentValue))"
        customStepper.addTarget(self, action: "stepperValueDidChange:", forControlEvents: .ValueChanged)
    }
    
    // MARK: Actions
    
    func stepperValueDidChange(stepper: XStepper) {
        NSLog("A stepper changed its value: \(stepper.currentValue).")
        
        // A mapping from a stepper to its associated label.
        let stepperMapping: [XStepper: XLabel] = [
            defaultStepper: defaultStepperLabel,
            tintedStepper: tintedStepperLabel,
            customStepper: customStepperLabel
        ]
        
        stepperMapping[stepper]!.text = "\(Int(stepper.currentValue))"
    }
}
