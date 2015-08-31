//
//  TextFieldViewController.swift
//  XCatalog
//
//  Created by Michael L Mehr on 8/3/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import Foundation
import CoreGraphics

class TextFieldViewController: XTableViewController, XTextFieldDelegate {
    // MARK: Properties
    
    @IBOutlet weak var textField: XTextField!
    
    @IBOutlet weak var tintedTextField: XTextField!
    
    @IBOutlet weak var secureTextField: XTextField!
    
    @IBOutlet weak var specificKeyboardTextField: XTextField!
    
    @IBOutlet weak var customTextField: XTextField!
    
    // Mark: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField()
        configureTintedTextField()
        configureSecureTextField()
        configureSpecificKeyboardTextField()
        configureCustomTextField()
    }
    
    // MARK: Configuration
    
    func configureTextField() {
        textField.placeholder = NSLocalizedString("Placeholder text", comment: "")
        textField.autocorrectionType = .Yes
        textField.returnKeyType = .Done
        textField.clearButtonMode = .Never
        textField.delegate = self
    }
    
    func configureTintedTextField() {
        tintedTextField.tintColor = XColor.applicationBlueColor()
        tintedTextField.textColor = XColor.applicationGreenColor()

        tintedTextField.placeholder = NSLocalizedString("Placeholder text", comment: "")
        tintedTextField.returnKeyType = .Done
        tintedTextField.clearButtonMode = .Never
        tintedTextField.delegate = self
    }
    
    func configureSecureTextField() {
        secureTextField.secureTextEntry = true
        
        secureTextField.placeholder = NSLocalizedString("Placeholder text", comment: "")
        secureTextField.returnKeyType = .Done
        secureTextField.clearButtonMode = .Always
        secureTextField.delegate = self
    }
    
    /// There are many different types of keyboards that you may choose to use.
    /// The different types of keyboards are defined in the UITextInputTraits interface.
    /// This example shows how to display a keyboard to help enter email addresses.
    func configureSpecificKeyboardTextField() {
        specificKeyboardTextField.keyboardType = .EmailAddress
        
        specificKeyboardTextField.placeholder = NSLocalizedString("Placeholder text", comment: "")
        specificKeyboardTextField.returnKeyType = .Done
        specificKeyboardTextField.delegate = self
    }
    
    func configureCustomTextField() {
        customTextField.delegate = self
        // Text fields with custom image backgrounds must have no border.
        customTextField.borderStyle = .None
        
        customTextField.background = XImage(named: "text_field_background")
        
        // Create a purple button that, when selected, turns the custom text field's text color
        // to purple.
        let purpleImage = XImage(named: "text_field_purple_right_view")!
        let purpleImageButton = XButton.buttonWithType(.Custom) as! XButton
        purpleImageButton.bounds = CGRect(x: 0, y: 0, width: purpleImage.size.width, height: purpleImage.size.height)
        purpleImageButton.imageEdgeInsets = XEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        purpleImageButton.setImage(purpleImage, forState: .Normal)
        purpleImageButton.addTarget(self, action: "customTextFieldPurpleButtonClicked", forControlEvents: .TouchUpInside)
        customTextField.rightView = purpleImageButton
        customTextField.rightViewMode = .Always
        
        // Add an empty view as the left view to ensure inset between the text and the bounding rectangle.
        let leftPaddingView = XView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        leftPaddingView.backgroundColor = XColor.clearColor()
        customTextField.leftView = leftPaddingView
        customTextField.leftViewMode = .Always

        customTextField.placeholder = NSLocalizedString("Placeholder text", comment: "")
        customTextField.autocorrectionType = .No
        customTextField.returnKeyType = .Done
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: XTextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: Actions
    
    func customTextFieldPurpleButtonClicked() {
        customTextField.textColor = XColor.applicationPurpleColor()
        
        NSLog("The custom text field's purple right view button was clicked.")
    }
}
