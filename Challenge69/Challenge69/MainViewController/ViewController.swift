//
//  ViewController.swift
//  Challenge69
//
//  Created by Vladimir on 11.03.2025.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let countriesLoader = CountriesLoader()
    
    private var countries: [Country] = [
        .init(name: "Germany", imageURL: "https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Flag_of_Germany.svg/1000px-Flag_of_Germany.svg.png", thumbnailURL: "https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Flag_of_Germany.svg/320px-Flag_of_Germany.svg.png", descriptionBrief: "Country in Central Europe", location: .init(lat: 51, lon: 9), description: "Germany, officially the Federal Republic of Germany, is a country in Central Europe. It lies between the Baltic Sea and the North Sea to the north and the Alps to the south. Its sixteen constituent states have a total population of over 82 million in an area of 357,596 km2 (138,069 sq mi), making it the most populous member state of the European Union. It borders Denmark to the north, Poland and the Czech Republic to the east, Austria and Switzerland to the south, and France, Luxembourg, Belgium, and the Netherlands to the west. The nation's capital and most populous city is Berlin and its main financial centre is Frankfurt; the largest urban area is the Ruhr."),
        .init(name: "Russia", imageURL: "https://upload.wikimedia.org/wikipedia/en/thumb/f/f3/Flag_of_Russia.svg/900px-Flag_of_Russia.svg.png", thumbnailURL: "https://upload.wikimedia.org/wikipedia/en/thumb/f/f3/Flag_of_Russia.svg/320px-Flag_of_Russia.svg.png", descriptionBrief: "Country spanning Europe and Asia", location: .init(lat: 66, lon: 94), description: "Russia, or the Russian Federation, is a country spanning Eastern Europe and North Asia. It is the largest country in the world by land area, and extends across eleven time zones; sharing land borders with fourteen countries. Russia is the most populous country in Europe and the ninth-most populous country in the world. It is a highly urbanised country, with sixteen of its urban areas having more than 1 million inhabitants. Moscow, the most populous metropolitan area in Europe, is the capital and largest city of Russia, while Saint Petersburg is its second-largest city and cultural centre.")
    ]
    
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
        let country = countries[indexPath.row]
        cell.nameLabel.text = country.name
        cell.nameLabel.sizeToFit()
        cell.descriptionLabel.text = country.briefDescription
        let request = URLRequest(url: URL(string: country.thumbnailURL)!)
        let task = URLSession.shared.data(for: request) { [weak cell] result in
            switch result {
            case .success(let data):
                cell?.countryImageView.image = UIImage(data: data)
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
