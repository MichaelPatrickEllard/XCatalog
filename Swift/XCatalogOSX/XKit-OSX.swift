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

typealias XApplication = NSApplication

//var XApp = NSApp // which is NSApplication.sharedApplication()

enum XControlState {
    case Normal
    case Highlighted
    case Disabled
}

enum XControlEvents {
    case ValueChanged
    case TouchUpInside
}

typealias XControl = NSControl

extension XControl {
    
    func addTarget(targetX: AnyObject?,
        action actionX: Selector,
        forControlEvents controlEvents: XControlEvents) {
            target = targetX
            action = actionX
            // ignore the control events
    }
    
}

typealias XImage = NSImage

typealias XView = NSView

typealias XPopoverPresentationController = NSPopover

enum XPopoverArrowDirection {
    case Up, Down, Left, Right, Any, Unknown
}

extension XPopoverPresentationController {
    // extensions used to simulate alerts on iPad would require a class derived from NSViewController to control the NSAlert if done properly
    // The class would cache the three variables below and, if all were set, would call the NSPopover method:
    //   showRelativeToRect(_:ofView:preferredEdge:)
    // HACK: currently we will ignore these properties, since XKit's XAlertController doesn't implement its popoverPresentationController property
    var sourceRect: CGRect {
        get { return CGRect() }
        set { }
    }
    var sourceView: XView {
        get { return XView() }
        set { }
    }
    var permittedArrowDirections: XPopoverArrowDirection {
        get { return .Any }
        set { }
    }
}

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
        self.style = NSProgressIndicatorStyle.SpinningStyle // HACK: make sure the style is set properly for simple use cases
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
    var popoverPresentationController: XPopoverPresentationController? {
        get { return nil }
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
    
    var textFields: [AnyObject]? {
        // DESIGN NOTE: iOS allows multiple text fields per alert, but OS X only allows one: accessoryView
        // Proper implementation would need us to add that extra functionality but we're postponing making self a class as long as possible
        if let accessory = self.accessoryView {
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
                self.attributedTitle = NSAttributedString(string: title)
                self.tintColor = XColor.redColor()
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
        // copy our flags, title and attributes to the provided button as well
        button.enabled = enabled
        // BUG NOTE: in spite of the following, something in OS X sets this back to its default color before displaying
        button.attributedTitle = attributedTitle
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




//############################################
//##  Buttons                               ##
//############################################

typealias XButton = NSButton

enum XButtonType {
    case Custom
    case System
    case DetailDisclosure
    case InfoLight
    case InfoDark
    case ContactAdd
}

typealias XEdgeInsets = NSEdgeInsets

extension XButton
{
    var buttonTitle: String {
        return self.title
    }
    var backgroundColor: XColor {
        get {
            // get the font attributes from the first character of the attributed title
            let attrTitle = attributedTitle
            let len = min(1, attrTitle.length)
            let range = NSMakeRange(0, len)
            let attrs = attrTitle.fontAttributesInRange(range)
            var textColor = NSColor.controlTextColor()
            if attrs.count > 0 {
                textColor = attrs[NSBackgroundColorAttributeName] as! NSColor
            }
            return textColor
        }
        set {
            var attrTitle = NSMutableAttributedString(attributedString: attributedTitle)
            let range = NSMakeRange(0, attrTitle.length)
            attrTitle.addAttribute(NSBackgroundColorAttributeName, value: newValue, range: range)
            attrTitle.fixAttributesInRange(range)
            attributedTitle = attrTitle
        }
    }
    var tintColor: XColor {
        get {
            // get the font attributes from the first character of the attributed title
            let attrTitle = attributedTitle
            let len = min(1, attrTitle.length)
            let range = NSMakeRange(0, len)
            let attrs = attrTitle.fontAttributesInRange(range)
            var textColor = NSColor.controlTextColor()
            if attrs.count > 0 {
                textColor = attrs[NSForegroundColorAttributeName] as! NSColor
            }
            return textColor
        }
        set {
            var attrTitle = NSMutableAttributedString(attributedString: attributedTitle)
            let range = NSMakeRange(0, attrTitle.length)
            attrTitle.addAttribute(NSForegroundColorAttributeName, value: newValue, range: range)
            attrTitle.fixAttributesInRange(range)
            attributedTitle = attrTitle
        }
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
        default: break
        }
    }
    func setAttributedTitle( title: NSAttributedString!, forState state: XControlState ) {
        switch state {
        case .Normal: self.attributedTitle = title
        case .Highlighted: self.attributedAlternateTitle = title
        default: break
        }
    }
    func setImage( image: XImage?, forState state: XControlState ) {
        switch state {
        case .Normal: self.image = image
        case .Highlighted: self.alternateImage = image
        default: break
        }
    }

    // NOTE: edge insets are an unimplemented feature
    var imageEdgeInsets: XEdgeInsets {
        get { return XEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) }
        set { }
    }
    
    class func buttonWithType(type: XButtonType) -> AnyObject {
        return XButton()
    }
}

//############################################
//##  Colors                                ##
//############################################

typealias XColor = NSColor

typealias XColorView = NSColorWell

extension XColorView {
    var backgroundColor: XColor {
        get { return color }
        set { color = newValue }
    }
}

//############################################
//##  Image View                            ##
//############################################

class XImageView: NSImageView  {
    // MARK: XImageView - image animation feature interface
    /* NOTES
    - animationImages: array of images to animate
    - animationDuration: number of seconds for a full cycle of images to display (equal time for each)
    - startAnimating(): triggers the animation display
    -- The display of images will stop when the view is hidden, but the images and duration are retained
    -- The current index will be reset to the beginning when the images stop
    - Feature is designed to fail safely such that:
    -- If no images are provided (empty or nil array), nothing will be displayed and any animation will stop; this also works if animation is started but then cut short by manipulating the image list
    -- If objects are provided, each is tested and if not an XImage, animation will stop
    -- If only one image is provided, it will be displayed immediately and no animation will be started
    -- The provided duration in seconds is to display the entire list of images provided; thus the delay to the next image is (dynamically) calculated to be the duration / image count. If the image count varies over time, the delay will vary as well; more images means shorter delays.
    */
    var animationImages: [AnyObject]?
    var animationDuration: NSTimeInterval = 1.0 // time for complete cycle of images, in seconds
    
    func startAnimating() {
        imageScaling = .ImageScaleProportionallyUpOrDown
        animationHandler()
    }

    // MARK: XImageView - image animation feature implementation
    private var currentIndex: Int = 0
    private let MINIMUM_ANIMATION_DELAY: NSTimeInterval = 0.0 // set this to allow a speed limit if desired
    
    private var currentImage: XImage? {
        // make sure images array exists
        // make sure currentImageIndex is in range for it
        // make sure the object pointed to (currentImage) is an XImage
        // return that object if it exists, else return nil
        var currentImageInt: XImage?
        if let images = animationImages where currentIndex < images.count,
            let image = images[currentIndex] as? XImage {
            currentImageInt = image
        }
        return currentImageInt
    }
    
    private var imageCount: Int {
        return animationImages?.count ?? 0
    }
    
    private var imageDelayInNanoseconds: Int64 {
        let count = imageCount
        if count == 0 || animationDuration == 0.0 {
            return 0
        }
        let nsec = Int64(animationDuration) * 1000 * 1000 * 1000
        return nsec/Int64(count)
    }
    
    private func nextIndexNeedsDelay() -> Bool {
        // if nil/empty images array or array only has one entry, reset index to 0 and return F
        // else inc index w wraparound and return T signifying more than one image (needs delay)
        let count = imageCount
        if count > 1 {
            if ++currentIndex >= count {
                currentIndex = 0 // wraparound at max count
            }
            return true
        } else {
            currentIndex = 0 // auto-reset even if count changes
        }
        return false
    }
    
    func animationHandler() {
        // if images array exists and has at least one image, display it
        var okToDispatch = false
        let isImageVisible = !self.hidden // this was added as an easy way to determine if the image is onscreen
        // TBD: actually need to test if self is the last member of the view hierarchy of the NSApp mainWindow (I think?)
        if let image = currentImage where isImageVisible {
            // onscreen with an image provided
            self.image = image
            // also bump to next image, if it exists
            let oldIndex = currentIndex
            okToDispatch = nextIndexNeedsDelay()
            //println("Display image \(oldIndex+1); dispatch image \(currentIndex+1) of \(imageCount)")
        }
        else {
            //println("Display LAST image \(currentIndex+1) of \(imageCount)")
            // not onscreen (or only single image so no animation needed)
            //currentIndex = 0
        }
        // GCD: if valid time interval and diff image exists, dispatch async at the duration specified on main thread
        if okToDispatch && animationDuration > MINIMUM_ANIMATION_DELAY {
            let when = dispatch_time(DISPATCH_TIME_NOW, imageDelayInNanoseconds)
            dispatch_after(when, dispatch_get_main_queue(), animationHandler)
        }
    }
}

// MARK: XImageView - content mode color fill feature (NOT IMPLEMENTED)
enum XViewContentMode {
    // TBD: learn how to implement this feature and its related settings
    case ScaleAspectFit
}

extension XImageView {
    var contentMode: XViewContentMode {
        set { }
        get { return .ScaleAspectFit }
    }
    
    // If the image does not have the same aspect ratio as imageView's bounds, then imageView's backgroundColor will be applied to the "empty" space.
    var backgroundColor: XColor {
        set { }
        get { return XColor.whiteColor() }
    }
}

// MARK: XImageView - accessibility element feature
extension XImageView {
    // renaming conventions for accessibility labeling
    // these had to be renamed because the class has functions that conflict with the property getter/setter naming convention (see implementations of get/set for details)
    
    var currentIsAccessibilityElementValue: Bool {
        set { setAccessibilityElement(newValue) }
        get { return isAccessibilityElement() }
    }
    
    var currentAccessibilityLabel: String {
        // HACK: commandeered empty label to mean nil label; is this compatible with usage? check TBD
        set {
            if newValue.isEmpty {
                setAccessibilityLabel(nil)
            } else {
                setAccessibilityLabel(newValue)
            }
        }
        get { return accessibilityLabel() ?? "" }
    }
}

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
}

