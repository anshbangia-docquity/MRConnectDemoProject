//
//  CheckPasswordItem.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 05/02/22.
//

import UIKit
import BLTNBoard

@objc public class CheckPasswordItem: BLTNPageItem, UITextFieldDelegate {

    public lazy var passField = UITextField()
    @objc public var textInputHandler: ((CheckPasswordItem, String) -> Void)? = nil
        
    override public func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        passField.placeholder = MyStrings.password
        passField.borderStyle = UITextField.BorderStyle.roundedRect
        passField.autocorrectionType = UITextAutocorrectionType.no
        passField.keyboardType = UIKeyboardType.default
        passField.textContentType = .password
        passField.autocapitalizationType = .none
        passField.returnKeyType = UIReturnKeyType.done
        passField.isSecureTextEntry = true
        
        passField.delegate = self
        
        return [passField]
    }
    
    override public func actionButtonTapped(sender: UIButton) {
        passField.endEditing(true)
        super.actionButtonTapped(sender: sender)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField.text ?? "") != CurrentUser().password {
            descriptionLabel!.textColor = .red
            descriptionLabel!.text = MyStrings.invalidPassword
            textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            return false
        } else {
            return true
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textInputHandler?(self, textField.text!)
    }
    
    override public func tearDown() {
        super.tearDown()
        passField.delegate = nil
    }

}
