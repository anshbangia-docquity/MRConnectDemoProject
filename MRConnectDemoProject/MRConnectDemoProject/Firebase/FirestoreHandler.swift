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
    
}
