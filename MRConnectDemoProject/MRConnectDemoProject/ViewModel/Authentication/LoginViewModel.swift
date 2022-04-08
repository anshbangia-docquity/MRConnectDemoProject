//
//  LoginViewModel.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 13/03/22.
//

import Foundation

struct LoginViewModel {
    
    func loginUser(loginRequest: LoginRequest, completion: @escaping (_ result: ValidationResult) -> Void) {
        let validationResult = LoginValidation().validate(loginRequest: loginRequest)
        
        if validationResult.success {
            let authHandler = AuthHandler.shared
            authHandler.loginUser(loginRequest: loginRequest) { error in
                completion(ValidationResult(success: error == nil, error: error))
            }
        } else {
            completion(validationResult)
        }
    }
    
}
