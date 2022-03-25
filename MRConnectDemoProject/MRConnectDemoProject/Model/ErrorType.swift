//
//  ErrorType.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 13/03/22.
//

import Foundation

enum ErrorType: String {
    
    case emptyEmailField
    case emptyPasswordField
    case networkError
    case userNotFound
    case invalidEmail
    case invalidPassword
    case defaultError
    case emptyNameField
    case emptyContactField
    case emptyNumberField
    case emptySpecialityField
    case confirmPasswordNotMatch
    case weakPassword
    case emailAlreadyInUse
    
    private func emptyField() -> String {
        switch self {
        case .emptyEmailField:
            return MyStrings.email
        case .emptyPasswordField:
            return MyStrings.password
        default:
            return ""
        }
    }
    
    func getAlertMessage() -> (title: String, subTitle: String) {
      switch self {
      case .emptyEmailField, .emptyPasswordField:
          return (MyStrings.emptyFieldAlertTitle.replacingOccurrences(of: "|#X#|", with: emptyField()), MyStrings.emptyFieldAlertSubtitle.replacingOccurrences(of: "|#X#|", with: emptyField()))
      case .networkError:
          return (MyStrings.networkError, MyStrings.tryAgain)
      case .userNotFound, .invalidEmail:
          return (MyStrings.invalidEmail, MyStrings.tryAgain)
      case .invalidPassword:
          return (MyStrings.invalidPassword, MyStrings.tryAgain)
      default:
          return (MyStrings.errorOccured, MyStrings.tryAgain)
      }
    }

}
