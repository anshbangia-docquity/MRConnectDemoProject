//
//  RecordingsTableViewCell.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 19/02/22.
//

import UIKit

class RecordingsTableViewCell: UITableViewCell {
    
    static let id = "recordingTableCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    func configure(title: String, duration: String) {
        titleLabel.text = title
        durationLabel.text = duration
    }
    
}
