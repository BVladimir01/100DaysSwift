//
//  ViewController.swift
//  Challenge69
//
//  Created by Vladimir on 11.03.2025.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let showDetailSegueID = "ShowContryDetail"
    
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
    
    private var testCountries: [Country] = [
        Country(name: "Croatia", imageInfo: ImageInfo(source: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Flag_of_Croatia.svg/1200px-Flag_of_Croatia.svg.png", width: 1200, height: 600), thumbnailInfo: ImageInfo(source: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Flag_of_Croatia.svg/320px-Flag_of_Croatia.svg.png", width: 320, height: 160), briefDescription: "Country in Central and Southeast Europe", location: Location(lat: 45.16666667, lon: 15.5), description: "Croatia, officially the Republic of Croatia, is a country in Central and Southeast Europe, on the coast of the Adriatic Sea. It borders Slovenia to the northwest, Hungary to the northeast, Serbia to the east, Bosnia and Herzegovina and Montenegro to the southeast, and shares a maritime border with Italy to the west. Its capital and largest city, Zagreb, forms one of the country's primary subdivisions, with twenty counties. Other major urban centers include Split, Rijeka and Osijek. The country spans 56,594 square kilometres, and has a population of nearly 3.9 million.)"),
        Country(name: "Japan", imageInfo: ImageInfo(source: "https://upload.wikimedia.org/wikipedia/en/thumb/9/9e/Flag_of_Japan.svg/900px-Flag_of_Japan.svg.png", width: 900, height: 600), thumbnailInfo: ImageInfo(source: "https://upload.wikimedia.org/wikipedia/en/thumb/9/9e/Flag_of_Japan.svg/320px-Flag_of_Japan.svg.png", width: 320, height: 213), briefDescription: "Island country in East Asia", location: Location(lat: 36, lon: 138), description: "Japan is an island country in East Asia. Located in the Pacific Ocean off the northeast coast of the Asian mainland, it is bordered on the west by the Sea of Japan and extends from the Sea of Okhotsk in the north to the East China Sea in the south. The Japanese archipelago consists of four major islands—Hokkaido, Honshu, Shikoku, and Kyushu—and thousands of smaller islands, covering 377,975 square kilometers (145,937 sq mi). Japan has a population of over 123 million as of 2025, making it the eleventh-most populous country.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesLoader.delegate = self
        setupTableView()
        setupNavigationBar()
//        countries = testCountries
        print(countries)
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
        let country = countries[indexPath.row]
        let request = URLRequest(url: URL(string: country.thumbnailInfo.source)!)
        let task = URLSession.shared.data(for: request) { [weak cell] result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)!
                let viewModel = CountryViewModel(name: country.name, image: image, description: country.briefDescription)
                cell?.configure(with: viewModel)
            case .failure(let error):
                print(error)
            }
        }
        task.resume()
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
    func didFetchCountry(_ country: Country) {
        if !countries.contains(country) {
            countries.append(country)
            tableView.insertRows(at: [IndexPath(row: countries.count - 1, section: 0)], with: .automatic)
        }
    }
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        countries.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        defer { super.prepare(for: segue, sender: sender) }
        guard segue.identifier == showDetailSegueID else { return }
        guard let detailVC = segue.destination as? DetailViewController, let cell = sender as? CountryCell, let indexPath = tableView.indexPath(for: cell) else {
            assertionFailure("Failed to create DetailVc or extract cell or extract indexPath")
            return
        }
        let country = countries[indexPath.row]
        let reqest = URLRequest(url: URL(string: country.imageInfo.source)!)
        let task = URLSession.shared.data(for: reqest) { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)!
                let viewModel = CountryDetailViewModel(name: country.name, image: image, briefDescription: country.briefDescription, description: country.description, location: country.location)
                detailVC.configure(with: viewModel)
            case .failure(let error):
                print(error)
            }
        }
        task.resume()
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
