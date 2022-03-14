//
//  LoginValidation.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 13/03/22.
//

import Foundation

struct LoginValidation {
    
    func validate(loginRequest: LoginRequest) -> ValidationResult {
        if loginRequest.email!.isEmpty {
            return ValidationResult(success: false, error: .emptyEmailField)
        }
        if loginRequest.password!.isEmpty {
            return ValidationResult(success: false, error: .emptyPasswordField)
        }
        
        return ValidationResult(success: true, error: nil)
    }
    
}
