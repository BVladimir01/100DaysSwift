//
//  ViewController.swift
//  Project13
//
//  Created by Vladimir on 26.01.2025.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private var currentImage: UIImage!

    @IBOutlet weak var intensity: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func changeFilter() {
    }
    
    @IBAction func save() {
    }
    @IBAction func intensityChanged() {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
    }

    
    @objc
    private func addPicture() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        currentImage = image
    }
}

