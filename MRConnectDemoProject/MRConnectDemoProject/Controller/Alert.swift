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
    
    static func showAlert(on viewControllwe: UIViewController, noSelection: String) {
        viewControllwe.present(Alert.showAlert(title: MyStrings.noSelectionAlertTitle.replacingOccurrences(of: "|#X#|", with: noSelection), subtitle: MyStrings.noSelectionAlertSubtitle.replacingOccurrences(of: "|#X#|", with: noSelection)), animated: true, completion: nil)
    }
    
    static func showAlert(on viewController: UIViewController, notCreated: String) {
        viewController.present(Alert.showAlert(title: MyStrings.createUnsuccess.replacingOccurrences(of: "|#X#|", with: notCreated), subtitle: MyStrings.tryAgain), animated: true, completion: nil)
    }
    
    static func showAlert(on viewController: UIViewController, notUpdated: String) {
        viewController.present(Alert.showAlert(title: MyStrings.notUpdatedTitle.replacingOccurrences(of: "|#X#|", with: notUpdated), subtitle: MyStrings.notUpdatedSubtitle.replacingOccurrences(of: "|#X#|", with: notUpdated)), animated: true, completion: nil)
    }
    
    static func showAlert(on viewController: UIViewController, notSaved: String) {
        viewController.present(Alert.showAlert(title: MyStrings.notSavedTitle.replacingOccurrences(of: "|#X#|", with: notSaved), subtitle: MyStrings.notSavedSubtitle.replacingOccurrences(of: "|#X#|", with: notSaved)), animated: true, completion: nil)
    }

}
