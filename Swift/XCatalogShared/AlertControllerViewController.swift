//
//  AlertControllerViewController.swift
//  XCatalog
//
//  Created by Michael L Mehr on 7/30/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import Foundation

class AlertControllerViewController: XTableViewController, XTableViewDelegate {
    
    weak var secureTextAlertAction: XAlertAction?
    
    // A matrix of closures that should be invoked based on which table view cell is
    // tapped (index by section, row).
    var actionMap: [[(selectedIndexPath: NSIndexPath) -> Void]] {
        return [
            // Alert style alerts.
            [
                self.showSimpleAlert,
                self.showOkayCancelAlert,
                self.showOtherAlert,
                self.showTextEntryAlert,
                self.showSecureTextEntryAlert
            ],
            // Action sheet style alerts.
            [
                self.showOkayCancelActionSheet,
                self.showOtherActionSheet
            ]
        ]
    }
    
    // HACK for OS X VC ONLY
    // - must implement TableView delegate / dataSource here due to bug in OS X Yosemite with tableView.useStaticContents (not working?)
    var actionTitles = [
        // Alert style alerts.
        [
            "Simple",
            "Okay / Cancel",
            "Other",
            "Text Entry",
            "Secure Text Entry",
        ],
        // Action sheet style alerts.
        [
            "Okay / Cancel (Action Sheet)",
            "Other (Action Sheet)",
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        /*
        // Following feature was introduced in Yosemite and doesn't work yet (file radar?) (XCode 6.4)
        tableView1.usesStaticContents = true
        tableView2.usesStaticContents = true
        */
//        tableView1.setDataSource(self)
        //    tableView2.setDataSource(self)
        setupTitles( actionTitles )
        self.delegate = self
    }
    
    /// Show an alert with an "Okay" button.
    func showSimpleAlert(_: NSIndexPath) {
        let title = NSLocalizedString("A Short Title is Best", comment: "")
        let message = NSLocalizedString("A message should be a short, complete sentence.", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = XAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the action.
        let cancelAction = XAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("The simple alert's cancel action occured.")
        }
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    /// Show an alert with an "Okay" and "Cancel" button.
    func showOkayCancelAlert(_: NSIndexPath) {
        let title = NSLocalizedString("A Short Title is Best", comment: "")
        let message = NSLocalizedString("A message should be a short, complete sentence.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let otherButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertCotroller = XAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the actions.
        let cancelAction = XAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("The \"Okay/Cancel\" alert's cancel action occured.")
        }
        
        let otherAction = XAlertAction(title: otherButtonTitle, style: .Default) { action in
            NSLog("The \"Okay/Cancel\" alert's other action occured.")
        }
        
        // Add the actions.
        alertCotroller.addAction(cancelAction)
        alertCotroller.addAction(otherAction)
        
        presentViewController(alertCotroller, animated: true, completion: nil)
    }
    
    /// Show an alert with two custom buttons.
    func showOtherAlert(_: NSIndexPath) {
        let title = NSLocalizedString("A Short Title is Best", comment: "")
        let message = NSLocalizedString("A message should be a short, complete sentence.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let otherButtonTitleOne = NSLocalizedString("Choice One", comment: "")
        let otherButtonTitleTwo = NSLocalizedString("Choice Two", comment: "")
        
        let alertController = XAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the actions.
        let cancelAction = XAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("The \"Other\" alert's cancel action occured.")
        }
        
        let otherButtonOneAction = XAlertAction(title: otherButtonTitleOne, style: .Default) { action in
            NSLog("The \"Other\" alert's other button one action occured.")
        }
        
        let otherButtonTwoAction = XAlertAction(title: otherButtonTitleTwo, style: .Default) { action in
            NSLog("The \"Other\" alert's other button two action occured.")
        }
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(otherButtonOneAction)
        alertController.addAction(otherButtonTwoAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    /// Show a text entry alert with two custom buttons.
    func showTextEntryAlert(_: NSIndexPath) {
        let title = NSLocalizedString("A Short Title is Best", comment: "")
        let message = NSLocalizedString("A message should be a short, complete sentence.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let otherButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = XAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Add the text field for text entry.
        alertController.addTextFieldWithConfigurationHandler { textField in
            // If you need to customize the text field, you can do so here.
        }
        
        // Create the actions.
        let cancelAction = XAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("The \"Text Entry\" alert's cancel action occured.")
        }
        
        let otherAction = XAlertAction(title: otherButtonTitle, style: .Default) { action in
            let textField = alertController.textFields?.first as! XAlertTextField?
            let text = textField?.text ?? ""
            NSLog("The \"Text Entry\" alert's other action occured with text=\(text).")
        }
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(otherAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /// Show a secure text entry alert with two custom buttons.
    func showSecureTextEntryAlert(_: NSIndexPath) {
        let title = NSLocalizedString("A Short Title is Best", comment: "")
        let message = NSLocalizedString("A message should be a short, complete sentence.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let otherButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = XAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Add the text field for the secure text entry.
        alertController.addTextFieldWithConfigurationHandler { textField in
            // Listen for changes to the text field's text so that we can toggle the current
            // action's enabled property based on whether the user has entered a sufficiently
            // secure entry.
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleTextFieldTextDidChangeNotification:", name: XAlertTextFieldTextDidChangeNotification, object: textField)
            
            textField.secureTextEntry = true
        }
        
        // Stop listening for text change notifications on the text field. This closure will be called in the two action handlers.
        let removeTextFieldObserver: Void -> Void = {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: XAlertTextFieldTextDidChangeNotification, object: alertController.textFields!.first)
        }
        
        // Create the actions.
        let cancelAction = XAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("The \"Secure Text Entry\" alert's cancel action occured.")
            
            removeTextFieldObserver()
        }
        
        let otherAction = XAlertAction(title: otherButtonTitle, style: .Default) { action in
            let textField = alertController.textFields?.first as! XAlertTextField?
            let text = textField?.text ?? ""
            NSLog("The \"Secure Text Entry\" alert's other action occured with text=\(text).")
            
            removeTextFieldObserver()
        }
        
        // The text field initially has no text in the text field, so we'll disable it.
        otherAction.enabled = false
        
        // Hold onto the secure text alert action to toggle the enabled/disabled state when the text changed.
        secureTextAlertAction = otherAction
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(otherAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: UIAlertControllerStyleActionSheet Style Alerts
    
    /// Show a dialog with an "Okay" and "Cancel" button.
    func showOkayCancelActionSheet(selectedIndexPath: NSIndexPath) {
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "OK")
        let destructiveButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = XAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        // Create the actions.
        let cancelAction = XAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("The \"Okay/Cancel\" alert action sheet's cancel action occured.")
        }
        
        let destructiveAction = XAlertAction(title: destructiveButtonTitle, style: .Destructive) { action in
            NSLog("The \"Okay/Cancel\" alert action sheet's destructive action occured.")
        }
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(destructiveAction)
        
        // Configure the alert controller's popover presentation controller if it has one.
        if let popoverPresentationController = alertController.popoverPresentationController {
            // This method expects a valid cell to display from.
            let selectedCell = tableView.cellForRowAtIndexPath(selectedIndexPath)!
            println("In popover code for section \(selectedIndexPath.section) and row \(selectedIndexPath.row) with cell \(selectedCell)")
            popoverPresentationController.sourceRect = selectedCell.frame
            popoverPresentationController.sourceView = view
            popoverPresentationController.permittedArrowDirections = .Up
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /// Show a dialog with two custom buttons.
    func showOtherActionSheet(selectedIndexPath: NSIndexPath) {
        let destructiveButtonTitle = NSLocalizedString("Destructive Choice", comment: "")
        let otherButtonTitle = NSLocalizedString("Safe Choice", comment: "")
        
        let alertController = XAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        // Create the actions.
        let destructiveAction = XAlertAction(title: destructiveButtonTitle, style: .Destructive) { action in
            NSLog("The \"Other\" alert action sheet's destructive action occured.")
        }
        
        let otherAction = XAlertAction(title: otherButtonTitle, style: .Default) { action in
            NSLog("The \"Other\" alert action sheet's other action occured.")
        }
        
        // Add the actions.
        alertController.addAction(destructiveAction)
        alertController.addAction(otherAction)
        
        // Configure the alert controller's popover presentation controller if it has one.
        if let popoverPresentationController = alertController.popoverPresentationController {
            // This method expects a valid cell to display from.
            let selectedCell = tableView.cellForRowAtIndexPath(selectedIndexPath)!
            popoverPresentationController.sourceRect = selectedCell.frame
            popoverPresentationController.sourceView = view
            popoverPresentationController.permittedArrowDirections = .Up
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: XTextFieldTextDidChangeNotification
    
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! XAlertTextField
        
        // Enforce a minimum length of >= 5 characters for secure text alerts.
        secureTextAlertAction!.enabled = count(textField.text) >= 5
    }
    
    
    // MARK: XTableViewDelegate
    
    override func tableView(tableView: XTableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let action = actionMap[indexPath.section][indexPath.row]
        
        action(selectedIndexPath: indexPath)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
