//
//  ViewController.swift
//  Project7
//
//  Created by Vladimir on 15.12.2024.
//

import UIKit
import Foundation

class ViewController: UITableViewController {

    private var petitions = [Petition]()
    private var allPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Petitions"
        loadPetitions()
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(showInfoAlert))
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(filterButtonPressed))
        navigationItem.rightBarButtonItems = [infoButton, filterButton]
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = DetailViewController()
        dvc.petition = petitions[indexPath.row]
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    private func parse(json: Data) -> [Petition] {
        let decoder = JSONDecoder()
        guard let petitionsFromJSON = try? decoder.decode(Petitions.self, from: json) else {
            return [Petition]()
        }
        return petitionsFromJSON.results
    }
    
    @objc
    private func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Error", message: "Try reconnecting", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    @objc
    private func loadPetitions() {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let petitionsData = try? Data(contentsOf: url) {
                    self.allPetitions = self.parse(json: petitionsData)
                    self.petitions = self.allPetitions
                    DispatchQueue.main.async { self.tableView.reloadData() }
                } else {
                    self.showError()
                }
            }
        }
    }
    
    @objc
    private func showInfoAlert() {
        let ac = UIAlertController(title: "Info", message: "This data comes from the 'We The People API of the Whitehouse'", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc
    private func filterButtonPressed() {
        let ac = UIAlertController(title: "Filter petition entries", message: "Only petitions containing following words will be displayed", preferredStyle: .alert)
        ac.addTextField()
        let filterAction = UIAlertAction(title: "Filter", style: .default) { [weak self, weak ac] _ in
            guard let self, let ac else { return }
            if let filterString = ac.textFields?[0].text {
                applyFilters(using: filterString)
            }
        }
        let discardAction = UIAlertAction(title: "Discard filerts", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.petitions = self.allPetitions
            self.tableView.reloadData()
        }
        ac.addAction(filterAction)
        ac.addAction(discardAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.preferredAction = filterAction
        present(ac, animated: true)
    }
    
    private func applyFilters(using filterString: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let untrimmedFilteredWords = filterString.lowercased().components(separatedBy: .punctuationCharacters)
            let filteredWords = untrimmedFilteredWords.map( { $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            self.petitions = []
            for petition in self.allPetitions {
                for word in filteredWords {
                    if petition.body.lowercased().contains(word) || petition.title.lowercased().contains(word) {
                        self.petitions.append(petition)
                        break
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

