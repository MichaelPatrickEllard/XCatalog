//
//  ViewController.swift
//  SplitViewTester
//
//  Created by Rescue Mission Software on 7/10/15.
//  Copyright (c) 2015 Michael Patrick Ellard. All rights reserved.
//

import Cocoa

class MasterDetailViewController: NSViewController {
    
    var currentDetailVC: NSViewController?
    
    @IBOutlet weak var detailPane: NSView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func purplePressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? PurpleViewController
        {
            return  // We've already got the right view controller
        }
            
        let x = PurpleViewController(nibName:"PurpleViewController", bundle:nil)!
        
        addChildVC(x)
    }
    
    @IBAction func bluePressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? BlueViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = BlueViewController(nibName:"BlueViewController", bundle:nil)!
        
        addChildVC(x)
    }
    
    func addChildVC(childVC: NSViewController)
    {
        if currentDetailVC != nil {
            
            currentDetailVC?.view.removeFromSuperview()
            
            removeChildViewControllerAtIndex(0) // There should only ever be one
        }
        
        self.addChildViewController(childVC)
        
        self.detailPane.addSubview(childVC.view)
        
        self.currentDetailVC = childVC

    }



}

