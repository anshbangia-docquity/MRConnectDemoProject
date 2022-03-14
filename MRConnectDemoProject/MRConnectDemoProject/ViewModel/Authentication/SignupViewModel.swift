//
//  SignupViewModel.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 14/03/22.
//

import Foundation

struct SignupViewModel {
    
    func signupUser(signupRequest: SignupRequest, completion: @escaping (_ result: ValidationResult) -> Void) {
        let validationResult = SignupValidation().validate(signupRequest: signupRequest)
        
        if validationResult.success {
            let authHandler = AuthHandler.shared
            
            authHandler.signupUser(signupRequest: signupRequest) { error in
                completion(ValidationResult(success: error == nil, error: error))
            }
        } else {
            completion(validationResult)
        }
    }
    
}
