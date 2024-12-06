//
//  ViewController.swift
//  Chanllenge23
//
//  Created by Vladimir on 05.12.2024.
//

import UIKit

class ViewController: UITableViewController {
    
    private var countries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        populateCountries()
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].uppercased()
        cell.imageView?.image = UIImage(named: countries[indexPath.row])
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.gray.cgColor
        cell.imageView?.layer.contentsScale = 0.1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else {
            fatalError("couldnt open controller")
        }
        vc.country = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func populateCountries() {
        let urls = Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: nil)
        if let urls {
            let untrimmedCountries = urls.map { $0.lastPathComponent }
            for country in untrimmedCountries {
                if let index = country.firstIndex(of: "@") {
                    countries.append(String(country.prefix(upTo: index)))
                }
            }
            countries = Array(Set(countries))
        }
    }

}

