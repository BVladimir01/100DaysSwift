//
//  ViewController.swift
//  Challenge32
//
//  Created by Vladimir on 15.12.2024.
//

import UIKit

class ViewController: UITableViewController {

    private var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonPushed))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        navigationItem.title = "Shopping list"
        navigationItem.rightBarButtonItems = [addButton, shareButton]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cart", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc
    private func addButtonPushed() {
        let ac = UIAlertController(title: "Add new item to the list", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let action = UIAlertAction(title: "Submit", style: .default) { [weak self, ac] action in
            guard let self else { return }
            guard let shoppingItemString = ac.textFields?[0].text else { return }
            self.shoppingList.append(shoppingItemString)
            self.tableView.insertRows(at: [IndexPath(row: self.shoppingList.count - 1, section: 0)], with: .automatic)
        }
        ac.addAction(action)
        ac.preferredAction = action
        present(ac, animated: true)
    }
    
    @objc
    private func shareButtonTapped() {
        let ac = UIActivityViewController(activityItems: [shoppingList.joined(separator: "\n")], applicationActivities: nil)
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[1]
        present(ac, animated: true)
    }
}

