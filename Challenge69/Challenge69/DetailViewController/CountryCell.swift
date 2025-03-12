//
//  CountryCell.swift
//  Challenge69
//
//  Created by Vladimir on 11.03.2025.
//

import UIKit

class CountryCell: UITableViewCell {
    
    @IBOutlet var countryImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    static let reuseID = "CountryCell"

}
