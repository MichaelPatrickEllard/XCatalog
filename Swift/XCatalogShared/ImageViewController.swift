//
//  ImageViewController.swift
//  XCatalog
//
//  Created by Michael L Mehr on 8/15/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import Foundation

class ImageViewController: XViewController {
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureImageView()
    }
    
    // MARK: Configuration
    
    func configureImageView() {
        // The root view of the view controller set in Interface Builder is a UIImageView.
        let imageView = view as! XImageView
        
        // Fetch the images (each image is of the format image_animal_number).
        imageView.animationImages = map(1...5) { XImage(named: "image_animal_\($0)")! }
        
        // We want the image to be scaled to the correct aspect ratio within imageView's bounds.
        imageView.contentMode = .ScaleAspectFit
        
        // If the image does not have the same aspect ratio as imageView's bounds, then imageView's backgroundColor will be applied to the "empty" space.
        imageView.backgroundColor = XColor.whiteColor()
        
        imageView.animationDuration = 5
        imageView.startAnimating()
        
        imageView.currentIsAccessibilityElementValue = true
        imageView.currentAccessibilityLabel = NSLocalizedString("Animated", comment: "")
    }
}
