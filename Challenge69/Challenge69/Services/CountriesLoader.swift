//
//  CountriesLoader.swift
//  Challenge69
//
//  Created by Vladimir on 11.03.2025.
//

import Foundation


protocol CountriesLoaderProtocol: AnyObject {
    var delegate: CountriesLoaderDelegate? { get set }
    func fetchCountry(_ name: String)
}


protocol CountriesLoaderDelegate: AnyObject {
    func didFetch(_ country: Country)
    func failedToFetch(_ country: String)
}


class CountriesLoader: CountriesLoaderProtocol {
    
    // MARK: - Internal Properties
    
    weak var delegate: CountriesLoaderDelegate?
    
    // MARK: - Private Properties
    
    private let baseURLString = "https://en.wikipedia.org/api/rest_v1/page/summary/"
    
    // MARK: - Interntal Methods
    
    func fetchCountry(_ name: String) {
        guard let url = URL(string: baseURLString + name) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let country = try JSONDecoder().decode(Country.self, from: data)
                    self?.delegate?.didFetch(country)
                } catch {
                    print(error)
                    self?.delegate?.failedToFetch(name)
                }
            case .failure(let error):
                print(error)
                self?.delegate?.failedToFetch(name)
            }
        }
        task.resume()
    }
    
}
