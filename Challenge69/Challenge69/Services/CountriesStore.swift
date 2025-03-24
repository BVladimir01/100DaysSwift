//
//  CountriesStore.swift
//  Challenge69
//
//  Created by Vladimir on 12.03.2025.
//

import Foundation


//MARK: - CountriesStoreProtocol
protocol CountriesStoreProtocol {
    var countries: [Country] { get set }
}


//MARK: - CountriesStore
class CountriesStore: CountriesStoreProtocol {
    
    // MARK: Internal Properties
    
    static let shared = CountriesStore()
    var countries: [Country] = [] {
        didSet { store() }
    }
    
    // MARK: - Private Properties
    
    private let storageKey: String = "Countries"
    private let storage = UserDefaults.standard
    
    // MARK: - Initializers
    
    private init() {
        load()
    }
    
    // MARK: - Private Methods
    
    private func store() {
        guard let encodedCountries = try? JSONEncoder().encode(countries) else {
            print("failed to encode and store countries")
            return
        }
        storage.set(encodedCountries, forKey: storageKey)
    }
    
    private func load() {
        guard let countriesData = storage.data(forKey: storageKey) else {
            print("failed to get data from storage")
            return
        }
        do {
            let decodedCountries = try JSONDecoder().decode([Country].self, from: countriesData)
            countries = decodedCountries
        } catch {
            print(error)
            print("----------------")
        }
    }
}
