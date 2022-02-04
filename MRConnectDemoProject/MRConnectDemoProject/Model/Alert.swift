//
//  Alert.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 24/01/22.
//

import Foundation
import UIKit
import BLTNBoard

struct Alert {
    
    static func showAlert(title: String, subtitle: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        let submitButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(submitButton)
        return alert
    }
    
//    static func showAlert(title: String, subtitle: String, boardManager: BLTNItemManager, viewController: UIViewController) -> UIAlertController {
//        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
//        let submitButton = UIAlertAction(title: "Okay", style: .default) { _ in
//            boardManager.showBulletin(above: viewController)
//        }
//        alert.addAction(submitButton)
//        return alert
//    }

}
