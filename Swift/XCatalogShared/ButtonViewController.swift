/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A view controller that demonstrates how to use UIButton. The buttons are created using storyboards, but each of the system buttons can be created in code by using the UIButton.buttonWithType() initializer. See the UIButton interface for a comprehensive list of the various UIButtonType values.
*/

import Foundation

class ButtonViewController: XDisplayController {
    // MARK: Properties

    @IBOutlet weak var systemTextButton: XButton!
    
    @IBOutlet weak var systemContactAddButton: XButton!
    
    @IBOutlet weak var systemDetailDisclosureButton: XButton!
    
    @IBOutlet weak var imageButton: XButton!
    
    @IBOutlet weak var attributedTextButton: XButton!

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // All of the buttons are created in the storyboard, but configured below.
        configureSystemTextButton()
        configureSystemContactAddButton()
        configureSystemDetailDisclosureButton()
        configureImageButton()
        configureAttributedTextSystemButton()
    }

    // MARK: Configuration

    func configureSystemTextButton() {
        let buttonTitle = NSLocalizedString("Button", comment: "")

        systemTextButton.setTitle(buttonTitle, forState: .Normal)

        systemTextButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
    }

    func configureSystemContactAddButton() {
        systemContactAddButton.backgroundColor = XColor.clearColor()

        systemContactAddButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
    }

    func configureSystemDetailDisclosureButton() {
        systemDetailDisclosureButton.backgroundColor = XColor.clearColor()

        systemDetailDisclosureButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
    }

    func configureImageButton() {
        // To create this button in code you can use UIButton.buttonWithType() with a parameter value of .Custom.

        // Remove the title text.
        imageButton.setTitle("", forState: .Normal)

        imageButton.tintColor = XColor.applicationPurpleColor()

        let imageButtonNormalImage = XImage(named: "x_icon")
        imageButton.setImage(imageButtonNormalImage, forState: .Normal)

        // Add an accessibility label to the image.
        imageButton.xAccessibilityLabel = NSLocalizedString("X Button", comment: "")

        imageButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
    }

    func configureAttributedTextSystemButton() {
        let buttonTitle = NSLocalizedString("Button", comment: "")
        
        // Set the button's title for normal state.
        let normalTitleAttributes = [
            XForegroundColorAttributeName: XColor.applicationBlueColor(),
            XStrikethroughStyleAttributeName: XUnderlineStyle.StyleSingle.rawValue
        ]
        let normalAttributedTitle = NSAttributedString(string: buttonTitle, attributes: normalTitleAttributes)
        attributedTextButton.setAttributedTitle(normalAttributedTitle, forState: .Normal)

        // Set the button's title for highlighted state.
        let highlightedTitleAttributes = [
            XForegroundColorAttributeName: XColor.greenColor(),
            XStrikethroughStyleAttributeName: XUnderlineStyle.StyleThick.rawValue
        ]
        let highlightedAttributedTitle = NSAttributedString(string: buttonTitle, attributes: highlightedTitleAttributes)
        attributedTextButton.setAttributedTitle(highlightedAttributedTitle, forState: .Highlighted)

        attributedTextButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
    }

    // MARK: Actions

    func buttonClicked(sender: XButton) {
        NSLog("A button was clicked: \(sender).")
    }
}