//############################################
//##  Label                                 ##
//############################################

typealias XLabel = NSTextField

extension XLabel
{
    var labelText: String {
        get {return self.stringValue}
        set {self.stringValue = newValue}
    }
    
    var tintColor: XColor {
        get { return XColor.blueColor() }
        set { }
    }
}

//############################################
//##  Page Control                          ##
//############################################

typealias XPageControl = NSLevelIndicator

extension XPageControl {
    /*
    This class will emulate a UIPageControl.
    Using NSLevelIndicator was a quick HACK that doesn't really work well.
    The default image (a star) would be used if not specifying a bullet image in IB.
    This control doesn't really match, because the current "level" isn't highlighted as such.
    Also, the image is only shown up to the "level", and spaces beyond are invisible/unshown.
    TintColor (from UIView) does not seem to be used in iOS, and will not be implemented.
    Actually, the level indicator has no facility to change the image color either.
    
    Perhaps an NSMatrix of NSRadioButton objects would be better? This would need a new class ...
    
    In the current implementation, I chose to use the value range 0...numberOfPages.
    However, I set the current page to map to values 1...numberOfPages since this has the desired effects of:
    1. always leaving one level image on-screen
    2. showing all the level images at the maximum setting
    Thus, I use the clampValueToRange() to make sure supplied page numbers are in the range set by the supplied numberOfPages, and to readjust the value to match when either the number of pages shrinks, or the current page is set out of range. In the latter case, it is clamped to the nearest edge rather than ignored. This is consistent with the documented functionality of UIPageControl.
    */
    var currentPage: Int {
        set {
            // set the current value of the control
            self.doubleValue = Double(newValue+1)
            clampValueToRange()
        }
        get { return Int(self.doubleValue)-1 }
    }
    var numberOfPages: Int {
        set {
            // SETUP: set the minimum and maximum values of the control
            maxValue = Double(newValue)
            minValue = 0
            clampValueToRange()
        }
        get { return Int(maxValue) }
    }
    private func clampValueToRange() {
        // range check: valid page numbers are from 0 to N-1, so valid values are from 1 to N
        let minLimit = 1.0
        if self.doubleValue < minLimit {
            self.doubleValue = minLimit
        }
        let maxLimit = maxValue
        if self.doubleValue >= maxLimit {
            self.doubleValue = maxLimit
        }
    }
    
