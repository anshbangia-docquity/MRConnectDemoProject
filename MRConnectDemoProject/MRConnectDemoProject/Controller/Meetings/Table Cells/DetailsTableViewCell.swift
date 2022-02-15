//
//  DetailsTableViewCell.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 10/02/22.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    static let id = "detailTableCell"

    @IBOutlet weak var titleLabel: UILabel!
    
    func config(title: String) {
        titleLabel.text = title
    }

}
