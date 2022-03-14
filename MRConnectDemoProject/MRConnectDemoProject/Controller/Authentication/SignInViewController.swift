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
    @IBOutlet weak var specialityButton: UIButton!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    var allUI: [UIControl] = []
        
    let signupViewModel = SignupViewModel()
    var type = UserType.MRUser
    var selectedSpec = -1
    
    lazy var specPicker = BulletinBoard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allUI = [mrButton, doctorButton, nameField, contactField, numberField, specialityButton, emailField, passField, confirmPassField, signupButton]
        
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
    
    @IBAction func signUpTapped(_ sender: Any) {
        ActivityIndicator.shared.start(on: view, label: MyStrings.signingUp)
        
        let request = SignupRequest(name: nameField.text, contact: contactField.text, email: emailField.text, password: passField.text, confirmPassword: confirmPassField.text, type: type.rawValue, license: numberField.text, mrnumber: numberField.text, speciality: selectedSpec)
        
        signupViewModel.signupUser(signupRequest: request) { [weak self] result in
            DispatchQueue.main.async {
                ActivityIndicator.shared.stop()
            }
            
            if !result.success {
                DispatchQueue.main.async {
                    switch result.error {
                    case .emptyNameField:
                        Alert.showAlert(on: self!, emptyField: MyStrings.name)
                    case .emptyContactField:
                        Alert.showAlert(on: self!, emptyField: MyStrings.contact)
                    case .emptyNumberField:
                        Alert.showAlert(on: self!, emptyField: self!.numberField.placeholder!)
                    case .emptySpecialityField:
                        Alert.showAlert(on: self!, emptyField: MyStrings.specialization)
                    case .emptyEmailField:
                        Alert.showAlert(on: self!, emptyField: MyStrings.email)
                    case .emptyPasswordField:
                        Alert.showAlert(on: self!, emptyField: MyStrings.password)
                    case .confirmPasswordNotMatch:
                        Alert.showAlert(on: self!, title: MyStrings.confirmPassNotMatch, subtitle: MyStrings.reenterConfirmPass)
                    case .networkError:
                        Alert.showAlert(on: self!, title: MyStrings.networkError, subtitle: MyStrings.tryAgain)
                    case .invalidEmail:
                        Alert.showAlert(on: self!, title: MyStrings.invalidEmail, subtitle: MyStrings.tryAgain)
                    case .weakPassword:
                        Alert.showAlert(on: self!, title: MyStrings.passNeeds6Char, subtitle: MyStrings.enter6Char)
                    case .emailAlreadyInUse:
                        Alert.showAlert(on: self!, title: MyStrings.signupUnsuccess, subtitle: MyStrings.tryDiffEmail)
                    default:
                        Alert.showAlert(on: self!, title: MyStrings.errorOccured, subtitle: MyStrings.checkCredentials)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        
//        Auth.auth().createUser(withEmail: emailField.text!, password: passField.text!) { result, error in
//            if error != nil {
//                Alert.showAlert(on: self, title: MyStrings.signupUnsuccess, subtitle: MyStrings.tryDiffEmail)
//            }
//
//            guard let result = result else { return }
//            let userDocRef = self.userCollecRef.document(result.user.uid)
//            userDocRef.setData([
//                "name": self.nameField.text!,
//                "contact": self.contactField.text!,
//                "email": self.emailField.text!,
//                "password": self.passField.text!,
//                "type": Int(self.type.rawValue),
//                "profileImageUrl": ""
//            ])
//
//            if self.type == .MRUser {
//                userDocRef.setData([
//                    "license": self.numberField.text!
//                ], merge: true)
//            } else {
//                userDocRef.setData([
//                    "mrnumber": self.numberField.text!,
//                    "speciality": Int(self.selectedSpec),
//                    "office": "",
//                    "quali": "",
//                    "exp": ""
//                ], merge: true)
//            }
            
 //           self.dismiss(animated: true, completion: nil)
 //       }
        
        
    }
    
}

//MARK: - BulletinBoardDelegate
extension SignUpViewController: BulletinBoardDelegate {
    
    func doneTapped(_ bulletinBoard: BulletinBoard, selection: Any, type: BulletinTypes) {
        specPicker.boardManager?.dismissBulletin()
        
        selectedSpec = selection as! Int
        let name = Specialities.specialities[selectedSpec]
        specialityButton.setTitleColor(.black, for: .normal)
        specialityButton.setTitle(name, for: .normal)
        specialityButton.backgroundColor = .white
    }
    
}



