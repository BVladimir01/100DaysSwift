//
//  DetailViewController.swift
//  Chanllenge23
//
//  Created by Vladimir on 05.12.2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    var country: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let country {
            countryImage.image = UIImage(named: country)
            navigationItem.title = country.uppercased()
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: .actions, style: .plain, target: self, action: #selector(shareTapped))
        }
    }
    
    @objc
    private func shareTapped() {
        guard let image = countryImage.image?.jpegData(compressionQuality: 1), let country else {
            fatalError("image or country not found")
        }
        let ac = UIActivityViewController(activityItems: [image, country.uppercased()], applicationActivities: nil)
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    
    @IBOutlet private weak var countryImage: UIImageView!
    
}
