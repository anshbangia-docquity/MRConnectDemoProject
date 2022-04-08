//
//  CreateMedicineValidation.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/03/22.
//

import Foundation

struct CreateMedicineValidation {
 
    func validate(createMedRequest: CreateMedicineRequest) -> ValidationResult {
        if createMedRequest.name!.isEmpty {
            return ValidationResult(success: false, error: .emptyNameField)
        }
        
        if createMedRequest.company!.isEmpty {
            return ValidationResult(success: false, error: .emptyCompanyField)
        }
        
        if createMedRequest.composition!.isEmpty {
            return ValidationResult(success: false, error: .emptyCompositionField)
        }
        
        if createMedRequest.price!.isEmpty {
            return ValidationResult(success: false, error: .emptyPriceField)
        }
        
        let price = Float(createMedRequest.price!)
        if let price = price {
            if price < 0 {
                return ValidationResult(success: false, error: .invalidPrice)
            }
        } else {
            return ValidationResult(success: false, error: .invalidPrice)
        }
        
        return ValidationResult(success: true, error: nil)
    }
    
}
