//
//  MRDoctorsViewModel.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 25/03/22.
//

import Foundation

struct MRDoctorsViewModel {
    
    func getDoctors(completion: @escaping (_ doctors: [Doctor]) -> Void) {
        let firestore = FirestoreHandler()
        var doctors: [Doctor] = []
        
        firestore.getDoctors { doctorDocuments in
            for document in doctorDocuments {
                let dict = document.data()
                doctors.append(Doctor(dict))
            }
            
            completion(doctors)
        }
    }
    
    func getProfileImage(urlStr: String, completion: @escaping (_ imgData: Data?) -> Void) {
        let url = URL(string: urlStr)
        guard let url = url else {
            completion(nil)
            return
        }
        
        let data = try? Data(contentsOf: url)
        guard let data = data else {
            completion(nil)
            return
        }
        
        completion(data)
    }
    
}
