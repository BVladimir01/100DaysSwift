//
//  ViewController.swift
//  Project7
//
//  Created by Vladimir on 15.12.2024.
//

import UIKit

class ViewController: UITableViewController {

    private var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        if let url = URL(string: urlString) {
            if let petitionsData = try? Data(contentsOf: url) {
                petitions = parse(json: petitionsData)
                tableView.reloadData()
            }
        }
        navigationItem.title = "Petitions"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = indexPath.row
        cell.textLabel?.text = petitions[petition].title
        cell.detailTextLabel?.text = petitions[petition].body
        return cell
    }
    
    private func parse(json: Data) -> [Petition] {
        let decoder = JSONDecoder()
        guard let petitionsFromJSON = try? decoder.decode(Petitions.self, from: json) else {
            return [Petition]()
        }
        return petitionsFromJSON.results
    }
}

