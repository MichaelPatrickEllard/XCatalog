//
//  XKit-iOS.swift
//
//  Created by Rescue Mission Software on 7/9/15.
//
//

import UIKit

typealias XViewController = UIViewController

typealias XButton = UIButton

typealias XLabel = UILabel

typealias XStoryboardSegue = UIStoryboardSegue

typealias XDatePicker = UIDatePicker

typealias XColor = UIColor

typealias XDisplayController = UITableViewController

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

//typealias XPageController = UIPageController

//typealias XImageView = UIImageView

//typealias XImage = UIImage

extension XLabel
{
    var labelText: String
    {
        get {if let value = text {return value} else {return ""}}
        set {text = newValue}
    }
}

extension XButton
{
    var buttonTitle: String {
        if let value = titleLabel?.text {return value} else {return ""}
    }
}