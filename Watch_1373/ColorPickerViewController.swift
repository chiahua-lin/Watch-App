//
//  ColorPickerViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 5/1/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController, RSColorPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var colorPicker: RSColorPickerView!
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        colorPicker.selectionColor = RSRandomColorOpaque(true)
        colorPicker.delegate = self
        colorPicker.brightness = 1.0
        addKeyboardToolbar()
        // Do any additional setup after loading the view.
    }

    func colorPickerDidChangeSelection(colorPicker: RSColorPickerView!) {
        let color = colorPicker.selectionColor
        var red:   CGFloat = 0
        var blue:  CGFloat = 0
        var green: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        redTextField.text   = "\(UInt32(red   * 255))"
        blueTextField.text  = "\(UInt32(blue  * 255))"
        greenTextField.text = "\(UInt32(green * 255))"
        
        sendColor(colorPicker.selectionColor)
    }

    func colorPicker(colorPicker: RSColorPickerView!, touchesEnded touches: Set<NSObject>!, withEvent event: UIEvent!) {
        sendColor(colorPicker.selectionColor)
    }

    func sendColor(color: UIColor) {
        let watchLink = BluetoothWatchLink.sharedInstance()
        if watchLink.canSendMessage {
            let message = ColorPickerMsg_t(color: color)
            watchLink.sendMessage(message, label: "Color Selection")
        } else {
            UIAlertController.stub(presentFrom: self, text: "BluetoothWatchLink is not able to send a packet right now.")
        }
    }
    
    func addKeyboardToolbar() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let titleTextAttributes = [NSForegroundColorAttributeName : JardenColor.teal]
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let nextBarButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: Selector("nextTextField"))
        nextBarButton.setTitleTextAttributes(titleTextAttributes, forState: .Normal)
        
        keyboardToolbar.items = [flexBarButton, nextBarButton]
        redTextField.inputAccessoryView = keyboardToolbar
        greenTextField.inputAccessoryView = keyboardToolbar
        let finalKeyboardToolbar = UIToolbar()
        finalKeyboardToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("end:"))
        doneButton.setTitleTextAttributes(titleTextAttributes, forState: .Normal)
        finalKeyboardToolbar.items = [flexBarButton, doneButton]
        blueTextField.inputAccessoryView = finalKeyboardToolbar
    }
    
    func nextTextField() {
        if redTextField.isFirstResponder() {
            greenTextField.becomeFirstResponder()
        } else {
            blueTextField.becomeFirstResponder()
        }
    }
    
    func end(sender: UITextField) {
        blueTextField.resignFirstResponder()
        let redFloat   = CGFloat((redTextField.text.toInt()   as Int?) ?? 0)
        let greenFloat = CGFloat((greenTextField.text.toInt() as Int?) ?? 0)
        let blueFloat  = CGFloat((blueTextField.text.toInt()  as Int?) ?? 0)
        colorPicker.selectionColor = UIColor(red: redFloat/255.0, green: greenFloat/255.0, blue: blueFloat/255.0, alpha: 1.0)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let endString = textField.text.stringByAppendingString(string) as NSString
        let floatValue = endString.floatValue

        if floatValue <= 255 {
            return true
        } else {
            return false
        }
    }
}
