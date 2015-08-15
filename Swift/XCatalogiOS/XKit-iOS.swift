//
//  XKit-iOS.swift
//
//  Created by Rescue Mission Software on 7/9/15.
//
//

import UIKit

//############################################
//##  Common constants,enums,aliases        ##
//############################################

typealias XControlState = UIControlState

typealias XControlEvents = UIControlEvents

typealias XImage = UIImage

typealias XView = UIView

typealias XEdgeInsets = UIEdgeInsets

typealias XPopoverPresentationController = UIPopoverPresentationController

typealias XPopoverArrowDirection = UIPopoverArrowDirection
    
// These NSAttributedString names should be in Foundation but are duplicated in UIKit and AppKit
let XForegroundColorAttributeName = NSForegroundColorAttributeName
let XStrikethroughStyleAttributeName = NSStrikethroughStyleAttributeName
typealias XUnderlineStyle = NSUnderlineStyle
// End of NSAttributedString names used in XCatalog

//############################################
//##  Activity Indictor                     ##
//############################################

typealias XActivityIndicatorView = UIActivityIndicatorView

//############################################
//##  Alert Controller                      ##
//############################################
typealias XAlertController = UIAlertController

typealias XAlertHandler = (() -> ())
typealias XAlertTextField = UITextField
typealias XAlertTextFieldConfigurationHandler = ((XAlertTextField) -> ())
let XAlertTextFieldTextDidChangeNotification = UITextFieldTextDidChangeNotification

typealias XAlertAction = UIAlertAction
typealias XAlertActionStyle = UIAlertActionStyle

//############################################
//##  Buttons                               ##
//############################################

typealias XButton = UIButton

extension XButton
{
    var buttonTitle: String {
        if let value = titleLabel?.text {return value} else {return ""}
    }
    var xAccessibilityLabel: String? {
        // HACK: allow any label to be set, but ignore it; return empty string
        get { return self.accessibilityLabel ?? "" }
        set { self.accessibilityLabel = (newValue) }
    }
}

//############################################
//##  Colors                                ##
//############################################

typealias XColor = UIColor

//############################################
//##  Image View                            ##
//############################################


//############################################
//##  Date Picker                           ##
//############################################

typealias XDatePicker = UIDatePicker

//############################################
//##  Label                                 ##
//############################################

typealias XLabel = UILabel

extension XLabel
{
    var labelText: String
        {
        get {if let value = text {return value} else {return ""}}
        set {text = newValue}
    }
}


//############################################
//##  Page Control                          ##
//############################################


//############################################
//##  Picker View                           ##
//############################################


//############################################
//##  Progress View Controller              ##
//############################################

typealias XProgressView = UIProgressView

enum ProgressViewStyle {
    case Thin
    case Thick
    case Tinted
}

extension XProgressView {
    
    var progressStyle: ProgressViewStyle {
        get {return .Thin} // Should be expanded to cover other casese
        set {
            
            switch newValue {
            case .Thin:
                self.progressViewStyle = .Default
                
            case .Thick:
                self.progressViewStyle = .Bar
                
            case .Tinted:
                self.progressViewStyle = .Default
                
                self.trackTintColor = XColor.applicationBlueColor()
                self.progressTintColor = XColor.applicationPurpleColor()
            }
        }
    }
    
    func advance(amount: Double)
    {
        self.setProgress(Float(amount), animated: true)
    }
}


//############################################
//##  Segmented Control                     ##
//############################################


//############################################
//##  Slider                                ##
//############################################

typealias XSlider = UISlider

extension XSlider {
    var currentValue: Double {
        get { return Double(value) }
        set { value = Float(newValue) }
    }
}


//############################################
//##  Stepper                               ##
//############################################

typealias XStepper = UIStepper

extension XStepper {
    var currentValue: Double {
        get { return (value) }
        set { value = (newValue) }
    }
}

//############################################
//##  Switch / Checkbox                     ##
//############################################

typealias XSwitchBox = UISwitch

extension XSwitchBox
{
    func setAction(action: Selector, target: AnyObject)
    {
        addTarget(target, action: action, forControlEvents: .ValueChanged)
    }
    
    func setOnState(isOn: Bool)
    {
        self.setOn(true, animated: false)
    }
    
    func setColorScheme(tint: XColor, onTint: XColor, thumbTint: XColor)
    {
        self.tintColor = tint
        self.onTintColor = onTint
        self.thumbTintColor = thumbTint
    }
}

//############################################
//##  TextField                             ##
//############################################

typealias XTextField = UITextField
typealias XTextFieldDelegate = UITextFieldDelegate


//############################################
//##  TextView                              ##
//############################################



//############################################
//##  View Controllers                      ##
//############################################

typealias XViewController = UIViewController

typealias XDisplayController = UITableViewController

typealias XStoryboardSegue = UIStoryboardSegue


//############################################
//##  Table View Controller                 ##
//############################################

typealias XTableViewController = UITableViewController
typealias XTableViewDelegate = UITableViewDelegate
typealias XTableView = UITableView

extension XTableViewController {
    
    // DESIGN NOTE: No need for implementing the simulated static table view under iOS
    func setupTitles( titles: [[String]]) {
    }
    
    var delegate: XTableViewDelegate? {
        get { return nil }
        set { }
    }
}

//############################################
//##  WebView                               ##
//############################################




