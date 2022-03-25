//
//  Storage Handler.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 16/03/22.
//

import Foundation
import FirebaseStorage

struct StorageHandler {
    
    let storage = Storage.storage()
    
    func uploadImage(userId: String, imgData: Data, completion: @escaping (_ url: URL) -> Void) {
        let ref = storage.reference().child("images/\(userId).png")
        
        ref.putData(imgData, metadata: nil) { _, error in
            guard error == nil else { return }
            ref.downloadURL { url, error in
                guard error == nil, let url = url else { return }
                completion(url)
            }
        }
    }
    
}