//
//  MedicineForm.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 25/03/22.
//

import Foundation

enum MedicineForm: Int {
    case capsule
    case tablet
    case syrup
    case injection
    
    func getStr() -> String {
        switch self {
        case .capsule:
            return MyStrings.capsule
        case .tablet:
            return MyStrings.tablet
        case .syrup:
            return MyStrings.syrup
        case .injection:
            return MyStrings.injection
        }
    }
}
