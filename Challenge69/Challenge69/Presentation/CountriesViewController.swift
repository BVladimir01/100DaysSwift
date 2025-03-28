//
//  ViewController.swift
//  Challenge69
//
//  Created by Vladimir on 11.03.2025.
//

import UIKit


class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private let showDetailSegueID = "ShowDetail"
    private let countriesLoader: CountriesLoaderProtocol = CountriesLoader()
    private let countriesManager: CountriesManagerProtocol = CountriesManager()
    private var countries: [Country] {
        get {
            countriesManager.countries
        }
    }
    private var sortedCountries: [Country] {
        switch countriesManager.sorting {
        case .date:
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesLoader.delegate = self
        setupTableView()
        setupNavigationBar()
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
    }
    
    private func setupNavigationBar() {
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setRightBarButtonItems([setupAddButton(), setupSortingMenu()], animated: false)    }
    
    private func setupSortingMenu() -> UIBarButtonItem {
        let sortingActions = Sorting.allCases.map { sorting in
            var image: UIImage? = nil
            let imageName = countriesManager.ascendingOrder ? "arrow.up" : "arrow.down"
            if sorting == countriesManager.sorting { image = UIImage(systemName: imageName)}
            return UIAction(title: sorting.rawValue, image: image, identifier: .init(sorting.rawValue)) { [weak self] action in
                guard let self else { return }
                self.countriesManager.ascendingOrder.toggle()
                self.countriesManager.sorting = sorting
                self.setupNavigationBar()
                self.tableView.reloadData()
            }
        }
        let menu = UIMenu(title: "Sort by", identifier: .init("Sorting"), options: [.singleSelection], children: sortingActions)
        return UIBarButtonItem(title: "Sorting", image: UIImage(systemName: "arrow.up.arrow.down"), primaryAction: nil, menu: menu)
    }
    
    private func setupAddButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(Self.addCountry))
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
                    self?.countriesManager.modify(country: country)
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


// MARK: - CountriesLoaderDelegate
extension ViewController: CountriesLoaderDelegate {
    
    func didFetch(_ country: Country) {
        if !countries.contains(country) {
            countriesManager.add(country: country)
            if let id = countriesManager.countries.firstIndex(of: country) {
                tableView.insertRows(at: [IndexPath(row: id, section: 0)], with: .automatic)
            } else {
                tableView.reloadData()
            }
        }
    }
    
    func failedToFetch(_ country: String) {
        let ac = UIAlertController(title: "Failed to find country '\(country)'", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
}


// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: DetailViewController.StoryboardID) as? DetailViewController, let navigationController else {
            assertionFailure("Failed to create detailVC or get Navigation controller")
            return
        }
        var country = countries[indexPath.row]
        if let imageData = country.imageData {
            imageDataSaved(imageData)
        } else {
            loadImageData()
        }
        
        func imageDataSaved(_ imageData: Data) {
            let image = UIImage(data: imageData)!
            let viewModel = CountryDetailViewModel(name: country.name, image: image, briefDescription: country.briefDescription, description: country.description, location: country.location)
            detailVC.viewModel = viewModel
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController.pushViewController(detailVC, animated: true)
        }
        
        func loadImageData() {
            let reqest = URLRequest(url: URL(string: country.imageInfo.source)!)
            let task = URLSession.shared.data(for: reqest) { [weak self] result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)!
                    country.imageData = data
                    self?.countriesManager.modify(country: country)
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
        let removedCountry = countries[indexPath.row]
        countriesManager.remove(country: removedCountry)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

}


// MARK: - UITableViewDataSource
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
