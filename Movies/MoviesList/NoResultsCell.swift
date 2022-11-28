//
//  NoResultsCell.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import UIKit

class NoResultsCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.text = "No results"
        textLabel?.textColor = .lightGray
    }
}
