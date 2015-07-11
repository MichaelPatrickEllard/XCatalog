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
    
    @IBAction func activityIndicatorPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? ActivityIndicatorViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = ActivityIndicatorViewController(nibName:"ActivityIndicatorViewController", bundle:nil)!
        
        addChildVC(x)
    }
    
    @IBAction func alertControllerPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? AlertControllerViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = AlertControllerViewController(nibName:"AlertControllerViewController", bundle:nil)!
        
        addChildVC(x)
    }

    @IBAction func buttonViewControllerPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? ButtonViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = ButtonViewController(nibName:"ButtonViewController", bundle:nil)!
        
        addChildVC(x)
    }

    
    @IBAction func DatePickerPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? DatePickerController
        {
            return  // We've already got the right view controller
        }
        
        let x = DatePickerController(nibName:"DatePickerController", bundle:nil)!
        
        addChildVC(x)
    }

    
    @IBAction func imageViewControllerPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? ImageViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = ImageViewController(nibName:"ImageViewController", bundle:nil)!
        
        addChildVC(x)
    }

    
    @IBAction func pageControlPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? PageControlViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = PageControlViewController(nibName:"PageControlViewController", bundle:nil)!
        
        addChildVC(x)
    }

    @IBAction func pickerViewPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? PickerViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = PickerViewController(nibName:"PickerViewController", bundle:nil)!
        
        addChildVC(x)
    }

    
    @IBAction func progressViewControllerPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? ProgressViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = ProgressViewController(nibName:"ProgressViewController", bundle:nil)!
        
        addChildVC(x)
    }

    
    @IBAction func segmentedViewControllerPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? SegmentedControlViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = SegmentedControlViewController(nibName:"SegmentedControlViewController", bundle:nil)!
        
        addChildVC(x)
    }

    
    @IBAction func sliderViewPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? SliderViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = SliderViewController(nibName:"SliderViewController", bundle:nil)!
        
        addChildVC(x)
    }

    
    @IBAction func stepperPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? StepperViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = StepperViewController(nibName:"StepperViewController", bundle:nil)!
        
        addChildVC(x)
    }

    
    @IBAction func switchPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? SwitchViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = SwitchViewController(nibName:"SwitchViewController", bundle:nil)!
        
        addChildVC(x)
    }

    
    @IBAction func textFieldPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? TextFieldViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = TextFieldViewController(nibName:"TextFieldViewController", bundle:nil)!
        
        addChildVC(x)
    }

    @IBAction func textViewPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? TextViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = TextViewController(nibName:"TextViewController", bundle:nil)!
        
        addChildVC(x)
    }

    @IBAction func webViewPressed(sender: AnyObject) {
        
        if let someViewController = currentDetailVC as? WebViewController
        {
            return  // We've already got the right view controller
        }
        
        let x = WebViewController(nibName:"WebViewController", bundle:nil)!
        
        addChildVC(x)
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
        
        childVC.view.frame = self.detailPane.bounds
        
        self.detailPane.addSubview(childVC.view)
        
        self.currentDetailVC = childVC

    }



}

