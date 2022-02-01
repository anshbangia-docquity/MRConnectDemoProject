//
//  MyStrings.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 31/01/22.
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}

struct MyStrings {
    
    static let email = "email".localize()
    static let password = "password".localize()
    static let mr = "MR"
    static let doctor = "Doctor".localize()
    static let name = "name".localize()
    static let contact = "contact".localize()
    static let licenseNumber = "license number".localize()
    static let mrNumber = "MR number".localize()
    static let specialization = "specialization".localize()
    static let meetings = "Meetings".localize()
    static let doctors = "Doctors".localize()
    static let medicines = "Medicines".localize()
    static let profile = "Profile".localize()
    static let company = "company".localize()
    static let composition = "composition".localize()
    static let price = "price".localize()
    static let form = "form".localize()
    static let capsule = "Capsule".localize()
    static let tablet = "Tablet".localize()
    static let syrup = "Syrup".localize()
    static let injection = "Injection".localize()
    static let loginUpperCase = "LOG IN".localize()
    static let newUserSignUp = "New User? SIGN UP".localize()
    static let invalidEmailOrPass = "Invalid Email or Password.".localize()
    static let checkCredentials = "Please check your credentials.".localize()
    static let emptyFieldAlertTitle = "The |#X#| field cannot be empty.".localize()
    static let emptyFieldAlertSubtitle = "Please fill your |#X#|.".localize()
    static let signup = "Sign Up".localize()
    static let usertype = "User Type".localize()
    static let confirmPass = "confirm password".localize()
    static let invalidEmail = "Invalid Email".localize()
    static let enterValidEmail = "Please enter a valid email address.".localize()
    static let passNeeds6Char = "Password needs to be atleast 6 characters long.".localize()
    static let enter6Char = "Enter atleast 6 characters.".localize()
    static let confirmPassNotMatch = "Confirmed Password does not match.".localize()
    static let reenterConfirmPass = "Re-eneter confirmed password.".localize()
    static let signupUnsuccess = "Sign Up unsuccessful.".localize()
    static let tryDiffEmail = "Try a different email.".localize()
    static let companyName = "Company: |#X#|".localize()
    static let createMed = "Create Medicine".localize()
    static let medName = "medicine name".localize()
    static let create = "Create".localize()
    static let medCreateUnsuccess = "Medicine was not created successfully.".localize()
    static let tryAgain = "Please try again.".localize()
    static let cardiologist = "Cardiologist".localize()
    static let dermatologist = "Dermatologist".localize()
    static let gynecologist = "Gynecologist".localize()
    static let neurologist = "Neurologist".localize()
    static let oncologist = "Oncologist".localize()
    static let pediatrician = "Pediatrician".localize()
    static let physician = "Physician".localize()
    static let psychiatrist = "Psychiatrist".localize()
    static let radiologist = "Radiologist".localize()
    static let surgeon = "Surgeon".localize()
    static let done = "Done".localize()
    static let chooseSpec = "Choose your Specialization".localize()
    
}