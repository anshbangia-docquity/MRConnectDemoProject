//
//  SignInViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 24/01/22.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var contactField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var mrButton: UIButton!
    @IBOutlet weak var doctorButton: UIButton!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var specialityField: UITextField!
    
    var specialityPicker = UIPickerView()
    var specialities: [String] = []
    
    let userDefault = UserDefaultManager.shared.defaults
    var type = UserType.MRUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        specialityPicker.dataSource = self
        specialityPicker.delegate = self
        specialityPicker.backgroundColor = .white
        
        specialityField.inputView = specialityPicker
        
        specialities = Logic.fillSecialities()
        specialities.append("Other...")
    }
    
    @IBAction func userTypePressed(_ sender: UIButton) {
        mrButton.isSelected = false
        doctorButton.isSelected = false
        
        sender.isSelected = true
        switch sender.currentTitle {
        case "MR":
            type = .MRUser
            numberField.placeholder = "license number"
            specialityField.isHidden = true
        default:
            type = .Doctor
            numberField.placeholder = "MR number"
            specialityField.isHidden = false
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if nameField.text == "" {
            showAlert(emptyField: "Name")
            return
        }
        
        if contactField.text == "" {
            showAlert(emptyField: "Contact")
            return
        }
        
        if numberField.text == "" {
            showAlert(emptyField: numberField.placeholder!)
            return
        }
        
        if type == .Doctor {
            if specialityField.text == "" {
                showAlert(emptyField: "Specialization")
                return
            }
            
            if specialityField.text == "Other..." {
                showAlert(title: "Specialization missing.", subtitle: "Please enter your specialization.")
                return
            }
        }

        if emailField.text == "" {
            showAlert(emptyField: "Email")
            return
        }
                        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailPred.evaluate(with: emailField.text) == false {
            showAlert(title: "Invalid Email.", subtitle: "Please enter a valid email address.")
            return
        }
        
        if passField.text!.count < 6 {
            showAlert(title: "Password needs to be atleast 6 characters long.", subtitle: "Enter atleast 6 characters.")
            return
        }
        if confirmPassField.text != passField.text {
            showAlert(title: "Confirmed Password does not match.", subtitle: "Re-eneter confirmed password.")
            return
        }
    
        let result: Bool
        if type == .MRUser {
            result = Logic.signUp(name: nameField.text!, contact: contactField.text!, email: emailField.text!, password: passField.text!, type: type, license: numberField.text!)
        } else {
            let specId = Logic.fetchSpecId(of: specialityField.text!)
            result = Logic.signUp(name: nameField.text!, contact: contactField.text!, email: emailField.text!, password: passField.text!, type: type, mrnumber: numberField.text!, speciality: specId)
        }
        if result == false {
            showAlert(title: "Sign Up unsuccessful.", subtitle: "Try a different email.")
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
        self.present(Alert.showAlert(title: "The \(emptyField) field cannot be empty.", subtitle: "Please fill your \(emptyField)."), animated: true, completion: nil)
    }
    
}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return specialities.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return specialities[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        specialityField.text = specialities[row]
        specialityField.resignFirstResponder()
    }

}
//comment


