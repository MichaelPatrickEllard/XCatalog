//
//  AlertControllerViewController.swift
//  XCatalog
//
//  Created by Rescue Mission Software on 7/11/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import Cocoa

class AlertControllerViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var tableView2: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        /*
        // Following feature was introduced in Yosemite and doesn't work yet (file radar?)
        tableView.usesStaticContents = true
        tableView2.usesStaticContents = true
        */
        tableView.setDataSource(self)
        tableView2.setDataSource(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Do view setup here.
        /*
        // Following feature was introduced in Yosemite and doesn't work yet (file radar?)
        tableView.usesStaticContents = true
        tableView2.usesStaticContents = true
        */
        tableView.setDataSource(self)
        tableView2.setDataSource(self)
    }

    
    /// Show an alert with an "Okay" button.
//    func showSimpleAlert(_: NSIndexPath) {
//        let title = NSLocalizedString("A Short Title is Best", comment: "")
//        let message = NSLocalizedString("A message should be a short, complete sentence.", comment: "")
//        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
//        
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
//        
//        // Create the action.
//        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
//            NSLog("The simple alert's cancel action occured.")
//        }
//        
//        // Add the action.
//        alertController.addAction(cancelAction)
//        
//        presentViewController(alertController, animated: true, completion: nil)
//    }
    
}

extension AlertControllerViewController: NSTableViewDataSource {
    // MARK: NSTableViewDataSource protocol compliance
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if tableView === self.tableView {
            return 7
        }
        if tableView === self.tableView2 {
            return 2
        }
        return 0
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let columnIdentifier = tableColumn?.identifier {
            var rowNum = -1
            if tableView === self.tableView {
                rowNum = row
            }
            if tableView === self.tableView2 {
                rowNum = row + numberOfRowsInTableView(self.tableView) // 5
            }
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
    
}

extension AlertControllerViewController: NSTableViewDelegate {
    // MARK: NSTableViewDelegate protocol compliance
}

