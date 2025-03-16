//
//  ViewController.swift
//  Challenge69
//
//  Created by Vladimir on 11.03.2025.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let showDetailSegueID = "ShowDetail"
    
    private let countriesLoader = CountriesLoader()
    
    private let storage = CountriesStore.shared
    
    private var countries: [Country] {
        get {
            storage.countries
        }
        set {
            storage.countries = newValue
        }
    }
    
    private var sorting: Sorting = .default
    
    private var sortedCountries: [Country] {
        switch sorting {
        case .default:
            return countries
        case .name:
            return countries.sorted(using: SortDescriptor(\.name, comparator: .lexical))
        case .location:
            return countries.sorted { country1, country2 in
                if country1.location.lat < country2.location.lat {
                    return true
                } else if country1.location.lat > country2.location.lat {
                    return false
                } else  {
                    return country1.location.lon < country2.location.lon
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesLoader.delegate = self
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
    }
    
    private func setupNavigationBar() {
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(Self.addCountry))
    }
    
    private func configCell(_ cell: CountryCell, at indexPath: IndexPath) {
        var country = countries[indexPath.row]
        if let imageData = country.thumbnailData {
            let image = UIImage(data: imageData)!
            let viewModel = CountryViewModel(name: country.name, image: image, description: country.briefDescription)
            cell.configure(with: viewModel)
        } else {
            let request = URLRequest(url: URL(string: country.thumbnailInfo.source)!)
            let task = URLSession.shared.data(for: request) { [weak cell, weak self] result in
                switch result {
                case .success(let data):
                    country.thumbnailData = data
                    self?.countries[indexPath.row] = country
                    let image = UIImage(data: data)!
                    let viewModel = CountryViewModel(name: country.name, image: image, description: country.briefDescription)
                    cell?.configure(with: viewModel)
                case .failure(let error):
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    @objc
    private func addCountry() {
        let ac = UIAlertController(title: "Add new Country", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let addAction = UIAlertAction(title: "Search", style: .default) { [weak self] alertAction in
            guard let textField = ac.textFields?.first, let countryName = textField.text?.capitalized else { return }
            self?.countriesLoader.fetchCountry(countryName)
        }
        ac.addAction(addAction)
        ac.preferredAction = addAction
        ac.addAction(.init(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}


extension ViewController: CountriesLoaderDelegate {
    
    func didFetch(_ country: Country) {
        if !countries.contains(country) {
            countries.append(country)
            tableView.insertRows(at: [IndexPath(row: countries.count - 1, section: 0)], with: .automatic)
        }
    }
    
    func failedToFetch(_ country: String) {
        let ac = UIAlertController(title: "Failed to find country '\(country)'", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: DetailViewController.StoryboardID) as? DetailViewController, let navigationController else {
            assertionFailure("Failed to create detailVC or get Navigation controller")
            return
        }
        var country = countries[indexPath.row]
        if let imageData = country.imageData {
            let image = UIImage(data: imageData)!
            let viewModel = CountryDetailViewModel(name: country.name, image: image, briefDescription: country.briefDescription, description: country.description, location: country.location)
            detailVC.viewModel = viewModel
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController.pushViewController(detailVC, animated: true)
        } else {
            let reqest = URLRequest(url: URL(string: country.imageInfo.source)!)
            let task = URLSession.shared.data(for: reqest) { [weak self] result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)!
                    country.imageData = data
                    self?.countries[indexPath.row] = country
                    let viewModel = CountryDetailViewModel(name: country.name, image: image, briefDescription: country.briefDescription, description: country.description, location: country.location)
                    detailVC.viewModel = viewModel
                    tableView.deselectRow(at: indexPath, animated: true)
                    navigationController.pushViewController(detailVC, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        countries.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.reuseID, for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        configCell(cell, at: indexPath)
        return cell
    }
    
}


enum Sorting: String {
    case `default`, name, location
}
