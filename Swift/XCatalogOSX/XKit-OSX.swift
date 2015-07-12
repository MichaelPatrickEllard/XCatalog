//
//  File.swift
//
//  Created by Rescue Mission Software on 7/9/15.
//
//

import AppKit


//############################################
//##  Common constants,enums,aliases        ##
//############################################

enum XControlState {
    case Normal
    case Highlighted
}

enum XControlEvents {
    case ValueChanged
    case TouchUpInside
}

typealias XImage = NSImage

// These NSAttributedString names should be in Foundation but are duplicated in UIKit and AppKit
let XForegroundColorAttributeName = NSForegroundColorAttributeName
let XStrikethroughStyleAttributeName = NSStrikethroughStyleAttributeName
//typealias XUnderlineStyle = NSUnderlineStyle
enum XUnderlineStyle : Int {
    case StyleNone
    case StyleSingle
    case StyleThick
    case StyleDouble
    case PatternDot
    case PatternDash
    case PatternDashDot
    case PatternDashDotDot
    case ByWord
}
// End of NSAttributedString names used in XCatalog


//############################################
//##  Activity Indictor                     ##
//############################################

typealias XActivityIndicatorView = NSProgressIndicator

enum XActivityIndicatorViewStyle {
    // This is for our purposes; a better design might be to use .White and .WhiteLarge and implement the size changes too
    // We still don't have the capability of setting any old color (I think)
    case Gray
    case Tinted
}

extension XActivityIndicatorView {
    //    convenience init() {
    //        self.init()
    //        self.style = NSProgressIndicatorStyle.SpinningStyle
    //    }
    var activityIndicatorViewStyle: XActivityIndicatorViewStyle {
        get {
            switch self.controlTint {
            case .DefaultControlTint: return .Gray
            case .BlueControlTint: return .Tinted
            default: return .Gray
            }
        }
        set {
            // HACK: since I can't figure out how to do an init() here, we must require a style to be set; luckily the XCatalog code does this
            self.style = NSProgressIndicatorStyle.SpinningStyle
            switch newValue {
            case .Gray:
                self.controlTint = .DefaultControlTint
            case .Tinted:
                self.controlTint = .BlueControlTint
            }
        }
    }
    var color: XColor {
        // HACK: allow any color to be set, but make it Tinted
        get { return XColor.blueColor() }
        set {
            activityIndicatorViewStyle = .Tinted
        }
    }
    func startAnimating() {
        self.startAnimation(self)
    }
    var hidesWhenStopped: Bool {
        get { return !self.displayedWhenStopped }
        set { self.displayedWhenStopped = !newValue }
    }
}


//############################################
//##  Alert Controller                      ##
//############################################



//############################################
//##  Buttons                               ##
//############################################

typealias XButton = NSButton

extension XButton
{
    var buttonTitle: String {
        return self.title
    }
    var backgroundColor: XColor {
        // HACK: allow any color to be set, but ignore it; return blue
        get { return XColor.blueColor() }
        set { }
    }
    var tintColor: XColor {
        // HACK: allow any color to be set, but ignore it; return blue
        get { return XColor.blueColor() }
        set { }
    }
    var xAccessibilityLabel: String? {
        // HACK: allow any label to be set, but ignore it; return empty string
        get { return self.accessibilityLabel() ?? "" }
        set { self.setAccessibilityLabel(newValue)}
    }
    func setTitle( title: String!, forState state: XControlState ) {
        switch state {
        case .Normal: self.title = title
        case .Highlighted: self.alternateTitle = title
        }
    }
    func setAttributedTitle( title: NSAttributedString!, forState state: XControlState ) {
        switch state {
        case .Normal: self.attributedTitle = title
        case .Highlighted: self.attributedAlternateTitle = title
        }
    }
    func setImage( image: XImage?, forState state: XControlState ) {
        switch state {
        case .Normal: self.image = image
        case .Highlighted: self.alternateImage = image
        }
    }
    func addTarget(targetX: AnyObject?,
        action actionX: Selector,
        forControlEvents controlEvents: XControlEvents) {
            target = targetX
            action = actionX
            // ignore the control events
    }
}

//############################################
//##  Colors                                ##
//############################################

typealias XColor = NSColor

//############################################
//##  Image View                            ##
//############################################


