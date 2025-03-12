//
//  CountriesStore.swift
//  Challenge69
//
//  Created by Vladimir on 12.03.2025.
//

import Foundation

class CountriesStore {
    
    var countries: Set<Country> = []
    
    private let storageKey: String = "Countries"
    private let storage = UserDefaults.standard
    
    static let shared = CountriesStore()
    
    private init() {
        guard let countriesData = storage.data(forKey: storageKey), let decodedCountries = try? JSONDecoder().decode(Set<Country>.self, from: countriesData) else { return }
        countries = decodedCountries
    }
    
    func store() {
        guard let encodedCountries = try? JSONEncoder().encode(countries) else { return }
        storage.set(encodedCountries, forKey: storageKey)
    }
}
