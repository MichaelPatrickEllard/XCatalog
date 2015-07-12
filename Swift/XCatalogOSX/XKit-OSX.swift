//
//  File.swift
//
//  Created by Rescue Mission Software on 7/9/15.
//
//

import AppKit

typealias XViewController = NSViewController

typealias XButton = NSButton

typealias XLabel = NSTextField

typealias XStoryboardSegue = NSStoryboardSegue

typealias XDatePicker = NSDatePicker

typealias XColor = NSColor

typealias XDisplayController = NSViewController

typealias XProgressView = NSProgressIndicator

typealias XSwitchBox = NSButton

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


//typealias XPageController = NSPageController

//typealias XImageView = NSImageView

//typealias XImage = NSImage

extension XLabel
{
    var labelText: String {
        get {return self.stringValue}
        set {self.stringValue = newValue}
    }
}

extension XButton
{
    var buttonTitle: String {
        return self.title
    }
}

enum XDatePickerMode : Int {
    
    case Time // Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
    case Date // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
    case DateAndTime // Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
    case CountDownTimer // Displays hour and minute (e.g. 1 | 53)
}

enum XControlEvents {
    case ValueChanged
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
            case .Date: self.datePickerElements = NSDatePickerElementFlags.YearMonthDatePickerElementFlag
            case .DateAndTime: self.datePickerElements = NSDatePickerElementFlags.HourMinuteSecondDatePickerElementFlag | NSDatePickerElementFlags.YearMonthDatePickerElementFlag
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
            // ignore the control events (??)
    }
}

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