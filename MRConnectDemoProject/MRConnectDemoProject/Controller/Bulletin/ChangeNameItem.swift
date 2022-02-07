//
//  ChangeNameItem.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 05/02/22.
//

import UIKit
import BLTNBoard

@objc public class ChangeNameItem: BLTNPageItem, UITextFieldDelegate {

    public lazy var nameField = UITextField()
    @objc public var textInputHandler: ((String) -> Void)? = nil
        
    override public func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        nameField.placeholder = MyStrings.newName
        nameField.borderStyle = UITextField.BorderStyle.roundedRect
        nameField.autocorrectionType = UITextAutocorrectionType.no
        nameField.keyboardType = UIKeyboardType.default
        nameField.textContentType = .name
        nameField.autocapitalizationType = .words
        nameField.returnKeyType = UIReturnKeyType.done
        
        nameField.delegate = self
        
        return [nameField]
    }
    
    override public func actionButtonTapped(sender: UIButton) {
        nameField.endEditing(true)
        super.actionButtonTapped(sender: sender)
    }
    
    @objc open func isInputValid(text: String?) -> Bool {
        if text == nil || text!.isEmpty {
            return false
        }

        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if !isInputValid(text: textField.text) {
            descriptionLabel!.textColor = .red
            descriptionLabel!.text = MyStrings.emptyFieldAlertTitle.replacingOccurrences(of: "|#X#|", with: MyStrings.newName)
            textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            return false
        } else {
            return true
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textInputHandler?(textField.text!)
    }
    
    override public func tearDown() {
        super.tearDown()
        nameField.delegate = nil
    }

}
