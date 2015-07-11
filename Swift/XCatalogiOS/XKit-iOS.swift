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