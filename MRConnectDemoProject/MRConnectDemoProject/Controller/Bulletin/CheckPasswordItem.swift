//
//  CheckPasswordItem.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 05/02/22.
//

import UIKit
import BLTNBoard
import FirebaseAuth

@objc public class CheckPasswordItem: BLTNPageItem {

    public lazy var passField = UITextField()
    //@objc public var textInputHandler: ((CheckPasswordItem) -> Void)? = nil
    var email: String?
        
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
        //if (textField.text ?? "") != CurrentUser().password {
        
        let credentials = EmailAuthProvider.credential(withEmail: email!, password: passField.text ?? "")
        FirebaseAuth.Auth.auth().currentUser?.reauthenticate(with: credentials, completion: { result, error in
            guard error == nil else {
                self.descriptionLabel!.textColor = .red
                self.descriptionLabel!.text = MyStrings.invalidPassword
                self.passField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
                return
            }
            
            super.actionButtonTapped(sender: sender)
        })
    }
    
    override public func tearDown() {
        super.tearDown()
        passField.delegate = nil
    }

}

extension CheckPasswordItem: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}
