//
//  MeetingDoctorsCollectionViewCell.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 11/02/22.
//

import UIKit

class MeetingDoctorsCollectionViewCell: UICollectionViewCell {
    
    static let id = "meetingDoctorsCollectionCell"
    
    @IBOutlet weak var image: UIImageView!
    
    func configure(image: UIImage) {
        self.image.image = image
    }
}
