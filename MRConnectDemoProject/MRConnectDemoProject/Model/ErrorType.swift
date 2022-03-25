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
    case emptyLicenseField
    case emptyMRNumberField
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
        case .emptyNameField:
            return MyStrings.name
        case .emptyContactField:
            return MyStrings.contact
        case .emptyLicenseField:
            return MyStrings.licenseNumber
        case .emptyMRNumberField:
            return MyStrings.mrNumber
        case .emptySpecialityField:
            return MyStrings.specialization
        default:
            return ""
        }
    }
    
    func getAlertMessage() -> (title: String, subTitle: String) {
      switch self {
      case .emptyEmailField, .emptyPasswordField, .emptyNameField, .emptyContactField, .emptyLicenseField, .emptyMRNumberField, .emptySpecialityField:
          return (MyStrings.emptyFieldAlertTitle.replacingOccurrences(of: "|#X#|", with: emptyField()), MyStrings.emptyFieldAlertSubtitle.replacingOccurrences(of: "|#X#|", with: emptyField()))
      case .networkError:
          return (MyStrings.networkError, MyStrings.tryAgain)
      case .userNotFound, .invalidEmail:
          return (MyStrings.invalidEmail, MyStrings.enterValidEmail)
      case .invalidPassword:
          return (MyStrings.invalidPassword, MyStrings.tryAgain)
      case .confirmPasswordNotMatch:
          return (MyStrings.confirmPassNotMatch, MyStrings.reenterConfirmPass)
      case .weakPassword:
          return (MyStrings.passNeeds6Char, MyStrings.enter6Char)
      case .emailAlreadyInUse:
          return (MyStrings.signupUnsuccess, MyStrings.tryDiffEmail)
      default:
          return (MyStrings.errorOccured, MyStrings.tryAgain)
      }
    }

}
