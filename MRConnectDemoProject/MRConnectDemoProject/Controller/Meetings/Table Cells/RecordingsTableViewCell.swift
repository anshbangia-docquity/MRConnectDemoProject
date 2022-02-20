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
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
}
