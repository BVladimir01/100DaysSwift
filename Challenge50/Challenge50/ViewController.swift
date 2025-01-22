//
//  ViewController.swift
//  Challenge50
//
//  Created by Vladimir on 22.01.2025.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var pictures = [PictureInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pictures"
        navigationController?.navigationBar.prefersLargeTitles = true
        loadPictures()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(self.addPicture))
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = pictures[indexPath.row].caption
//        content.secondaryText = "secondaryText"
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pictures.remove(at: indexPath.row)
            savePictures()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let picture = pictures[indexPath.row]
        vc.picture = picture
        vc.image = getImage(id: picture.id.uuidString)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func addPicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let newPicture = PictureInfo(caption: "Caption")
        saveImage(image, withID: newPicture.id.uuidString)
        pictures.append(newPicture)
        dismiss(animated: true)
        presentAlertForCaptionEdit()
    }
    
    private func saveImage(_ image: UIImage, withID id: String) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let saveUrl = path.appending(path: id)
        let savingData = image.jpegData(compressionQuality: 1)
        try! savingData?.write(to: saveUrl)
    }
    
    private func getImage(id: String) -> UIImage{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let saveUrl = path.appending(path: id)
        let data = try! Data(contentsOf: saveUrl)
        return UIImage(data: data)!
    }
    
    private func savePictures() {
        if let picturesData = try? JSONEncoder().encode(pictures) {
            UserDefaults.standard.set(picturesData, forKey: "picturesInfo")
        }
    }
    
    private func loadPictures() {
        if let picturesData = UserDefaults.standard.data(forKey: "picturesInfo") {
            pictures = (try? JSONDecoder().decode([PictureInfo].self, from: picturesData)) ?? []
        }
    }
    
    private func presentAlertForCaptionEdit() {
        let ac = UIAlertController(title: "Add caption to your picture", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let action = UIAlertAction(title: "Confirm", style: .default) { [weak self, weak ac] _ in
            guard let self, let ac else { return }
            let caption = ac.textFields?[0].text ?? ""
            self.pictures[self.pictures.count - 1].caption = caption
            self.savePictures()
            self.tableView.insertRows(at: [IndexPath(row: self.pictures.count - 1, section: 0)], with: .automatic)
        }
        ac.addAction(action)
        ac.preferredAction = action
        present(ac, animated: true)
    }
}

