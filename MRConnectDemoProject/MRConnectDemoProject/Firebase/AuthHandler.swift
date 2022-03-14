//
//  AuthHandler.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 13/03/22.
//

import Foundation
import FirebaseAuth

struct AuthHandler {
    static let shared = AuthHandler()
    
    let auth = FirebaseAuth.Auth.auth()
    
    var currentUser: FirebaseAuth.User? {
//        try? auth.signOut()
        return auth.currentUser
    }
    
    func loginUser(loginRequest: LoginRequest, completion: @escaping (_ result: AuthDataResult?, _ error: ErrorType?) -> Void) {
        auth.signIn(withEmail: loginRequest.email!, password: loginRequest.password!) { result, error in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .networkError:
                        completion(result, .networkError)
                    case .userNotFound:
                        completion(result, .userNotFound)
                    case .invalidEmail:
                        completion(result, .invalidEmail)
                    case .wrongPassword:
                        completion(result, .invalidPassword)
                    default:
                        completion(result, .defaultError)
                    }
                }
            } else {
                completion(result, nil)
            }
        }
    }
    
}
