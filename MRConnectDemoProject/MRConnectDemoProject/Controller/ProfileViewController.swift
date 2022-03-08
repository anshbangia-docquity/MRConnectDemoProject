//
//  ProfileViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 10/02/22.
//

import UIKit
import BLTNBoard
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

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
    
    //let userDefault = UserDefaultManager.shared.defaults
    //var user: CurrentUser? = CurrentUser()
    let imagePicker = UIImagePickerController()
    let bulletinBoard = BulletinBoard()
    //let logic = Logic()
    
    let database = Firestore.firestore()
    var userCollecRef: CollectionReference!
    var userDocRef: DocumentReference!
    let auth = FirebaseAuth.Auth.auth()
    let storage = FirebaseStorage.Storage.storage()
    
    //var userDict: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCollecRef = database.collection("Users")
        userDocRef = userCollecRef.document(auth.currentUser!.uid)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userDocRef.getDocument {[weak self] snapshot, error in
            guard error == nil, let data = snapshot?.data() else { return }
            let userDict = data
            
            
            //nameLabel.text = user?.name
            self?.nameLabel.text = userDict["name"] as? String
            //emailLabel.text = user?.email
            self?.emailLabel.text = userDict["email"] as? String
            //contactLabel.text = MyStrings.dispContact.replacingOccurrences(of: "|#X#|", with: user!.contact)
            self?.contactLabel.text = MyStrings.dispContact.replacingOccurrences(of: "|#X#|", with: userDict["contact"] as! String)
            
            //if user?.type == .Doctor {
            if userDict["type"] as! Int == Int(UserType.Doctor.rawValue) {
                self?.officeView.isHidden = false
                self?.qualiView.isHidden = false
                self?.expView.isHidden = false
    
                self?.officeLabel.text = MyStrings.office
                self?.qualiLabel.text = MyStrings.quali
                self?.expLabel.text = MyStrings.exp
                
                let office = userDict["office"] as? String
                //if user!.office.isEmpty {
                if office == nil || (office != nil && office!.isEmpty) {
                    self?.officeTextView.text = MyStrings.addOffice
                    self?.officeTextView.textColor = .systemGray3
                } else {
                    //officeTextView.text = user?.office
                    self?.officeTextView.text = userDict["office"] as? String
                    self?.officeTextView.textColor = .black
                }
    
                let quali = userDict["quali"] as? String
                //if user!.quali.isEmpty {
                if quali == nil || (quali != nil && quali!.isEmpty) {
                    self?.qualiTextView.text = MyStrings.addQuali
                    self?.qualiTextView.textColor = .systemGray3
                } else {
                    //qualiTextView.text = user?.quali
                    self?.qualiTextView.text = userDict["quali"] as? String
                    self?.qualiTextView.textColor = .black
                }
    
                let exp = userDict["exp"] as? String
                //if user!.exp.isEmpty {
                if exp == nil || (exp != nil && exp!.isEmpty) {
                    self?.expTextView.text = MyStrings.addExp
                    self?.expTextView.textColor = .systemGray3
                } else {
                    //expTextView.text = user?.exp
                    self?.expTextView.text = userDict["exp"] as? String
                    self?.expTextView.textColor = .black
                }
            } else {
                self?.officeView.isHidden = true
                self?.qualiView.isHidden = true
                self?.expView.isHidden = true
            }
            
            if userDict["profileImageUrl"] as! String == "" {
                print("add")
                self?.addImageButton.setImage(UIImage(systemName: "plus"), for: .normal)
                self?.addImageButton.setTitle(MyStrings.add, for: .normal)
            } else {
                print("edit")
                self?.addImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
                self?.addImageButton.setTitle(MyStrings.edit, for: .normal)
                let imgUrlStr = userDict["profileImageUrl"] as! String
//                let storageRef = self?.storage.reference(forURL: imgUrlStr)
//                storageRef?.getData(maxSize: 50 * 1024 * 1024, completion: { data, error in
//                    guard error == nil, let data = data else {
//                        print(error)
//                        return }
//                    self?.profileImageView.image = UIImage(data: data)
//                })
                guard let url = URL(string: imgUrlStr) else { return }
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        if let img = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.profileImageView.image = img
                            }
                        }
                    }
                }

            }
        }
        
        //addImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        
        titleLabel.text = MyStrings.profile
        

        
