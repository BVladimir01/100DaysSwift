//
//  CountriesStore.swift
//  Challenge69
//
//  Created by Vladimir on 12.03.2025.
//

import Foundation

class CountriesStore {
    
    var countries: [Country] = [] {
        didSet {
            store()
            print("Stored")
        }
    }
    
    private let storageKey: String = "Countries"
    private let storage = UserDefaults.standard
    
    static let shared = CountriesStore()
    
    private init() {
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
    
    private func store() {
        guard let encodedCountries = try? JSONEncoder().encode(countries) else {
            print("failed to encode and store countries")
            return
        }
        storage.set(encodedCountries, forKey: storageKey)
    }
}
