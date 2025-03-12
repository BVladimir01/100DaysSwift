//
//  CountriesLoader.swift
//  Challenge69
//
//  Created by Vladimir on 11.03.2025.
//

import Foundation


protocol CountriesLoaderProtocol {
    func fetchCountry(_ name: String)
}

protocol CountriesLoaderDelegate: AnyObject {
    func didFetchCountry(_ country: Country)
}

class CountriesLoader: CountriesLoaderProtocol {
    
    weak var delegate: CountriesLoaderDelegate?
    private let baseURLString = "https://en.wikipedia.org/api/rest_v1/page/summary/"
    
    func fetchCountry(_ name: String) {
        guard let url = URL(string: baseURLString + name) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let country = try JSONDecoder().decode(Country.self, from: data)
                    self?.delegate?.didFetchCountry(country)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        task.resume()
    }
    
}
