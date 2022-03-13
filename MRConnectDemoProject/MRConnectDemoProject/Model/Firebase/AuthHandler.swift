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
}
