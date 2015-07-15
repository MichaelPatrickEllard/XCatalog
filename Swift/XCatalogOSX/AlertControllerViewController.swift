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
    //@IBOutlet weak var tableView2: NSTableView!
    
    // A matrix of closures that should be invoked based on which table view cell is
    // tapped (index by section, row).
    var actionMap: [[(selectedIndexPath: NSIndexPath) -> Void]] {
        return [
            // Alert style alerts.
            [
                self.showSimpleAlert, //
                self.showSimpleAlert, // self.showOkayCancelAlert,
                self.showSimpleAlert, // self.showOtherAlert,
                self.showSimpleAlert, // self.showTextEntryAlert,
                self.showSimpleAlert, // self.showSecureTextEntryAlert
            ],
            // Action sheet style alerts.
            [
                self.showSimpleAlert, // self.showOkayCancelActionSheet,
                self.showSimpleAlert, // self.showOtherActionSheet
            ]
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        /*
        // Following feature was introduced in Yosemite and doesn't work yet (file radar?)
        tableView.usesStaticContents = true
        tableView2.usesStaticContents = true
        */
        tableView1.setDataSource(self)
    //    tableView2.setDataSource(self)
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Do view setup here.
//        /*
//        // Following feature was introduced in Yosemite and doesn't work yet (file radar?)
//        tableView.usesStaticContents = true
//        tableView2.usesStaticContents = true
//        */
//        tableView1.setDataSource(self)
//    //    tableView2.setDataSource(self)
//    }

    /// Show an alert with an "Okay" button.
    func showSimpleAlert(_: NSIndexPath) {
        let title = NSLocalizedString("A Short Title is Best", comment: "")
        let message = NSLocalizedString("A message should be a short, complete sentence.", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = XAlert(title: title, message: message, preferredStyle: .Alert)
        
        // Create the action.
        let cancelAction = XAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("The simple alert's cancel action occured.")
        }
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        presentViewControllerEx(alertController, animated: true, completion: nil)
    }
    
}

typealias XAlert = NSAlert

enum XAlertStyle {
    case Alert, ActionSheet
}

extension XAlert {
    convenience init(title: String, message: String, preferredStyle: XAlertStyle) {
        self.init()
        self.messageText = title
        self.informativeText = message
        // TOTAL HACK WARNING!
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
    }
}

typealias XAlertHandler = (() -> ())
func presentViewControllerEx( controller: XAlert, #animated: Bool, #completion: XAlertHandler? ) {
    // this is where we use controller to run modally or with the action sheet
    if controller.alertStyle == NSAlertStyle.WarningAlertStyle {
        controller.runModal()
    } else if controller.alertStyle == .InformationalAlertStyle {
        let oldStyle = controller.alertStyle
        controller.alertStyle = .CriticalAlertStyle // temporarily makes the sheet appear over top of any already in use (??)
        controller.beginSheetModalForWindow(controller.window as! NSWindow) { response/*: NSModalResponse*/ in
            // this is the wrapper to call  the dispatch table??
            // first we need to call end
        }
        controller.alertStyle = oldStyle // then put it right back to what it was (subverted)
        // call the completion handler now, not when sheet modal is done
        if let completion = completion {
            completion()
        }
    }
}

typealias XAlertAction = XButton

enum XAlertActionStyle {
    case Default, Cancel
}

extension XAlertAction {
    convenience init( title: String?, style: XAlertActionStyle, completion: ((NSNotification) -> ())? = nil) {
        // add a button with the given action (target: self?)
        // unfortunately, action MUST be a selector on OSX - OK so which object? well for THIS code, it's the given AlertControllerViewController object
        // hard coding this prevents class use in an actual framework situation, though
        // time to give up? use global private variables? (HACK! HACK!)
        // well NSAlert's beginSheetModalForWindow is compatible with block completion handlers, but requires (A) a call to endSheetModal after, and (B) happens at runModal() time, after all actions added; still, it's our best shot...
        // BUT...
        // each button must have its own action closure, so one closure for the NSAlert would have to manage a dispatch table, which exists for each XAlert
        // this really does imply XAlert must be a derived class, else we are creating tables of data (pseudo-objects) and keeping track of them with dictionaries
        self.init()
        if let title = title {
            self.title = title
        }
        // TBD: do something to convert the Cancel style into the appropriate tintColor (maybe?) or whatever
        switch style {
        case .Cancel:
            // NSAlert relies on button titles for behavior!
            self.title = "Cancel"
        default:
            break // title is already set ("Ok" and "Don't Save" are also special)
        }
        // TBD: Action dispatch table to deal with completion
        // TOTAL HACK WARNING!
        // steps:
        // -Find or create a dispatch table for the appropriate VC (where do we get this target? it's not passed here... yet...)
        // -Add an entry for this alert action, saving the target (self, or whatever would be used at runtime) vs. the completion routine
        // -give the title to the button that we are
        // -what to do with the style?
        // -add the button's target/action to a routine that can figure out the dispatch table
        // END HACK!
    }
}

extension AlertControllerViewController: NSTableViewDataSource {
    // MARK: NSTableViewDataSource protocol compliance
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if tableView === self.tableView1 {
            return 7
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
                    cellView.textField?.stringValue = "TEST\(rowNum+1)"
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

