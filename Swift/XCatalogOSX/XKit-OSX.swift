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