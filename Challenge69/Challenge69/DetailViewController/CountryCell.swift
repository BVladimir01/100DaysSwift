//
//  CountryCell.swift
//  Challenge69
//
//  Created by Vladimir on 11.03.2025.
//

import UIKit

class CountryCell: UITableViewCell {
    
    @IBOutlet var countryImageView: UIImageView! {
        didSet {
            if countryImageView.image != nil {
                activityIndicator.stopAnimating()
            }
        }
    }
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    static let reuseID = "CountryCell"
    
    func didLoadImage() {
        activityIndicator.stopAnimating()
    }

}
