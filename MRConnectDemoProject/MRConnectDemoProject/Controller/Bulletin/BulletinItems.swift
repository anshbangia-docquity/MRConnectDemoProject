//
//  BulletinItems.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 05/02/22.
//

import UIKit
import BLTNBoard

struct BulletinItems {
    
    func makeSpeckPickerItem(_ delegate: BulletinBoardDelegate, board: BulletinBoard) -> SpecPickerItem {
        let item = SpecPickerItem(title: MyStrings.specialization)
        item.actionButtonTitle = MyStrings.done
        item.descriptionText = MyStrings.chooseSpec
        item.appearance.actionButtonColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        item.appearance.actionButtonTitleColor = .black
        item.appearance.titleFontSize = 25
        item.requiresCloseButton = false
        item.appearance.actionButtonFontSize = 20

        item.actionHandler = { _ in
            delegate.doneTapped(board, selection: item.spec)
        }
        
        return item
    }
    
    func makeChangeNameItem(_ delegate: BulletinBoardDelegate, board: BulletinBoard) -> ChangeNameItem {
        let item = ChangeNameItem(title: MyStrings.changeName)
        item.actionButtonTitle = MyStrings.done
        item.descriptionText = MyStrings.editName
        item.appearance.actionButtonColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        item.appearance.actionButtonTitleColor = .black
        item.appearance.titleFontSize = 25
        item.requiresCloseButton = false
        item.appearance.actionButtonFontSize = 20
        
        item.textInputHandler = { newName in
            delegate.doneTapped(board, selection: newName)
        }
        
        return item
    }
    
}
