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
            
            authHandler.signupUser(signupRequest: signupRequest) { result, error in
                if error == nil {
                    let firestore = FirestoreHandler()
                    firestore.saveUser(userId: result!.user.uid, signupRequest: signupRequest) {
                        completion(ValidationResult(success: true, error: nil))
                    }
                } else {
                    completion(ValidationResult(success: false, error: error))
                }
            }
        } else {
            completion(validationResult)
        }
    }
    
}
