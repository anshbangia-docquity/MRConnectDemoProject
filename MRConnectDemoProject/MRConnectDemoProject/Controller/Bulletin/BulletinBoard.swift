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
            let info = info as! String
            item = bulletinItem.makeCheckPasswordItem(delegate, board: self, email: info)
        case .RecordItem:
            let info = info as! (String, Date)
            item = bulletinItem.makeRecordItem(delegate, board: self, meetingId: info.0, endDate: info.1)
        default:
            break
        }
        
        boardManager = BLTNItemManager(rootItem: item!)
        boardManager!.cardCornerRadius = 18
    }

}


