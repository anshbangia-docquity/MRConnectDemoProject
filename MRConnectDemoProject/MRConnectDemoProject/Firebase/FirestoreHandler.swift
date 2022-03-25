//
//  FirestoreHandler.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 13/03/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct FirestoreHandler {
    
    let firestore = Firestore.firestore()
    var userCollectionRef: CollectionReference {
        firestore.collection("Users")
    }
    var medCollectionRef: CollectionReference {
        firestore.collection("Medicines")
    }
    
    func getUser(userId: String, completion: @escaping (_ userDict: [String: Any]?) -> Void) {
        let userDocumentRef = userCollectionRef.document(userId)
        
        userDocumentRef.getDocument { snapshot, error in
            if error == nil, let snapshot = snapshot {
                completion(snapshot.data())
            }
        }
    }
    
    func saveUser(userId: String, signupRequest: SignupRequest, completion: @escaping (_ error: ErrorType?) -> Void) {
        let userDocumentRef = userCollectionRef.document(userId)
        
        userDocumentRef.setData([
            "userId": userId,
            "userType": signupRequest.type,
            "userImageLink": "",
            "userPassword": signupRequest.password!,
            "userName": signupRequest.name!,
            "userEmail": signupRequest.email!,
            "userContact": signupRequest.contact!
        ]) { error in
            if error == nil {
                if signupRequest.type == UserType.Doctor.rawValue {
                    userDocumentRef.setData([
                        "userSpeciality": signupRequest.speciality,
                        "userQuali": "",
                        "userOffice": "",
                        "userMRNumber": signupRequest.mrnumber!,
                        "userExp": ""
                    ], merge: true) { error2 in
                        if error2 == nil {
                            completion(nil)
                        } else {
                            completion(.defaultError)
                        }
                    }
                } else {
                    userDocumentRef.setData([
                        "userLicenseNumber": signupRequest.license!
                    ], merge: true) { error3 in
                        if error3 == nil {
                            completion(nil)
                        } else {
                            completion(.defaultError)
                        }
                    }
                }
            } else {
                completion(.defaultError)
            }
        }
    }
    
    func updateInfo(userId: String, key: String, newVal: String, completion: @escaping (_ error: ErrorType?) -> Void) {
        let userDocumentRef = userCollectionRef.document(userId)
        userDocumentRef.setData([
            key: newVal
        ], merge: true)
//        { error in
//            if error == nil {
//                completion(nil)
//            } else {
//                completion(.defaultError)
//            }
//        }
        completion(nil)
    }
    
    func getDoctors(completion: @escaping (_ doctorDocuments: [QueryDocumentSnapshot]) -> Void) {
        let userCollecRef = self.userCollectionRef.whereField("userType", isEqualTo: 1).order(by: "userName")
        
        userCollecRef.getDocuments { snapshot, error in
            if error == nil, let snapshot = snapshot {
                completion(snapshot.documents)
            }
        }
    }
    
    func getMedicines(completion: @escaping (_ medDocuments: [QueryDocumentSnapshot]) -> Void) {
        let medCollecRef = self.medCollectionRef.order(by: "company").order(by: "name")
        
        medCollecRef.getDocuments { snapshot, error in
            if error == nil, let snapshot = snapshot {
                completion(snapshot.documents)
            }
        }
    }
    
}