//############################################
//##  Date Picker                           ##
//############################################

typealias XDatePicker = NSDatePicker

enum XDatePickerMode : Int {
    
    case Time // Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
    case Date // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
    case DateAndTime // Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
    case CountDownTimer // Displays hour and minute (e.g. 1 | 53)
}

extension XDatePicker {
    var datePickerMode: XDatePickerMode {
        /* translation property:
        .Time <=> HourMinuteSecondDatePickerElementFlag
        .Date <=>YearMonthDatePickerElementFlag
        .CountDownTimer - not implemented yet
        */
        get {
            let hasDate = (0 != (self.datePickerElements.rawValue & NSDatePickerElementFlags.YearMonthDatePickerElementFlag.rawValue))
            let hasTime = (0 != (self.datePickerElements.rawValue & NSDatePickerElementFlags.YearMonthDatePickerElementFlag.rawValue))
            switch (hasDate, hasTime) {
            case (true, true): return .DateAndTime
            case (true, false): return .Date
            case (false, true): return .Time
            default: return .CountDownTimer // well, rather .Unknown or maybe default (.Date?)
            }
        }
        set {
            switch newValue {
            case .Time: self.datePickerElements = NSDatePickerElementFlags.HourMinuteSecondDatePickerElementFlag
            case .Date: self.datePickerElements = NSDatePickerElementFlags.YearMonthDayDatePickerElementFlag
            case .DateAndTime: self.datePickerElements = NSDatePickerElementFlags.HourMinuteSecondDatePickerElementFlag | NSDatePickerElementFlags.YearMonthDayDatePickerElementFlag
            case .CountDownTimer: break // this may require more complicated stuff
            }
        }
    }
    var date: NSDate {
        get { return dateValue }
        set { dateValue = newValue }
    }
    var minimumDate: NSDate? {
        get { return minDate }
        set { minDate = newValue }
    }
    var maximumDate: NSDate? {
        get { return maxDate }
        set { maxDate = newValue }
    }
    var minuteInterval: Int {
        get { return 1 }
        set { }
    }
    func addTarget(targetX: AnyObject?,
        action actionX: Selector,
        forControlEvents controlEvents: XControlEvents) {
            target = targetX
            action = actionX
            // ignore the control events
    }
}

//############################################
//##  Label                                 ##
//############################################




//############################################
//##  Page Control                          ##
//############################################


//############################################
//##  Picker View                           ##
//############################################


//############################################
//##  Progress View Controller              ##
//############################################

typealias XProgressView = NSProgressIndicator

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
                self.style = .BarStyle
                self.controlTint = .DefaultControlTint
                
            case .Thick:
                self.style = .BarStyle
                self.controlTint = .ClearControlTint
                
            case .Tinted:
                self.style = .BarStyle
                self.controlTint = .BlueControlTint
            }
        }
    }
    
    func advance(amount: Double)
    {
        self.incrementBy(amount * 2)    // Note:  Check into why the *2 is needed...
    }
}

//############################################
//##  Segmented Control                     ##
//############################################


//############################################
//##  Slider                                ##
//############################################


//############################################
//##  Stepper                               ##
//############################################


//############################################
//##  Switch / Checkbox                     ##
//############################################

typealias XSwitchBox = NSButton

extension XSwitchBox
{
    func setAction(action: Selector, target: AnyObject)
    {
        self.action = action
        self.target = target
    }
    
    func setOnState(isOn: Bool)
    {
        if (isOn)
        {
            self.state = NSOnState
        }
        else
        {
            self.state = NSOffState
        }
    }
    
    func setColorScheme(tint: XColor, onTint: XColor, thumbTint: XColor)
    {
        NSLog("Switchbox colors aren't used on the OS X side, where the interface is very different")
    }
}

//############################################
//##  TextField                             ##
//############################################

typealias XLabel = NSTextField

extension XLabel
{
    var labelText: String {
        get {return self.stringValue}
        set {self.stringValue = newValue}
    }
}

//############################################
//##  TextView                              ##
//############################################



//############################################
//##  View Controllers                      ##
//############################################

typealias XViewController = NSViewController

typealias XDisplayController = NSViewController

typealias XTableViewController = NSViewController

typealias XStoryboardSegue = NSStoryboardSegue

//############################################
//##  WebView                               ##
//############################################































