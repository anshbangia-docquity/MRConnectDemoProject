//
//  MRMedicinesViewModel.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 25/03/22.
//

import Foundation

struct MRMedicinesViewModel {
    
    func getMedicines(completion: @escaping (_ medicines: [Medicine]) -> Void) {
        let firestore = FirestoreHandler()
        var medicines: [Medicine] = []
        
        firestore.getMedicines { medDocuments in
            for document in medDocuments {
                let dict = document.data()
                medicines.append(Medicine(dict))
            }
            
            completion(medicines)
        }
    }
        
}
