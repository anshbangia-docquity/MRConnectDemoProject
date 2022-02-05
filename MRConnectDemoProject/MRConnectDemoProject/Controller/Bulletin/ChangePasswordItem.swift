//
//  ChangePasswordItem.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 05/02/22.
//

import UIKit
import BLTNBoard

@objc public class ChangePasswordItem: BLTNPageItem, UITextFieldDelegate {

    public lazy var passField = UITextField()
    public lazy var confirmPassField = UITextField()
        
    override public func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        passField.placeholder = MyStrings.newPassword
        passField.borderStyle = UITextField.BorderStyle.roundedRect
        passField.autocorrectionType = UITextAutocorrectionType.no
        passField.keyboardType = UIKeyboardType.default
        passField.textContentType = .password
        passField.autocapitalizationType = .none
        passField.returnKeyType = UIReturnKeyType.done
        passField.isSecureTextEntry = true
        
        confirmPassField.placeholder = MyStrings.confirmNewPass
        confirmPassField.borderStyle = UITextField.BorderStyle.roundedRect
        confirmPassField.autocorrectionType = UITextAutocorrectionType.no
        confirmPassField.keyboardType = UIKeyboardType.default
        confirmPassField.textContentType = .password
        confirmPassField.autocapitalizationType = .none
        confirmPassField.returnKeyType = UIReturnKeyType.done
        confirmPassField.isSecureTextEntry = true
        
        passField.delegate = self
        confirmPassField.delegate = self
        
        return [passField, confirmPassField]
    }
    
    override public func actionButtonTapped(sender: UIButton) {
        passField.backgroundColor = .clear
        confirmPassField.backgroundColor = .clear
        if passField.text == nil || passField.text!.count < 6 {
            descriptionLabel!.text = MyStrings.passNeeds6Char
            passField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            return
        }
        if confirmPassField.text != passField.text {
            descriptionLabel!.text  = MyStrings.confirmPassNotMatch
            confirmPassField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            return
        }
        
        super.actionButtonTapped(sender: sender)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    override public func tearDown() {
        super.tearDown()
        passField.delegate = nil
        confirmPassField.delegate = nil
    }

}
