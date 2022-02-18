//
//  SpecPicker.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 01/02/22.
//

import UIKit
import BLTNBoard

enum BulletinTypes {
    
    case SpeckPicker
    case ChangeNumber
    case ChangeName
    case CheckPassword
    case ChangePassword
    case RecordItem
    
}

protocol BulletinBoardDelegate {
    func doneTapped(_ bulletinBoard: BulletinBoard, selection: Any, type: BulletinTypes)
}

class BulletinBoard {

    var boardManager: BLTNItemManager?
    var delegate: BulletinBoardDelegate?

    func define(of type: BulletinTypes, additional info: Any? = nil) {
        let bulletinItem = BulletinItems()
        
        var item: BLTNPageItem?
        switch type {
        case .SpeckPicker:
            item = bulletinItem.makeSpeckPickerItem(delegate, board: self)
        case .ChangeNumber:
            item = bulletinItem.makeChangeNumber(delegate, board: self)
        case .ChangeName:
            item = bulletinItem.makeChangeNameItem(delegate, board: self)
        case .CheckPassword:
            item = bulletinItem.makeCheckPasswordItem(delegate, board: self)
        case .RecordItem:
            item = bulletinItem.makeRecordItem(delegate, board: self, meeting: info as! Int16)
        default:
            break
        }
        
        boardManager = BLTNItemManager(rootItem: item!)
        boardManager!.cardCornerRadius = 18
    }

}


