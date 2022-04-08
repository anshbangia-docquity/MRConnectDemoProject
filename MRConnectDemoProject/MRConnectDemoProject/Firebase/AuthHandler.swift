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

    let auth = Auth.auth()
    
    var currentUser: FirebaseAuth.User? {
        return auth.currentUser
    }
    
    func loginUser(loginRequest: LoginRequest, completion: @escaping (_ error: ErrorType?) -> Void) {
        auth.signIn(withEmail: loginRequest.email!, password: loginRequest.password!) { _, error in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .networkError:
                        completion(.networkError)
                    case .userNotFound:
                        completion(.userNotFound)
                    case .invalidEmail:
                        completion(.invalidEmail)
                    case .wrongPassword:
                        completion(.invalidPassword)
                    default:
                        completion(.defaultError)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func signupUser(signupRequest: SignupRequest, completion: @escaping (_ result: AuthDataResult?, _ error: ErrorType?) -> Void) {
        auth.createUser(withEmail: signupRequest.email!, password: signupRequest.password!) { result, error in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .networkError:
                        completion(nil, .networkError)
                    case .invalidEmail:
                        completion(nil, .invalidEmail)
                    case .weakPassword:
                        completion(nil, .weakPassword)
                    case .emailAlreadyInUse:
                        completion(nil, .emailAlreadyInUse)
                    default:
                        completion(nil, .defaultError)
                    }
                }
            } else {
                completion(result, nil)
            }
        }
    }
    
    func changePassword(to newPass: String, completion: @escaping (_ error: ErrorType?) -> Void) {
        currentUser?.updatePassword(to: newPass, completion: { error in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .networkError:
                        completion(.networkError)
                    case .requiresRecentLogin:
                        let user = CurrentUser()
                        let credential = EmailAuthProvider.credential(withEmail: user.email, password: user.password)
                        currentUser?.reauthenticate(with: credential, completion: { _, error in
                            if error != nil {
                                completion(.defaultError)
                            } else {
                                completion(nil)
                            }
                        })
                    default:
                        completion(.defaultError)
                    }
                }
            } else {
                completion(nil)
            }
        })
    }
    
    func logOut() -> Bool {
        do {
            try auth.signOut()
            return true
        } catch {
            return false
        }
    }
    
}
