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
    static let license_number = "license number".localize()
    static let mr_number = "MR number".localize()
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
    
}