    // NOTE: colors are not implemented yet
    var tintColor: XColor {
        set {
        }
        get { return XColor.whiteColor() }
    }
    var pageIndicatorTintColor: XColor {
        set {
        }
        get { return XColor.whiteColor() }
    }
    var currentPageIndicatorTintColor: XColor {
        set {
        }
        get { return XColor.whiteColor() }
    }
}

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

typealias XSlider = NSSlider

extension XSlider {
    var minimumValue: Double {
        get { return minValue }
        set { minValue = newValue}
    }

    var maximumValue: Double {
        get { return maxValue }
        set { maxValue = newValue }
    }

    // NOTE: if we use value here, we have a conflict with the NSObject selector of the same name (?)
    var currentValue: Double {
        get { return doubleValue }
        set { doubleValue = newValue}
    }

    // NOTE: track tint colors not implemented
    var minimumTrackTintColor: XColor {
        get { return XColor.blueColor() }
        set {
        }
    }
    var maximumTrackTintColor: XColor {
        get { return XColor.blueColor() }
        set {
        }
    }
    
    // NOTE: custom track and thumb images not implemented
    func setMinimumTrackImage( image: XImage?, forState: XControlState ) {
        // does nothing
    }
    func setMaximumTrackImage( image: XImage?, forState: XControlState ) {
        // does nothing
    }
    func setThumbImage( image: XImage?, forState: XControlState ) {
        // does nothing
    }
}

