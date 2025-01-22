//
//  DetailViewController.swift
//  Challenge50
//
//  Created by Vladimir on 22.01.2025.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var picture: PictureInfo!
    var image: UIImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        imageView.sizeToFit()
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 10
        navigationItem.title = picture.caption
        navigationItem.largeTitleDisplayMode = .never
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
