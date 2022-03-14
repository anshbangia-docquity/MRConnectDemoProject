//
//  FirestoreHandler.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 13/03/22.
//

import Foundation
import FirebaseFirestore

struct FirestoreHandler {
    
    let database = Firestore.firestore()
    var userCollectionRef: CollectionReference {
        database.collection("Users")
    }
    
    func getUser(userId: String, completion: @escaping (_ userDict: [String: Any]) -> Void) {
        let userDocumentRef = userCollectionRef.document(userId)
        
        userDocumentRef.getDocument { snapshot, error in
            if error == nil {
                if let dict = snapshot?.data() {
                    completion(dict)
                }
            }
        }
    }
    
    func saveUser(userId: String, signupRequest: SignupRequest, completion: @escaping () -> Void) {
        let userDocumentRef = userCollectionRef.document(userId)
        
        userDocumentRef.setData([
            "userId": userId,
            "userType": signupRequest.type,
            "userImageLink": "",
            "userPassword": signupRequest.password!,
            "userName": signupRequest.name!,
            "userEmail": signupRequest.email!,
            "userContact": signupRequest.contact!
        ])
        
        if signupRequest.type == UserType.Doctor.rawValue {
            userDocumentRef.setData([
                "userSpeciality": signupRequest.speciality,
                "userQuali": "",
                "userOffice": "",
                "userMRNumber": signupRequest.mrnumber!,
                "userExp": ""
            ], merge: true)
        } else {
            userDocumentRef.setData([
                "userLicenseNumber": signupRequest.license!
            ], merge: true)
        }
        
        completion()
    }
    
}