//############################################
//##  Stepper                               ##
//############################################

typealias XStepper = NSStepper

extension XStepper {
    var minimumValue: Double {
        get { return minValue }
        set { minValue = newValue}
    }
    
    var maximumValue: Double {
        get { return maxValue }
        set { maxValue = newValue }
    }
    
    var stepValue: Double {
        get { return increment }
        set { increment = newValue }
    }
    
    // NOTE: if we use value here, we have a conflict with the NSObject selector of the same name (?)
    var currentValue: Double {
        get { return doubleValue }
        set { doubleValue = newValue}
    }
    
    // NOTE: tint color not implemented
    var tintColor: XColor {
        get { return XColor.blueColor() }
        set {
        }
    }
    
    // NOTE: custom background, inc/dec, and divider images not implemented
    func setBackgroundImage( image: XImage?, forState: XControlState ) {
        // does nothing
    }
    func setIncrementImage( image: XImage?, forState: XControlState ) {
        // does nothing
    }
    func setDecrementImage( image: XImage?, forState: XControlState ) {
        // does nothing
    }
    func setDividerImage( image: XImage?, forLeftSegmentState: XControlState, rightSegmentState: XControlState ) {
        // does nothing
    }
}

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

typealias XTextField = NSTextField

protocol XTextFieldDelegate: NSTextFieldDelegate {
    // simulate UITextFieldDelegate protocol
    func textFieldShouldReturn(textField: XTextField) -> Bool
}

