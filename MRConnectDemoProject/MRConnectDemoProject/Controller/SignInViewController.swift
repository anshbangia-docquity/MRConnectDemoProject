//
//  SignInViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 24/01/22.
//

import UIKit

class SignUpViewController: UIViewController, BulletinBoardDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var contactField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var mrButton: UIButton!
    @IBOutlet weak var doctorButton: UIButton!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var specialityButton: UIButton!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
        
    let userDefault = UserDefaultManager.shared.defaults
    var logic = Logic()
    var type = UserType.MRUser
    var selectedSpec: Int16 = -1
    
    lazy var specPicker = BulletinBoard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        specPicker.delegate = self
        specPicker.define(of: .SpeckPicker)
        
        navItem.title = MyStrings.signup
        userTypeLabel.text = MyStrings.usertype
        mrButton.setTitle(MyStrings.mr, for: .normal)
        doctorButton.setTitle(MyStrings.doctor, for: .normal)
        nameField.placeholder = MyStrings.name
        contactField.placeholder = MyStrings.contact
        specialityButton.setTitle(MyStrings.specialization, for: .normal)
        emailField.placeholder = MyStrings.email
        passField.placeholder = MyStrings.password
        confirmPassField.placeholder = MyStrings.confirmPass
        signupButton.setTitle(MyStrings.signup, for: .normal)
        numberField.placeholder = MyStrings.licenseNumber
    }
    
    @IBAction func userTypePressed(_ sender: UIButton) {
        mrButton.isSelected = false
        doctorButton.isSelected = false
        
        sender.isSelected = true
        switch sender.currentTitle {
        case MyStrings.mr:
            type = .MRUser
            numberField.placeholder = MyStrings.licenseNumber
            specialityButton.isHidden = true
        default:
            type = .Doctor
            numberField.placeholder = MyStrings.mrNumber
            specialityButton.isHidden = false
        }
    }
    
    @IBAction func specButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        specPicker.boardManager?.showBulletin(above: self)
    }
    
    func doneTapped(_ bulletinBoard: BulletinBoard, selection: Any, type: BulletinTypes) {
        specPicker.boardManager?.dismissBulletin()
        
        selectedSpec = selection as! Int16
        let name = Specialities.specialities[selectedSpec]
        specialityButton.setTitleColor(.black, for: .normal)
        specialityButton.setTitle(name, for: .normal)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if nameField.text!.isEmpty {
            showAlert(emptyField: MyStrings.name)
            return
        }
        if contactField.text!.isEmpty {
            showAlert(emptyField: MyStrings.contact)
            return
        }
        if numberField.text!.isEmpty {
            showAlert(emptyField: numberField.placeholder!)
            return
        }
        if type == .Doctor {
            if selectedSpec == -1 {
                showAlert(emptyField: MyStrings.specialization)
                return
            }
        }
        if emailField.text!.isEmpty {
            showAlert(emptyField: MyStrings.email)
            return
        }
                        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailPred.evaluate(with: emailField.text) == false {
            showAlert(title: MyStrings.invalidEmail, subtitle: MyStrings.enterValidEmail)
            return
        }
        
        if passField.text!.count < 6 {
            showAlert(title: MyStrings.passNeeds6Char, subtitle: MyStrings.enter6Char)
            return
        }
        if confirmPassField.text != passField.text {
            showAlert(title: MyStrings.confirmPassNotMatch, subtitle: MyStrings.reenterConfirmPass)
            return
        }
    
        let result: Bool
        if type == .MRUser {
            result = logic.signUp(name: nameField.text!, contact: contactField.text!, email: emailField.text!, password: passField.text!, type: type, license: numberField.text!)
        } else {
            result = logic.signUp(name: nameField.text!, contact: contactField.text!, email: emailField.text!, password: passField.text!, type: type, mrnumber: numberField.text!, speciality: selectedSpec)
        }
        if result == false {
            showAlert(title: MyStrings.signupUnsuccess, subtitle: MyStrings.tryDiffEmail)
            return
        }
        
        userDefault.setValue(emailField.text, forKey: "email")
        userDefault.setValue(passField.text, forKey: "password")
        
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String, subtitle: String) {
        self.present(Alert.showAlert(title: title, subtitle: subtitle), animated: true, completion: nil)
    }
    
    func showAlert(emptyField: String) {
        self.present(Alert.showAlert(title: MyStrings.emptyFieldAlertTitle.replacingOccurrences(of: "|#X#|", with: emptyField), subtitle: MyStrings.emptyFieldAlertSubtitle.replacingOccurrences(of: "|#X#|", with: emptyField)), animated: true, completion: nil)
    }
    
}



