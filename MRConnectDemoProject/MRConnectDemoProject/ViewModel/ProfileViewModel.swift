//
//  ProfileViewModel.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 15/03/22.
//

import Foundation

struct ProfileViewModel {
    
    func getProfileImage(urlStr: String, completion: @escaping (_ imgData: Data) -> Void) {
        let url = URL(string: urlStr)
        guard let url = url else { return }
        
        let data = try? Data(contentsOf: url)
        guard let data = data else { return }
        
        completion(data)
    }
    
    func logOut() -> Bool {
        let authHandler = AuthHandler.shared
        
        if authHandler.logOut() {
            UserDefaultManager().reset()
            
            return true
        }
        
        return false
    }
    
}
