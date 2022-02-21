//
//  BulletinItems.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 05/02/22.
//

import UIKit
import BLTNBoard

struct BulletinItems {
    
    func makeSpeckPickerItem(_ delegate: BulletinBoardDelegate?, board: BulletinBoard) -> SpecPickerItem {
        let item = SpecPickerItem(title: MyStrings.specialization)
        item.actionButtonTitle = MyStrings.done
        item.descriptionText = MyStrings.chooseSpec
        item.appearance.actionButtonColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        item.appearance.actionButtonTitleColor = .black
        item.appearance.titleFontSize = 25
        item.requiresCloseButton = false
        item.appearance.actionButtonFontSize = 20

        item.actionHandler = { _ in
            delegate?.doneTapped(board, selection: item.spec, type: .SpeckPicker)
        }
        
        return item
    }
    
    func makeChangeNumber(_ delegate: BulletinBoardDelegate?, board: BulletinBoard) -> ChangeNumberItem {
        let item = ChangeNumberItem(title: MyStrings.updateContact)
        item.actionButtonTitle = MyStrings.done
        item.descriptionText = MyStrings.updateYourContact
        item.appearance.actionButtonColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        item.appearance.actionButtonTitleColor = .black
        item.appearance.titleFontSize = 25
        item.requiresCloseButton = false
        item.appearance.actionButtonFontSize = 20
        
        item.textInputHandler = { newNum in
            delegate?.doneTapped(board, selection: newNum, type: .ChangeNumber)
        }
        
        return item
    }
    
    func makeChangeNameItem(_ delegate: BulletinBoardDelegate?, board: BulletinBoard) -> ChangeNameItem {
        let item = ChangeNameItem(title: MyStrings.changeName)
        item.actionButtonTitle = MyStrings.done
        item.descriptionText = MyStrings.editName
        item.appearance.actionButtonColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        item.appearance.actionButtonTitleColor = .black
        item.appearance.titleFontSize = 25
        item.requiresCloseButton = false
        item.appearance.actionButtonFontSize = 20
        
        item.textInputHandler = { newName in
            delegate?.doneTapped(board, selection: newName, type: .ChangeName)
        }
        
        return item
    }
    
    func makeCheckPasswordItem(_ delegate: BulletinBoardDelegate?, board: BulletinBoard) -> CheckPasswordItem {
        let item = CheckPasswordItem(title: MyStrings.changePassword)
        item.actionButtonTitle = MyStrings.proceed
        item.descriptionText = MyStrings.enterOldPass
        item.appearance.actionButtonColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        item.appearance.actionButtonTitleColor = .black
        item.appearance.titleFontSize = 25
        item.requiresCloseButton = false
        item.appearance.actionButtonFontSize = 20

        item.textInputHandler = { item in
            let changePasswordItem = self.makeChangePasswordItem(delegate, board: board)
            item.manager?.push(item: changePasswordItem)
        }
        
        return item
    }
    
    func makeChangePasswordItem(_ delegate: BulletinBoardDelegate?, board: BulletinBoard) -> ChangePasswordItem {
        let item = ChangePasswordItem(title: MyStrings.changePassword)
        item.actionButtonTitle = MyStrings.done
        item.descriptionText = MyStrings.enterNewPass
        item.appearance.actionButtonColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        item.appearance.actionButtonTitleColor = .black
        item.appearance.titleFontSize = 25
        item.requiresCloseButton = false
        item.appearance.actionButtonFontSize = 20

        item.actionHandler = { _ in
            delegate?.doneTapped(board, selection: item.passField.text!, type: .ChangePassword)
        }
        
        return item
    }
    
    func makeRecordItem(_ delegate: BulletinBoardDelegate?, board: BulletinBoard, meeting: Int16) -> RecordItem {
        let item = RecordItem(title: MyStrings.recordMeeting)
        item.meeting = meeting
        item.isDismissable = false
        item.requiresCloseButton = false
        item.saveRecording = { result, fileName, audioRecorder in
            delegate?.doneTapped(board, selection: (result, fileName, audioRecorder), type: .RecordItem)
        }
        
        return item
    }
    
}


