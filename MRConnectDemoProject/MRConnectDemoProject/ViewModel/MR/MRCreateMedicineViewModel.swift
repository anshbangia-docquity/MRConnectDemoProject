//
//  MRCreateMedicineViewModel.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/03/22.
//

import Foundation

struct MRCreateMedicineViewModel {
    
    func createMedicine(createMedRequest: CreateMedicineRequest, completion: @escaping (_ error: ErrorType?) -> Void) {
        let validationResult = CreateMedicineValidation().validate(createMedRequest: createMedRequest)
        
        if validationResult.success {
            let firestore = FirestoreHandler()
            
            firestore.saveMedicine(createMedRequest: createMedRequest)
            completion(nil)
        } else {
            completion(validationResult.error)
        }
    }
    
}
