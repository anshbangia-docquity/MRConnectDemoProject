//
//  AppDelegate.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 24/01/22.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let context = PersistentStorage.shared.context
    let userDefault = UserDefaultManager.shared.defaults
    let specialities = ["Cardiologist", "Dermatologist", "Gynecologist", "Neurologist", "Oncologist", "Pediatrician", "Physician", "Psychiatrist", "Radiologist", "Surgeon"]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        if userDefault.value(forKey: "numOfSpec") == nil {
            for i in 0..<(specialities.count) {
                let newSpeciality = Speciality(context: context)
                newSpeciality.id = Int16(i)
                newSpeciality.name = specialities[i]
                do {
                    try context.save()
                } catch {
                }
            }
            userDefault.setValue(specialities.count, forKey: "numOfSpec")
        }
        
        if userDefault.value(forKey: "numOfMed") == nil {
            userDefault.setValue(0, forKey: "numOfMed")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

