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
    
    let userDefault = UserDefaultManager.shared.defaults
    var user: CurrentUser? = CurrentUser()
    let imagePicker = UIImagePickerController()
    let bulletinBoard = BulletinBoard()
    let logic = Logic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        
        titleLabel.text = MyStrings.profile
        
        if let img = user?.profileImage {
            profileImageView.image = img
            addImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            addImageButton.setTitle(MyStrings.edit, for: .normal)
        } else {
            addImageButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addImageButton.setTitle(MyStrings.add, for: .normal)
        }
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        nameLabel.text = user?.name
        emailLabel.text = user?.email
        contactLabel.text = MyStrings.dispContact.replacingOccurrences(of: "|#X#|", with: user!.contact)
        
        bulletinBoard.delegate = self
        
        changeNameButton.setTitle(MyStrings.changeName, for: .normal)
        changeNumberButton.setTitle(MyStrings.updateContact, for: .normal)
        changePassButton.setTitle(MyStrings.changePassword, for: .normal)
        logOutButton.setTitle(MyStrings.logOut, for: .normal)
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func changeNameTapped(_ sender: UIButton) {
        bulletinBoard.define(of: .ChangeName)
        bulletinBoard.boardManager?.showBulletin(above: self)
    }
    
    @IBAction func changeNumberTapped(_ sender: UIButton) {
        bulletinBoard.define(of: .ChangeNumber)
        bulletinBoard.boardManager?.showBulletin(above: self)
    }
    
    @IBAction func changePassTapped(_ sender: UIButton) {
        bulletinBoard.define(of: .CheckPassword)
        bulletinBoard.boardManager?.showBulletin(above: self)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        logic.logOut()
        
        user = nil
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let result = logic.saveProfileImage(email: user!.email, img: img)
            if result == false {
                Alert.showAlert(on: self, title: MyStrings.imageNotChosen, subtitle: MyStrings.errorImage)
                return
            }
            profileImageView.image = img
            addImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            addImageButton.setTitle(MyStrings.edit, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - BulletinBoardDelegate
extension ProfileViewController: BulletinBoardDelegate {
    
    func doneTapped(_ bulletinBoard: BulletinBoard, selection: Any, type: BulletinTypes) {
        bulletinBoard.boardManager?.dismissBulletin()
        
        switch type {
        case .ChangeName:
            nameChanged(newName: selection as! String)
        case .ChangePassword:
            passwordChanged(newPass: selection as! String)
        case .ChangeNumber:
            numberChanged(newNum: selection as! String)
        default:
            break
        }
    }
    
    func nameChanged(newName: String) {
        let result = logic.updateName(email: user!.email, newName: newName)
        if result == false {
            Alert.showAlert(on: self, notUpdated: MyStrings.name)
            return
        }
        userDefault.setValue(newName, forKey: "userName")
        nameLabel.text = user?.name
    }
    
    func numberChanged(newNum: String) {
        let result = logic.updateNumber(email: user!.email, newNum: newNum)
        if result == false {
            Alert.showAlert(on: self, notUpdated: MyStrings.contact)
            return
        }
        userDefault.setValue(newNum, forKey: "userContact")
        contactLabel.text = MyStrings.dispContact.replacingOccurrences(of: "|#X#|", with: user!.contact)
    }
    
    func passwordChanged(newPass: String) {
        var result = true
        var pass = user?.password
        
        let confirmAlert = UIAlertController(title: MyStrings.changePassword, message: MyStrings.askChangePass, preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: MyStrings.confirm, style: .default, handler: { (action: UIAlertAction!) in
            result = self.logic.updatePassword(email: self.user!.email, newPass: newPass)
            pass = newPass
        }))

        confirmAlert.addAction(UIAlertAction(title: MyStrings.cancel, style: .cancel, handler: nil))

        present(confirmAlert, animated: true) {
            if result {
                self.userDefault.setValue(pass, forKey: "userPassword")
            } else {
                Alert.showAlert(on: self, notUpdated: MyStrings.password)
            }
        }
    }
    
}

