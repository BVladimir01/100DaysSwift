//
//  ViewController.swift
//  Project13
//
//  Created by Vladimir on 26.01.2025.
//

import CoreImage
import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private var currentImage: UIImage!
    private var context: CIContext!
    private var currentFilter: CIFilter!

    @IBOutlet weak var intensity: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func changeFilter() {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(.init(title: "BumpDistortion", style: .default, handler: setFilter))
        ac.addAction(.init(title: "GaussianBlur", style: .default, handler: setFilter))
        ac.addAction(.init(title: "Pixellate", style: .default, handler: setFilter))
        ac.addAction(.init(title: "SepiaTone", style: .default, handler: setFilter))
        ac.addAction(.init(title: "TwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(.init(title: "UnsharpMask", style: .default, handler: setFilter))
        ac.addAction(.init(title: "Vignette", style: .default, handler: setFilter))
        ac.addAction(.init(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func save() {
    }
    
    @IBAction func intensityChanged() {
        applyProcessing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        title = "YACIFP"
        intensity.value = 1
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
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        dismiss(animated: true)
        applyProcessing()
    }
    
    private func applyProcessing() {
        guard let filteredImage = currentFilter.outputImage else { return }
        let intensity = intensity.value
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {currentFilter.setValue(intensity, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey) {currentFilter.setValue(intensity*200, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputScaleKey) {currentFilter.setValue(intensity*10, forKey: kCIInputScaleKey)}
        if inputKeys.contains(kCIInputCenterKey) {currentFilter.setValue(CIVector(x: currentImage.size.width/2, y: currentImage.size.height/2), forKey: kCIInputCenterKey)}
        guard let endImage = context.createCGImage(filteredImage, from: filteredImage.extent) else { return }
        let uiImage = UIImage(cgImage: endImage)
//        let uiImage = UIImage(ciImage: filteredImage)
        imageView.image = uiImage
    }
    
    private func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let filterName = action.title else { return }
        let beginImage = CIImage(image: currentImage)
        currentFilter = CIFilter(name: "CI" + filterName)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
}

