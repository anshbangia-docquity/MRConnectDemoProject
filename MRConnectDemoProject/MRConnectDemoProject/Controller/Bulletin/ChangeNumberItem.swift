//
//  ChangePasswordItem.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 05/02/22.
//

import UIKit
import BLTNBoard

@objc public class ChangeNumberItem: BLTNPageItem {

    public lazy var numField = UITextField()
    @objc public var textInputHandler: ((String) -> Void)? = nil
        
    override public func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        numField.placeholder = MyStrings.contact
        numField.borderStyle = UITextField.BorderStyle.roundedRect
        numField.autocorrectionType = UITextAutocorrectionType.no
        numField.keyboardType = UIKeyboardType.phonePad
        numField.textContentType = .telephoneNumber
        numField.autocapitalizationType = .none
        numField.returnKeyType = UIReturnKeyType.done
        
        numField.delegate = self
        
        return [numField]
    }
    
    override public func actionButtonTapped(sender: UIButton) {
        numField.endEditing(true)
        super.actionButtonTapped(sender: sender)
    }
    
    override public func tearDown() {
        super.tearDown()
        numField.delegate = nil
    }

}

extension ChangeNumberItem: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == nil || textField.text!.isEmpty {
            descriptionLabel!.textColor = .red
            descriptionLabel!.text = MyStrings.emptyFieldAlertTitle.replacingOccurrences(of: "|#X#|", with: MyStrings.contact)
            textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            return false
        } else {
            return true
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textInputHandler?(textField.text!)
    }
}
