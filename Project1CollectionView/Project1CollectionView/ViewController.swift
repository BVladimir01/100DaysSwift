//
//  ViewController.swift
//  Project1CollectionView
//
//  Created by Vladimir on 22.12.2024.
//

import UIKit

class ViewController: UICollectionViewController {
    
    private var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        performSelector(inBackground: #selector(self.loadPictures), with: nil)
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell {
            cell.backgroundColor = .lightGray
            cell.textLabel.text = pictures[indexPath.item]
            return cell
        } else {
            fatalError()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            navigationController?.pushViewController(vc, animated: true)
            vc.selectedImage = pictures[indexPath.item]
            vc.title = "Picture \(indexPath.item + 1) of \(pictures.count)"
        }
    }
    
    @objc
    private func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
    }
    
}

