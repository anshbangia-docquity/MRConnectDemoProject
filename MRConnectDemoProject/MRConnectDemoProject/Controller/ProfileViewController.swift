//
//  ProfileViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 10/02/22.
//

import UIKit
import BLTNBoard

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var changeNameButton: UIButton!
    @IBOutlet weak var changeNumberButton: UIButton!
    @IBOutlet weak var changePassButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var officeView: UIView!
    @IBOutlet weak var qualiView: UIView!
    @IBOutlet weak var expView: UIView!
    @IBOutlet weak var officeLabel: UILabel!
    @IBOutlet weak var qualiLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var officeTextView: UITextView!
    @IBOutlet weak var qualiTextView: UITextView!
    @IBOutlet weak var expTextView: UITextView!
    
    let user = CurrentUser()
    let imagePicker = UIImagePickerController()
    let bulletinBoard = BulletinBoard()
    let profileViewModel = ProfileViewModel()
    
    //let storage = FirebaseStorage.Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        bulletinBoard.delegate = self
        
        titleLabel.text = MyStrings.profile
        
        if !user.imageLink.isEmpty {
            ActivityIndicator.shared.start(on: view, label: MyStrings.loading)
            
            profileViewModel.getProfileImage(urlStr: user.imageLink) { [weak self] imgData in
                self?.profileImageView.image = UIImage(data: imgData)
                
                ActivityIndicator.shared.stop()
            }
            
            addImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            addImageButton.setTitle(MyStrings.edit, for: .normal)
        } else {
            addImageButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addImageButton.setTitle(MyStrings.add, for: .normal)
        }
        
        nameLabel.text = user.name
        emailLabel.text = user.email
        contactLabel.text = MyStrings.dispContact.replacingOccurrences(of: "|#X#|", with: user.contact)
        
        if user.type == .MRUser {
            officeView.isHidden = true
            qualiView.isHidden = true
            expView.isHidden = true
        } else {
            officeView.isHidden = false
            officeLabel.text = MyStrings.office
            if user.office.isEmpty {
                officeTextView.text = MyStrings.addOffice
                officeTextView.textColor = .systemGray3
            } else {
                officeTextView.text = user.office
                officeTextView.textColor = .black
            }
            
            qualiView.isHidden = false
            qualiLabel.text = MyStrings.quali
            if user.quali.isEmpty {
                qualiTextView.text = MyStrings.addQuali
                qualiTextView.textColor = .systemGray3
            } else {
                qualiTextView.text = user.quali
                qualiTextView.textColor = .black
            }
            
            expView.isHidden = false
            expLabel.text = MyStrings.exp
            if user.exp.isEmpty {
                expTextView.text = MyStrings.addExp
                expTextView.textColor = .systemGray3
            } else {
                expTextView.text = user.exp
                expTextView.textColor = .black
            }
        }
        
        changeNameButton.setTitle(MyStrings.changeName, for: .normal)
        changeNumberButton.setTitle(MyStrings.updateContact, for: .normal)
        changePassButton.setTitle(MyStrings.changePassword, for: .normal)
        logOutButton.setTitle(MyStrings.logOut, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
        //
        //        imagePicker.delegate = self
        //        imagePicker.allowsEditing = false
        //        imagePicker.sourceType = .photoLibrary
        //
        //
        //
        //        //
        //
        //
        //
        //
        //
        //        officeTextView.delegate = self
        //        qualiTextView.delegate = self
        //        expTextView.delegate = self
    }
    
//    @IBAction func changeNameTapped(_ sender: UIButton) {
//        bulletinBoard.define(of: .ChangeName)
//        bulletinBoard.boardManager?.showBulletin(above: self)
//    }
    
    @IBAction func changeNumberTapped(_ sender: UIButton) {
        bulletinBoard.define(of: .ChangeNumber)
        bulletinBoard.boardManager?.showBulletin(above: self)
    }
    
    @IBAction func changePassTapped(_ sender: UIButton) {
        bulletinBoard.define(of: .CheckPassword, additional: user.password)
        bulletinBoard.boardManager?.showBulletin(above: self)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        if profileViewModel.logOut() {
            presentingViewController?.dismiss(animated: true, completion:nil)
        } else {
            Alert.showAlert(on: self, title: MyStrings.errorOccured, subtitle: MyStrings.tryAgain)
        }
    }
    
    
    
    
    
    
    
    @IBAction func addImagePressed(_ sender: Any) {
        //present(imagePicker, animated: true)
    }
    
    
    

    
    
    
    
    
}

//MARK: - BulletinBoardDelegate
extension ProfileViewController: BulletinBoardDelegate {
    
