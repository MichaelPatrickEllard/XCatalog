//
//  PageControlViewController.swift
//  XCatalog
//
//  Created by Michael L Mehr on 8/17/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import Foundation

class PageControlViewController: XViewController {
    // MARK: Properties
    
    @IBOutlet weak var pageControl: XPageControl!
    
    @IBOutlet weak var colorView: XColorView!
    
    /// Colors that correspond to the selected page. Used as the background color for "colorView".
    let colors = [
        XColor.blackColor(),
        XColor.grayColor(),
        XColor.redColor(),
        XColor.greenColor(),
        XColor.blueColor(),
        XColor.cyanColor(),
        XColor.yellowColor(),
        XColor.magentaColor(),
        XColor.orangeColor(),
        XColor.purpleColor()
    ]
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageControl()
        pageControlValueDidChange()
    }
    
    // MARK: Configuration
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl.numberOfPages = colors.count
        pageControl.currentPage = 2
        
        pageControl.tintColor = XColor.applicationBlueColor()
        pageControl.pageIndicatorTintColor = XColor.applicationGreenColor()
        pageControl.currentPageIndicatorTintColor = XColor.applicationPurpleColor()
        
        pageControl.addTarget(self, action: "pageControlValueDidChange", forControlEvents: .ValueChanged)
    }
    
    // MARK: Actions
    
    func pageControlValueDidChange() {
        NSLog("The page control changed its current page to \(pageControl.currentPage).")
        
        colorView.backgroundColor = colors[pageControl.currentPage]
    }
}
