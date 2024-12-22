//
//  ViewController.swift
//  Project10
//
//  Created by Vladimir on 21.12.2024.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        let person = people[indexPath.item]
        let imagePath = getDocumentsDirectory().appendingPathComponent(person.imageName)
        let image = UIImage(contentsOfFile: imagePath.path())
        cell.imageView.image = image
        cell.name.text = person.name
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        cell.backgroundColor = .gray
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let name = ac?.textFields?[0].text else { return }
            print("ok")
            self?.people[indexPath.item].name = name
            print(self?.people[indexPath.item].name ?? "Lmao")
            self?.collectionView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Delete photo", style: .destructive) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.deleteItems(at: [indexPath])
        })
        
        present(ac, animated: true)
    }
    
    @objc
    private func addNewPerson() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            picker.sourceType = .camera
            print("camera available")
        } else {
            print("camera unavailable")
        }
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let imageData = image.jpegData(compressionQuality: 1) {
            try? imageData.write(to: imagePath)
        }
        let newPerson = Person(name: "Unknown", imageName: imageName)
        people.append(newPerson)
        collectionView.insertItems(at: [IndexPath(item: people.count - 1, section: 0)])
        dismiss(animated: true)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("info\n")
        print(Bundle.main.resourceURL ?? "resource url")
        print()
        print(Bundle.main.resourcePath ?? "resource path")
        print()
        print(Bundle.main.bundleIdentifier ?? "bundle id")
        print()
        print(Bundle.main.bundlePath)
        print()
        print(Bundle.main.bundleURL)
        return paths[0]
//        return Bundle.main.resourceURL!
    }
}

