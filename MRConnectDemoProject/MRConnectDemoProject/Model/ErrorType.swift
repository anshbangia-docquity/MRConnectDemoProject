//
//  ErrorType.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 13/03/22.
//

import Foundation

enum ErrorType {
    
    case emptyEmailField
    case emptyPasswordField
    case networkError
    case userNotFound
    case invalidEmail
    case invalidPassword
    case defaultError
    
    func getErrorMessage() {
        switch self {
        case .userNotFound:
            <#code#>
        default:
            <#code#>
        }
    }
    
}