//        if let img = user?.profileImage {
//            profileImageView.image = img
//            addImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
//            addImageButton.setTitle(MyStrings.edit, for: .normal)
//        } else {
//            addImageButton.setImage(UIImage(systemName: "plus"), for: .normal)
//            addImageButton.setTitle(MyStrings.add, for: .normal)
//        }
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        
        
        bulletinBoard.delegate = self
        
        changeNameButton.setTitle(MyStrings.changeName, for: .normal)
        changeNumberButton.setTitle(MyStrings.updateContact, for: .normal)
        changePassButton.setTitle(MyStrings.changePassword, for: .normal)
        logOutButton.setTitle(MyStrings.logOut, for: .normal)
        
        officeTextView.delegate = self
        qualiTextView.delegate = self
        expTextView.delegate = self

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
        bulletinBoard.define(of: .CheckPassword, additional: emailLabel.text!)
        bulletinBoard.boardManager?.showBulletin(above: self)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        //logic.logOut()
        try? auth.signOut()
        
        //user = nil
        //userDict = [:]
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = img
            addImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            addImageButton.setTitle(MyStrings.edit, for: .normal)
            if let imgData = img.pngData() {
                let ref = storage.reference().child("images/\(auth.currentUser!.uid).png")
                ref.putData(imgData, metadata: nil) { _, error in
                    guard error == nil else { return }
                    ref.downloadURL { url, error in
                        guard error == nil, let url = url else { return }
                        self.userDocRef.setData([
                            "profileImageUrl": url.absoluteString
                        ], merge: true)
                    }

                }
            }
        }
        
    }
    
}

//MARK: - UITextViewDelegate
extension ProfileViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray3 {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let entry = textView.text ?? ""
        if entry.isEmpty {
            textView.textColor = .systemGray3
            switch textView {
            case officeTextView:
                textView.text = MyStrings.addOffice
            case qualiTextView:
                textView.text = MyStrings.addQuali
            default:
                textView.text = MyStrings.addExp
            }
        }
        
        switch textView {
        case officeTextView:
            //let _ = logic.updateOffice(email: user!.email, office: entry)
            //userDefault.setValue(entry, forKey: "userOffice")
            userDocRef.setData([
                "office": entry
            ], merge: true)
        case qualiTextView:
            //let _ = logic.updateQuali(email: user!.email, quali: entry)
            //userDefault.setValue(entry, forKey: "userQuali")
            userDocRef.setData([
                "quali": entry
            ], merge: true)
        default:
            //let _ = logic.updateExp(email: user!.email, exp: entry)
            //userDefault.setValue(entry, forKey: "userExp")
            userDocRef.setData([
                "exp": entry
            ], merge: true)
        }
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
        //let result = logic.updateName(email: user!.email, newName: newName)
        userDocRef.setData([
            "name": newName
        ], merge: true)
//        if result == false {
//            Alert.showAlert(on: self, notUpdated: MyStrings.name)
//            return
//        }
        //userDefault.setValue(newName, forKey: "userName")
        nameLabel.text = newName
    }
    
    func numberChanged(newNum: String) {
        //let result = logic.updateNumber(email: user!.email, newNum: newNum)
        userDocRef.setData([
            "contact": newNum
        ], merge: true)
//        if result == false {
//            Alert.showAlert(on: self, notUpdated: MyStrings.contact)
//            return
//        }
        //userDefault.setValue(newNum, forKey: "userContact")
        contactLabel.text = MyStrings.dispContact.replacingOccurrences(of: "|#X#|", with: newNum)
    }
    
    func passwordChanged(newPass: String) {
        let result = true
        //var pass = user?.password
        
        let confirmAlert = UIAlertController(title: MyStrings.changePassword, message: MyStrings.askChangePass, preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: MyStrings.confirm, style: .default, handler: { (action: UIAlertAction!) in
            //result = self.logic.updatePassword(email: self.user!.email, newPass: newPass)
            self.userDocRef.setData([
                "password": newPass
            ], merge: true)
            self.auth.currentUser?.updatePassword(to: newPass, completion: nil)
            //pass = newPass
        }))

        confirmAlert.addAction(UIAlertAction(title: MyStrings.cancel, style: .cancel, handler: nil))

        present(confirmAlert, animated: true) {
            if result {
                //self.userDefault.setValue(pass, forKey: "userPassword")
            } else {
                Alert.showAlert(on: self, notUpdated: MyStrings.password)
            }
        }
    }
    
}

