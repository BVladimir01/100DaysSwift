//
//  DetailViewController.swift
//  Challenge69
//
//  Created by Vladimir on 11.03.2025.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var countryImageView: UIImageView!
    @IBOutlet var briefDescriptionLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var locationLabel: UILabel!
    
    var viewModel: CountryDetailViewModel? {
        didSet {
            configure()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        configure()
    }
    
    private func configure() {
        guard let viewModel, self.isViewLoaded else { return }
        countryImageView.image = viewModel.image
        briefDescriptionLabel.text = viewModel.briefDescription
        descriptionTextView.text = viewModel.description
        locationLabel.text = "Location: (lat: \(viewModel.location.lat.prettyRounded(to: 2)), lon: \(viewModel.location.lon.prettyRounded(to: 2)))"
        navigationItem.title = viewModel.name
    }
}


