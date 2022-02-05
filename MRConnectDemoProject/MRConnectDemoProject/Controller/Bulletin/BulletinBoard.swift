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
    case ChangeName
    
}

protocol BulletinBoardDelegate {
    func doneTapped(_ bulletinBoard: BulletinBoard, selection: Any)
}

class BulletinBoard {

    var boardManager: BLTNItemManager?
    var delegate: BulletinBoardDelegate?

    func define(of type: BulletinTypes) {
        let bulletinItem = BulletinItems()
        
        var item: BLTNPageItem
        switch type {
        case .SpeckPicker:
            item = bulletinItem.makeSpeckPickerItem(delegate!, board: self)
        case .ChangeName:
            item = bulletinItem.makeChangeNameItem(delegate!, board: self)
        }
        
        boardManager = BLTNItemManager(rootItem: item)
        boardManager!.cardCornerRadius = 18
    }

}