    func doneTapped(_ bulletinBoard: BulletinBoard, selection: Any, type: BulletinTypes) {
        bulletinBoard.boardManager?.dismissBulletin()
        
        //            switch type {
        //            case .ChangeName:
        //                nameChanged(newName: selection as! String)
        //            }
        
        switch type {
        case .ChangePassword:
            passwordChanged(newPass: selection as! String)
        case .ChangeNumber:
            numberChanged(newNum: selection as! String)
        default:
            break
        }
    }
    
    func passwordChanged(newPass: String) {
        let confirmAlert = UIAlertController(title: MyStrings.changePassword, message: MyStrings.askChangePass, preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: MyStrings.confirm, style: .default, handler: {[weak self] _ in
            ActivityIndicator.shared.start(on: self!.view, label: MyStrings.processing)
            
            self?.profileViewModel.changePassword(to: newPass) { error in
                DispatchQueue.main.async {
                    ActivityIndicator.shared.stop()
                }
                
                if error != nil {
                    switch error {
                    case .networkError:
                        DispatchQueue.main.async {
                            Alert.showAlert(on: self!, title: MyStrings.networkError, subtitle: MyStrings.tryAgain)
                        }
                    default:
                        DispatchQueue.main.async {
                            Alert.showAlert(on: self!, title: MyStrings.errorOccured, subtitle: MyStrings.checkCredentials)
                        }
                    }
                }
            }
        }))
        
        confirmAlert.addAction(UIAlertAction(title: MyStrings.cancel, style: .cancel, handler: nil))
        
        present(confirmAlert, animated: true)
    }
    
    func numberChanged(newNum: String) {
        ActivityIndicator.shared.start(on: view, label: MyStrings.processing)
        
        profileViewModel.changeNumber(to: newNum) { [weak self] error in
            DispatchQueue.main.async {
                ActivityIndicator.shared.stop()
            }
            
            if error != nil {
                switch error {
                case .networkError:
                    DispatchQueue.main.async {
                        Alert.showAlert(on: self!, title: MyStrings.networkError, subtitle: MyStrings.tryAgain)
                    }
                default:
                    DispatchQueue.main.async {
                        Alert.showAlert(on: self!, title: MyStrings.errorOccured, subtitle: MyStrings.checkCredentials)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.contactLabel.text = MyStrings.dispContact.replacingOccurrences(of: "|#X#|", with: self!.user.contact)
                }
            }
        }
        
    }
    
}


////MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
//extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        dismiss(animated: true, completion: nil)
//        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            profileImageView.image = img
//            addImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
//            addImageButton.setTitle(MyStrings.edit, for: .normal)
//            if let imgData = img.pngData() {
//                let ref = storage.reference().child("images/\(auth.currentUser!.uid).png")
//                ref.putData(imgData, metadata: nil) { _, error in
//                    guard error == nil else { return }
//                    ref.downloadURL { url, error in
//                        guard error == nil, let url = url else { return }
//                        self.userDocRef.setData([
//                            "profileImageUrl": url.absoluteString
//                        ], merge: true)
//                    }
//                }
//            }
//        }
//
//    }
//
//}

////MARK: - UITextViewDelegate
//extension ProfileViewController: UITextViewDelegate {
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == .systemGray3 {
//            textView.text = ""
//            textView.textColor = .black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        let entry = textView.text ?? ""
//        if entry.isEmpty {
//            textView.textColor = .systemGray3
//            switch textView {
//            case officeTextView:
//                textView.text = MyStrings.addOffice
//            case qualiTextView:
//                textView.text = MyStrings.addQuali
//            default:
//                textView.text = MyStrings.addExp
//            }
//        }
//
//        switch textView {
//        case officeTextView:
//            //let _ = logic.updateOffice(email: user!.email, office: entry)
//            //userDefault.setValue(entry, forKey: "userOffice")
//            userDocRef.setData([
//                "office": entry
//            ], merge: true)
//        case qualiTextView:
//            //let _ = logic.updateQuali(email: user!.email, quali: entry)
//            //userDefault.setValue(entry, forKey: "userQuali")
//            userDocRef.setData([
//                "quali": entry
//            ], merge: true)
//        default:
//            //let _ = logic.updateExp(email: user!.email, exp: entry)
//            //userDefault.setValue(entry, forKey: "userExp")
//            userDocRef.setData([
//                "exp": entry
//            ], merge: true)
//        }
//    }
//
//}

////MARK: - BulletinBoardDelegate
//extension ProfileViewController: BulletinBoardDelegate {
//
//
//    func nameChanged(newName: String) {
//        //let result = logic.updateName(email: user!.email, newName: newName)
//        userDocRef.setData([
//            "name": newName
//        ], merge: true)
////        if result == false {
////            Alert.showAlert(on: self, notUpdated: MyStrings.name)
////            return
////        }
//        //userDefault.setValue(newName, forKey: "userName")
//        nameLabel.text = newName
//    }
//

//

//
//}

