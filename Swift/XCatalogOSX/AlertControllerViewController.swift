//
//  AlertControllerViewController.swift
//  XCatalog
//
//  Created by Rescue Mission Software on 7/11/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import Cocoa

class AlertControllerViewController: NSViewController {

    @IBOutlet weak var tableView1: NSTableView!
    //@IBOutlet weak var tableView2: NSTableView! // bug in OSX? can't have two NSTableView objects in the same XIB? VC?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        /*
        // Following feature was introduced in Yosemite and doesn't work yet (file radar?) (XCode 6.4)
        tableView1.usesStaticContents = true
        tableView2.usesStaticContents = true
        */
        tableView1.setDataSource(self)
    //    tableView2.setDataSource(self)
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
            let text = alertController.textFields?.first?.text ?? ""
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
            let text = alertController.textFields?.first?.text ?? ""
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
//            let selectedCell = tableView.cellForRowAtIndexPath(selectedIndexPath)!
//            popoverPresentationController.sourceRect = selectedCell.frame
//            popoverPresentationController.sourceView = view
//            popoverPresentationController.permittedArrowDirections = .Up
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
//            let selectedCell = tableView.cellForRowAtIndexPath(selectedIndexPath)!
//            popoverPresentationController.sourceRect = selectedCell.frame
//            popoverPresentationController.sourceView = view
//            popoverPresentationController.permittedArrowDirections = .Up
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: UITextFieldTextDidChangeNotification
    
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! XAlertTextField
        
        // Enforce a minimum length of >= 5 characters for secure text alerts.
        secureTextAlertAction!.enabled = count(textField.text) >= 5
    }
    
}

///////////////////////////////
// Additions to XKit for OSX //
///////////////////////////////
typealias XAlertController = NSAlert

typealias XAlertHandler = (() -> ())
typealias XAlertTextField = NSTextField
typealias XAlertTextFieldConfigurationHandler = ((XAlertTextField) -> ())
let XAlertTextFieldTextDidChangeNotification = NSControlTextDidChangeNotification //UITextFieldTextDidChangeNotification

enum XAlertStyle {
    case Alert, ActionSheet
}

extension XAlertController {
    convenience init(title: String?, message: String?, preferredStyle: XAlertStyle) {
        self.init()
        // NOTE: OS X requires these text strings to be non-nil, thus the coalescing operator is used
        self.messageText = title ?? "Alert"
        self.informativeText = message ?? ""
        // HACK WARNING!
        // Subvert Apple's intended use of alertStyle to carry our info about how to run modally, since no difference in visual display
        // NOTE: Borks usage of critical style, however
        switch preferredStyle {
        case .Alert:
            self.alertStyle = NSAlertStyle.WarningAlertStyle // says to use runModal()
        case .ActionSheet:
            self.alertStyle = NSAlertStyle.InformationalAlertStyle // says to run as modal sheet (use beginSheet...())
        }
    }
    
    func addAction( action: XAlertAction ) {
        // add a button (really the XAlertAction) to the appropriate XAlert
        self.addButtonWithTitle(action.title)
        // copy the target and action settings to the new button
        if var buttonX = self.buttons.last as? NSButton {
            action.setupTarget(&buttonX)
        }
    }

    // popovers are unimplemented at this time
    var popoverPresentationController: NSPopover? {
        get { return nil }
        set { }
    }
    
    func addTextFieldWithConfigurationHandler(handler: XAlertTextFieldConfigurationHandler?) {
        var accessory = XAlertTextField(frame: NSMakeRect(0, 0, 200, 24)) // experimentally determined height of 24pts works on my Mac mini - is this universal enough?)
        
        accessory.editable = true
        accessory.drawsBackground = true
        
        self.accessoryView = accessory

        // allow caller to configure the text view further
        if let handler = handler {
            handler(accessory)
        }
    }
    
    var textFields: [XAlertTextField]? {
        // DESIGN NOTE: iOS allows multiple text fields per alert, but OS X only allows one: accessoryView
        // Proper implementation would need us to add that extra functionality but we're postponing making self a class as long as possible
        if let accessory = self.accessoryView as? XAlertTextField {
            return [accessory]
        }
        return nil
    }
    
    /*
    Solution from here for modal sheet problem by Laurent P here: http://stackoverflow.com/questions/604768/wait-for-nsalert-beginsheetmodalforwindow
    It's an Objective-C category (Swift extension) to NSAlert, incorporating 3 answers and using the non-deprecated function (whew)
    */
    func runModalSheetForWindow( aWindow: NSWindow ) -> Int {
        self.beginSheetModalForWindow(aWindow) { returnCode in
            NSApp.stopModalWithCode(returnCode)
        }
        let modalCode = NSApp.runModalForWindow(self.window as! NSWindow)
        return modalCode
    }
    
    func runModalSheet() -> Int {
        // Swift 1.2 gives error if only using one '!' below:
        // Value of optional type 'NSWindow?' not unwrapped; did you mean to use '!' or '?'?
        return runModalSheetForWindow(NSApp.mainWindow!!)
    }
}

extension XAlertTextField {
    var secureTextEntry: Bool {
        // NOTE: cell methods have been deprecated in OS X10.10 (Yosemite) - what is the replacement mechanism? this works tho
        set {
            if let oldCell = self.cell() as? NSTextFieldCell {
                let cell = NSSecureTextFieldCell()
                cell.editable = oldCell.editable
                cell.drawsBackground = oldCell.drawsBackground
                cell.stringValue = oldCell.stringValue
                self.setCell(cell)
            }
        }
        get {
            if let oldCell = self.cell() as? NSSecureTextFieldCell {
                return true
            }
            return false
        }
    }
    
