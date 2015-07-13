/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A view controller that demonstrates how to use UIActivityIndicatorView.
*/

import Foundation

class ActivityIndicatorViewController: XDisplayController {
    // MARK: Properties

    @IBOutlet weak var grayStyleActivityIndicatorView: XActivityIndicatorView!
    
    @IBOutlet weak var tintedActivityIndicatorView: XActivityIndicatorView!
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGrayActivityIndicatorView()
        configureTintedActivityIndicatorView()
        
        // When activity is done, use UIActivityIndicatorView.stopAnimating().
    }
    
    // MARK: Configuration

    func configureGrayActivityIndicatorView() {
        grayStyleActivityIndicatorView.activityIndicatorViewStyle = .Gray
        
        grayStyleActivityIndicatorView.startAnimating()
        
        grayStyleActivityIndicatorView.hidesWhenStopped = true
    }
    
    func configureTintedActivityIndicatorView() {
        tintedActivityIndicatorView.activityIndicatorViewStyle = .Gray
        
        tintedActivityIndicatorView.color = XColor.applicationPurpleColor()
        
        tintedActivityIndicatorView.startAnimating()
    }
}
