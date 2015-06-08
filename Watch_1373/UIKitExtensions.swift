//
//  UIKitExtensions.swift
//  Watch_1373
//
//  Created by Robert Haworth on 2/24/15.
//  Copyright (c) 2015 Robert Haworth. All rights reserved.
//

import UIKit

/**
 * This enum includes a list of fonts that are garaunteed to be present at runtime, allowing bypass of the failable
 * initializer.
 */
enum FontFace: String {
    case GothamLight  = "Gotham-Light"
    case GothamBook   = "Gotham-Book"
    case GothamMedium = "Gotham-Medium"
    case GothamBold   = "Gotham-Bold"
}

extension UIFont {

    static func withFace(face: FontFace, size: CGFloat) -> UIFont {
        if let font = UIFont(name: face.rawValue, size: size) {
            return font
        } else {
            LSRLog(.UserInterface, .Error, "Font listed in FontFace enum is not installed properly! Returning system font.")
            return UIFont.systemFontOfSize(size)
        }
    }

}

extension UIAlertController {

    static func stub(presentFrom controller: UIViewController, text: String, action: ((UIAlertAction!) -> ()) = {_ in return}) {
        let alert = UIAlertController(title: "Stub", message: text, preferredStyle: .Alert)

        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: action))

        controller.presentViewController(alert, animated: true, completion: nil)
    }

}

extension UIGestureRecognizerState : Printable {

    public var description: String { switch self {
        case .Possible:   return ".Possible"
        case .Began:      return ".Began"
        case .Changed:    return ".Changed"
        case .Cancelled:  return ".Cancelled"
        case .Failed:     return ".Failed"
        case .Ended:      return ".Ended"
    }}

}
