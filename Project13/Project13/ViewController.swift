//
//  ViewController.swift
//  Project13
//
//  Created by Vladimir on 26.01.2025.
//

import CoreImage
import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private var currentImage: UIImage?
    private var context: CIContext!
    private var currentFilter: CIFilter!
    
    @IBOutlet weak var intensity: UISlider!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var changeFilterButton: UIButton!
    
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
    
    private func setFilter(action: UIAlertAction) {
        guard let filterName = action.title else { return }
        currentFilter = CIFilter(name: "CI" + filterName)
        changeFilterButton.setTitle(filterName, for: .normal)
        guard let currentImage else { return }
        setFilterBeginImage(to: currentImage)
        fadeImageOut { [weak self] in
            self?.applyProcessing()
            self?.fadeImageIn()
        }
    }
    
    @IBAction func save() {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Error", message: "No image chosen", preferredStyle: .alert)
            ac.addAction(.init(title: "Ok", style: .cancel))
            present(ac, animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc
    private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error {
            let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(.init(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved", message: "Your altered image has been saved to your photos", preferredStyle: .alert)
            ac.addAction(.init(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func intensityChanged() {
        applyProcessing()
    }
    
    @IBAction func radiusChanged() {
        applyProcessing()
    }
    
    private func applyProcessing() {
        guard let filteredImage = currentFilter.outputImage, let currentImage else { return }
        let intensity = intensity.value
        let radius = radiusSlider.value
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {currentFilter.setValue(intensity, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey) {currentFilter.setValue(radius, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputScaleKey) {currentFilter.setValue(intensity*10, forKey: kCIInputScaleKey)}
        if inputKeys.contains(kCIInputCenterKey) {currentFilter.setValue(CIVector(x: currentImage.size.width/2, y: currentImage.size.height/2), forKey: kCIInputCenterKey)}
        guard let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage)
        imageView.image = uiImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        title = "YACIFP"
        intensity.value = 1
        radiusSlider.value = 1
        radiusSlider.minimumValue = 0.1
        radiusSlider.maximumValue = 500
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
        dismiss(animated: true)
        setFilterBeginImage(to: image)
        if currentImage != nil {
            fadeImageOut { [weak self] in
                self?.currentImage = image
                self?.applyProcessing()
                self?.fadeImageIn()
            }
        } else {
            currentImage = image
            applyProcessing()
            fadeImageIn()
        }
    }
    
    private func fadeImageOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = 0
        } completion: { _ in
            completion()
        }
    }
    
    private func fadeImageIn() {
        imageView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = 1
        }
    }
    
    private func setFilterBeginImage(to image: UIImage) {
        currentFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
    }
}

