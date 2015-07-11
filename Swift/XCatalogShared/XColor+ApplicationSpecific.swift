/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Application-specific color convenience methods.
*/

extension XColor {
    class func applicationGreenColor() -> XColor {
        return XColor(red: 0.255, green: 0.804, blue: 0.470, alpha: 1)
    }

    class func applicationBlueColor() -> XColor {
        return XColor(red: 0.333, green: 0.784, blue: 1, alpha: 1)
    }

    class func applicationPurpleColor() -> XColor {
        return XColor(red: 0.659, green: 0.271, blue: 0.988, alpha: 1)
    }
}