extension XTextField: NSTextFieldDelegate {
    // forward NSTextFieldDelegate methods to XTextFieldDelegate protocol
    
    public func control(control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
        println("func 1") // DEBUG
        // call the XTextFieldDelegate function here if the types are correct
        if let control = control as? XTextField,
            delegate = delegate as? XTextFieldDelegate {
                return delegate.textFieldShouldReturn(control)
        }
        return true
    }
    
    public func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        println("func 2") // DEBUG
        // call the XTextFieldDelegate function here if the types are correct
        if let control = control as? XTextField,
            delegate = delegate as? XTextFieldDelegate {
                return delegate.textFieldShouldReturn(control)
        }
        return true
    }
    
    public override func controlTextDidBeginEditing(obj: NSNotification) {
        println("func 3") // DEBUG
    }
    
    public override func controlTextDidChange(obj: NSNotification) {
        println("func 4") // DEBUG
    }
    
    public override func controlTextDidEndEditing(obj: NSNotification) {
        println("func 5") // DEBUG
    }
}

enum XTextAutocorrectionType {
    case Default, No, Yes
}
enum XReturnKeyType {
    case Default
    case Go
    case Google
    case Join
    case Next
    case Route
    case Search
    case Send
    case Yahoo
    case Done
    case EmergencyCall
}
enum XKeyboardType {
    case Default
    case ASCIICapable
    case NumbersAndPunctuation
    case URL
    case NumberPad
    case PhonePad
    case NamePhonePad
    case EmailAddress
    case DecimalPad
    case Twitter
    case WebSearch
}
enum XTextFieldViewMode {
    case Never, Always
}
enum XTextBorderStyle {
    case None
    case Line
    case Bezel
    case RoundedRect
}

extension XTextField {
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
    
    var placeholder: String? {
        get {
            if let cell = self.cell() as? NSTextFieldCell {
                return cell.placeholderString
            }
            return nil
        }
        set {
            if let cell = self.cell() as? NSTextFieldCell {
                cell.placeholderString = newValue
            }
        }
    }

    var borderStyle: XTextBorderStyle {
        get {
            if !bordered { return .None }
            if !bezeled { return .Line }
            if bezelStyle == .SquareBezel { return .Bezel }
            return .RoundedRect
        }
        set {
            switch newValue {
            case .RoundedRect:
                bordered = true
                bezeled = true
                bezelStyle = .RoundedBezel
            case .Bezel:
                bordered = true
                bezeled = true
                bezelStyle = .SquareBezel
            case .Line:
                bordered = true
                bezeled = false
            case .None:
                bordered = false
            default: break
            }
        }
    }
    
    // NOTE: these various customization features are not implemented
    var autocorrectionType: XTextAutocorrectionType {
        get { return .No }
        set { }
    }
    var returnKeyType: XReturnKeyType {
        get { return .Done }
        set { }
    }
    var keyboardType: XKeyboardType {
        get { return .Default }
        set { }
    }
    var clearButtonMode: XTextFieldViewMode {
        get { return .Never }
        set { }
    }
    
