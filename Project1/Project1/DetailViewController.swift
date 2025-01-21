//
//  DetailViewController.swift
//  Project1
//
//  Created by Vladimir on 02.12.2024.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var counterLabel: UILabel!
    
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedImage {
            imageView.image = UIImage(named: selectedImage)
            let numbersOpened = UserDefaults.standard.integer(forKey: selectedImage)
            counterLabel.text = "This image was opened \(numbersOpened + 1) time(s)"
            UserDefaults.standard.set(numbersOpened + 1, forKey: selectedImage)
        }
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .actions, style: .plain, target: self, action: #selector(shareTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc
    private func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 1) else {
            fatalError("no image found")
        }
        let ac = UIActivityViewController(activityItems: [image, selectedImage ?? "name is n/a"], applicationActivities: [])
//        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}
