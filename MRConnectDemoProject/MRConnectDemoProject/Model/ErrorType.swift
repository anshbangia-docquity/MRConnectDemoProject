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
    case emptyCompanyField
    case emptyCompositionField
    case emptyPriceField
    case invalidPrice
    case emptyTitleField
    case invalidTime
    case noDoctorsSelected
    case noMedicinesSelected
    
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
        case .emptyCompanyField:
            return MyStrings.company
        case .emptyCompositionField:
            return MyStrings.composition
        case .emptyPriceField:
            return MyStrings.price
        case .emptyTitleField:
            return MyStrings.meetingTitle
        default:
            return ""
        }
    }
    
    private func noSelection() -> String {
        switch self {
        case .noDoctorsSelected:
            return MyStrings.doctor
        case .noMedicinesSelected:
            return MyStrings.medicine
        default: return ""
        }
    }
    
    func getAlertMessage() -> (title: String, subTitle: String) {
      switch self {
      case .emptyEmailField, .emptyPasswordField, .emptyNameField, .emptyContactField, .emptyLicenseField, .emptyMRNumberField, .emptySpecialityField, .emptyCompanyField, .emptyCompositionField, .emptyPriceField, .emptyTitleField:
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
      case .invalidPrice:
          return (MyStrings.invalidPrice, MyStrings.tryAgain)
      case .invalidTime:
          return (MyStrings.invalidTime, MyStrings.againApptTime)
      case .noDoctorsSelected, .noMedicinesSelected:
          return (MyStrings.noSelectionAlertTitle.replacingOccurrences(of: "|#X#|", with: noSelection()), MyStrings.noSelectionAlertSubtitle.replacingOccurrences(of: "|#X#|", with: noSelection()))
      default:
          return (MyStrings.errorOccured, MyStrings.tryAgain)
      }
    }

}
