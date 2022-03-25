//
//  SignupValidation.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 14/03/22.
//

import Foundation

struct SignupValidation {
    
    func validate(signupRequest: SignupRequest) -> ValidationResult {
        if signupRequest.name!.isEmpty {
            return ValidationResult(success: false, error: .emptyNameField)
        }
        
        if signupRequest.contact!.isEmpty {
            return ValidationResult(success: false, error: .emptyContactField)
        }
        
        if signupRequest.type == UserType.Doctor.rawValue {
            if signupRequest.mrnumber!.isEmpty {
                return ValidationResult(success: false, error: .emptyMRNumberField)
            }
            
            if signupRequest.speciality == -1 {
                return ValidationResult(success: false, error: .emptySpecialityField)
            }
        } else {
            if signupRequest.license!.isEmpty {
                return ValidationResult(success: false, error: .emptyLicenseField)
            }
        }
        
        if signupRequest.email!.isEmpty {
            return ValidationResult(success: false, error: .emptyEmailField)
        }
        
        if signupRequest.password!.isEmpty {
            return ValidationResult(success: false, error: .emptyPasswordField)
        }
        
        if signupRequest.confirmPassword != signupRequest.password {
            return ValidationResult(success: false, error: .confirmPasswordNotMatch)
        }
        
        return ValidationResult(success: true, error: nil)
    }
    
}
