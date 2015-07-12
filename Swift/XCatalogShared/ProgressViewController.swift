//
//  ProgressViewController.swift
//  XCatalog
//
//  Created by Rescue Mission Software on 7/11/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import Foundation

class ProgressViewController: XDisplayController {
    // MARK: Types
    
    struct Constants {
        static let maxProgress = 100
    }
    
    // MARK: Properties
    
    @IBOutlet weak var defaultStyleProgressView: XProgressView!
    
    @IBOutlet weak var barStyleProgressView: XProgressView!
    
    @IBOutlet weak var tintedProgressView: XProgressView!
    
    let operationQueue = NSOperationQueue()
    
    var completedProgress: Int = 0 {
        didSet(oldValue) {
            let fractionalProgress = Double(completedProgress) / Double(Constants.maxProgress)
            
            let animated = oldValue != 0
            
            for progressView in [defaultStyleProgressView, barStyleProgressView, tintedProgressView] {
                progressView.advance(fractionalProgress)
            }
        }
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDefaultStyleProgressView()
        configureBarStyleProgressView()
        configureTintedProgressView()
        
        // As progress is received from another subsystem (i.e. NSProgress, NSURLSessionTaskDelegate, etc.), update the progressView's progress.
        simulateProgress()
    }
    
    // MARK: Configuration
    
    func configureDefaultStyleProgressView() {
        defaultStyleProgressView.progressStyle = .Thin
    }
    
    func configureBarStyleProgressView() {
        barStyleProgressView.progressStyle = .Thick
    }
    
    func configureTintedProgressView() {
        tintedProgressView.progressStyle = .Tinted
    }
    
    // MARK: Progress Simulation
    
    
    //  XCatalog note:  We didn't write this part.  It's taken directly from the Apple sample code without modification...
    
    func simulateProgress() {
        // In this example we will simulate progress with a "sleep operation".
        for _ in 0...Constants.maxProgress {
            operationQueue.addOperationWithBlock {
                // Delay the system for a random number of seconds.
                // This code is not intended for production purposes. The "sleep" call is meant to simulate work done in another subsystem.
                sleep(arc4random_uniform(10))
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.completedProgress++
                    return
                }
            }
        }
    }
}