    var background: XImage? {
        get { return nil }
        set { }
    }
    var leftView: XView? {
        get { return nil }
        set { }
    }
    var rightView: XView? {
        get { return nil }
        set { }
    }
    var leftViewMode: XTextFieldViewMode {
        get { return .Never }
        set { }
    }
    var rightViewMode: XTextFieldViewMode {
        get { return .Never }
        set { }
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

typealias XStoryboardSegue = NSStoryboardSegue


//############################################
//##  Table View Controller                 ##
//############################################

typealias XTableViewController = NSViewController

typealias XTableView = NSTableView

private var lastUsedDelegateObject: XTableViewDSDelegate? // HACK: not scalable or thread-safe

extension XTableView {
    func deselectRowAtIndexPath(path: NSIndexPath, animated _:Bool) {
        let rvcs = NSApp.windowControllers
        let linearIndex = lastUsedDelegateObject?.getLinearIndex(path) ?? path.row // how do we get to the delegate or the VC from here??
        self.deselectRow(linearIndex)
    }
    
    func cellForRowAtIndexPath( path: NSIndexPath ) -> NSTableCellView? {
        let linearIndex = lastUsedDelegateObject?.getLinearIndex(path) ?? path.row // how do we get to the delegate or the VC from here??
        return self.viewAtColumn(0, row: linearIndex, makeIfNecessary: false) as? NSTableCellView
    }
}

extension XTableViewController {
    var tableView: XTableView! {
        // need to find the child of this view that is also an XTableView (there is only one in OS X)
        // it is recursively hidden in a subview of a subview
        return findTableView(self.view.subviews)
    }
    
    private func findTableView(views: [AnyObject]) -> NSTableView? {
        for view in views {
            if let tblView = view as? XTableView {
                return tblView
            } else if let view = view as? NSView, tblSubView = findTableView(view.subviews) {
                return tblSubView
            }
        }
        return nil // should not happen if the NIB has a table view in it
    }
    
    // DESIGN NOTE: As long as OS X does not have a working static table view controller, we have to simulate it here
    // The XIB sets up the basic table view, but we control the rows from here using this array of arrays
    // It must be structured the same as the intended simulated sections of the ported iOS code
    // For example, to simulate two sections, with 2 items in the first and 1 in the second, pass
    //    let titles = [[ "Title Sec 1 Row 1", "Title Sec 1 Row 2"], ["Title Sec 2 Row 1"]]
    // The actual NSTableView will have 3 rows addressed by a linear index internally, and we also simulate the UIKit extensions to NSIndexPath to support this
    // We override the NSTableViewDelegate method tableView:viewForTabelColumn:row to pass these titles to the tableView instantiated from the XIB
    // We override the NSTableViewDelegate method tableViewSelectionDidChange: to get the notice to pass to the XTableViewDelegate selection-change method
    func setupTitles( titles: [[String]]) {
        //self.init()
        let delegate = XTableViewDSDelegate(controller: self, items: titles)
        self.representedObject = delegate // HACK: commandeers this from user
    }
    
    var delegate: XTableViewDelegate? {
        get { return (self.representedObject as! XTableViewDSDelegate).delegate }
        set { (self.representedObject as! XTableViewDSDelegate).delegate = newValue }
    }
    
    // simulated UITableViewDataSource/Delegate protocol
    func tableView(tableView: XTableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
}

extension NSIndexPath {
    var section: Int {
        get { return self.indexAtPosition(1) }
    }
    var row: Int {
        get { return self.indexAtPosition(0) }
    }
    convenience init!(forRow row: Int,
        inSection section: Int) {
            self.init(indexes: [row, section], length: 2)
    }
}

protocol XTableViewDelegate {
    // simulated UITableViewDataSource/Delegate protocol (as used in XKit anyway)
    func tableView(tableView: XTableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
}

// this helps to implement the fiction of sections (iOS concept) for a 1-column NSTableView
class XTableViewDSDelegate: NSObject {
    var viewController: XTableViewController
    var items: [ [String] ] = []
    var delegate: XTableViewDelegate?
//    var counts: [Int] = {
//        return items.map { $0.count }
//    }
    
    init(controller: XTableViewController, items itms:[[String]]) {
        viewController = controller
        items = itms
        super.init()
        let tableView = controller.tableView
        tableView?.setDataSource(self)
        tableView?.setDelegate(self)
        lastUsedDelegateObject = self
    }
    
    func getIndexPath(linearIndex: Int) -> NSIndexPath? {
        let counts = items.map { $0.count }
        var val = linearIndex
        var tier = 0
        var secNum = 0
        var rowNum = 0
        for ct in counts {
            if val < tier + ct {
                // we're in this section
                let rowNum = val - tier
                return NSIndexPath(forRow: rowNum, inSection: secNum)
            }
            // val >= tier+ct (next section)
            tier += ct
            secNum++
        }
        // couldn't find a working path
        return nil
    }
    
    func getLinearIndex(path: NSIndexPath) -> Int {
        let counts = items.map { $0.count }
        let secNum = path.section
        let rowNum = path.row
        // sum the first secNum-1 counts, if any
        var tier = 0
        let limit = min(secNum, counts.count)
        for i in 0..<limit {
            tier += counts[i]
        }
        return tier + rowNum
    }
}

extension XTableViewDSDelegate: NSTableViewDataSource {
    // MARK: NSTableViewDataSource protocol compliance
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        let total = items.reduce(0) { sum, item in
            return sum + item.count
        }
        return total
    }
    
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        if let columnIdentifier = tableColumn?.identifier {
            // split row (linear) into rowNum/sectionNum
            let index = getIndexPath(row)
            if let rowNum = index?.row, secNum = index?.section {
                return items[secNum][rowNum]
            }
        }
        return nil
    }
}

extension XTableViewDSDelegate: NSTableViewDelegate {
    // MARK: NSTableViewDelegate protocol compliance

    // get the view to display
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let columnIdentifier = tableColumn?.identifier {
            // split row (linear) into rowNum/sectionNum
            let index = getIndexPath(row)
            if let rowNum = index?.row, secNum = index?.section {
                // one of our tableViews and the row number is specified
                let identifier = "row\(row+1)"
                if let cellView = tableView.makeViewWithIdentifier(identifier, owner: self) as? NSTableCellView {
                    cellView.textField?.stringValue = items[secNum][rowNum]
                    cellView.identifier = identifier
                    return cellView
                }
            }
        }
        return nil
    }

    // tell when a view has been selected
    func tableViewSelectionDidChange(notification: NSNotification) {
        if let tableView = notification.object as? NSTableView {
            // find which selection is now highlighted and invoke the appropriate action
            let rowOfView = tableView.selectedRow
            if rowOfView < 0 {
                return // nothing is now selected
            }
            // HACK ALERT!
            // convert the row number (combined array) into a pair of indices for the arrays used by actionMap
//            let numberOfRowsInSection1 = actionMap[0].count
//            let numberOfRowsInSection2 = actionMap[1].count
//            let section = rowOfView / numberOfRowsInSection1
//            let row = rowOfView % numberOfRowsInSection1
//            let path = NSIndexPath(indexes: [numberOfRowsInSection1, numberOfRowsInSection2], length: 2)
            // END HACK!
            //let action = actionMap[section][row]
            //action(selectedIndexPath: path)
            
            // cancel the selection automatically
            //tableView.deselectRow(rowOfView)
            
            // call the delegate extension routine defined by the XTableViewDelegate
            if let delegate = delegate, indexPath = getIndexPath(rowOfView) {
                delegate.tableView(tableView, didSelectRowAtIndexPath: indexPath)
            }
        }
    }
}

//############################################
//##  WebView                               ##
//############################################

import WebKit

typealias XWebView = WebView

protocol XWebViewDelegate {
}

extension NSApplication {
    var networkActivityIndicatorVisible: Bool {
        get { return false }
        set { }
    }
}

enum WebViewDetectorTypes {
    case All
}

extension XWebView {
    private func setup() {
        
    }
    
    func loadHTMLString( html: String, baseURL: NSURL? ) {
        self.mainFrame.loadHTMLString(html, baseURL: baseURL)
    }
    
    func loadRequest( request: NSURLRequest ) {
        self.mainFrame.loadRequest(request)
    }
    
    var dataDetectorTypes: WebViewDetectorTypes {
        get { return .All }
        set { setup() }
    }
    
    var scalesPageToFit: Bool {
        get { return true }
        set { setup() }
    }
}

extension XWebView {
    var backgroundColor: XColor {
        get { return XColor.whiteColor() }
        set { }
    }
}























