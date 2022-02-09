//
//  Alert.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 09/02/22.
//

import UIKit
import BLTNBoard

struct Alert {
    
    static func showAlert(title: String, subtitle: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        let submitButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(submitButton)
        return alert
    }
    
    static func showAlert(on viewController: UIViewController, title: String, subtitle: String) {
        viewController.present(Alert.showAlert(title: title, subtitle: subtitle), animated: true, completion: nil)
    }
    
    static func showAlert(on viewController: UIViewController, emptyField: String) {
        viewController.present(Alert.showAlert(title: MyStrings.emptyFieldAlertTitle.replacingOccurrences(of: "|#X#|", with: emptyField), subtitle: MyStrings.emptyFieldAlertSubtitle.replacingOccurrences(of: "|#X#|", with: emptyField)), animated: true, completion: nil)
    }

}
