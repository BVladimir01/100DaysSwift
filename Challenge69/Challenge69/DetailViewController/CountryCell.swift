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
            } else {
                activityIndicator.startAnimating()
            }
        }
    }
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    static let reuseID = "CountryCell"
    
    override func prepareForReuse() {
        nameLabel.text = nil
        descriptionLabel.text = nil
        countryImageView.image = nil
    }

    func configure(with viewModel: CountryViewModel) {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        countryImageView.image = viewModel.image
        activityIndicator.stopAnimating()
    }

}