    var text: String {
        get { return self.stringValue }
        set { self.stringValue = newValue }
    }
}

// HACK: convert presentViewController() from a global function into a method to allow sheet modal runs to find the window to add the sheet to
// ALTERNATE DESIGN: This isn't necessary if we use runModalSheet(), attaching the sheet to the app's main window instead of the current VC's window
// ... however, there may be a collision (ambiguity) between versions of the global function in that case
extension NSViewController {
    func presentViewController( controller: XAlertController, animated: Bool, completion: XAlertHandler? ) {
        // this is where we use controller to run modally or with the action sheet
        if controller.alertStyle == NSAlertStyle.WarningAlertStyle {
            controller.runModal()
        } else if let window = self.view.window where controller.alertStyle == .InformationalAlertStyle {
            controller.runModalSheetForWindow(window)
            // call the completion handler now, not when sheet modal is done
            if let completion = completion {
                completion()
            }
        }
    }
}

// MARK: XAlertAction implementation
typealias XAlertActionHandler = ((NSNotification) -> ())

enum XAlertActionStyle {
    case Default, Cancel, Destructive
}
//typealias XAlertAction = XButton
class XAlertAction: NSButton {
    private var actionHandler: XAlertActionHandler?
    private var otherButton: NSButton?
    var style: XAlertActionStyle = .Default
}

extension XAlertAction {
    convenience init( title: String?, style: XAlertActionStyle, completion: XAlertActionHandler? = nil) {
        self.init()
        if let title = title {
            if style == .Destructive {
                self.attributedTitle = NSAttributedString(string: title, attributes: [NSBackgroundColorAttributeName:NSColor.redColor()])
            } else {
                self.title = title
            }
        }
        self.actionHandler = completion
        self.target = self
        self.action = "runActionHandler:"
        self.style = style
    }
    
    private func setupTarget( inout button: NSButton ) {
        // copy its target/action into our own, for use later; remember the object we are associated with
        otherButton = button
        self.target = button.target
        self.action = button.action
        // set up our target/action for the other button in its place
        button.target = self
        button.action = "runActionHandler:"
        let stranger = self
        // copy our flags, title and attributes to the provided button as well
        button.enabled = enabled
        button.title = title
        button.attributedTitle = attributedTitle
        button.alternateTitle = alternateTitle
        button.attributedTitle = attributedTitle
        button.attributedAlternateTitle = attributedAlternateTitle
    }
    
    func runActionHandler(notification: NSNotification) {
        if let actionHandler = actionHandler {
            actionHandler(notification)
        }
        if let otherButton = otherButton {
            otherButton.sendAction(self.action, to: self.target)
        }
    }
    
    // HACK: simple forwarding of enabled flag to otherButton, if installed
    override var enabled: Bool {
        set {
            if let otherButton = otherButton {
                otherButton.enabled = newValue
            }
            super.enabled = newValue
        }
        get { return super.enabled }
    }
}

// HACK for OS X VC ONLY
// - must implement TableView delegate / dataSource here due to bug in OS X Yosemite with tableView.useStaticContents (not working?)
var actionTitles = [
    "Simple",
    "Okay / Cancel",
    "Other",
    "Text Entry",
    "Secure Text Entry",
    "Okay / Cancel (Action Sheet)",
    "Other (Action Sheet)",
]

extension AlertControllerViewController: NSTableViewDataSource {
    // MARK: NSTableViewDataSource protocol compliance
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if tableView === self.tableView1 {
            return actionTitles.count
        }
        //        if tableView === self.tableView2 {
        //            return 2
        //        }
        return 0
    }
    
}

extension AlertControllerViewController: NSTableViewDelegate {
    // MARK: NSTableViewDelegate protocol compliance
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let columnIdentifier = tableColumn?.identifier {
            var rowNum = -1
            if tableView === self.tableView1 {
                rowNum = row
            }
            //            if tableView === self.tableView2 {
            //                rowNum = row + numberOfRowsInTableView(self.tableView) // 5
            //            }
            if rowNum >= 0 {
                // one of our tableViews and the row number is specified
                let identifier = "row\(rowNum+1)"
                if let cellView = tableView.makeViewWithIdentifier(identifier, owner: self) as? NSTableCellView {
                    cellView.textField?.stringValue = actionTitles[rowNum]
                    cellView.identifier = identifier
                    return cellView
                }
            }
        }
        return nil
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if let object = notification.object as? NSTableView where object != self.tableView1 {
            return // some other table view changed its selection
        }
        // find which selection is now highlighted and invoke the appropriate action
        let rowOfView = self.tableView1.selectedRow
        if rowOfView < 0 {
            return // nothing is now selected
        }
        // HACK ALERT!
        // convert the row number (combined array) into a pair of indices for the arrays used by actionMap
        let numberOfRowsInSection1 = actionMap[0].count
        let numberOfRowsInSection2 = actionMap[1].count
        let section = rowOfView / numberOfRowsInSection1
        let row = rowOfView % numberOfRowsInSection1
        let path = NSIndexPath(indexes: [numberOfRowsInSection1, numberOfRowsInSection2], length: 2)
        // END HACK!
        let action = actionMap[section][row]
        action(selectedIndexPath: path)
        // cancel the selection
        tableView1.deselectRow(rowOfView)
    }
}

