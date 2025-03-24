//
//  Sorter.swift
//  Challenge69
//
//  Created by Vladimir on 22.03.2025.
//

import UIKit


// MARK: - Sorting
enum Sorting: String, CaseIterable, Codable {
    case date = "adding date", name, location
}


//MARK: CountriesManagerProtocol
protocol CountriesManagerProtocol: AnyObject {
    
    var sorting: Sorting { get set }
    var ascendingOrder: Bool { get set }
    var countries: [Country] { get }
    
    func remove(country: Country)
    func add(country: Country)
    func modify(country: Country)
}

class CountriesManager: CountriesManagerProtocol {
    
    // MARK: - Internal Properties
    var sorting: Sorting = .date
    var ascendingOrder = true {
        didSet { save() }
    }
    var countries: [Country] {
        get {
            var res: [Country]
            switch sorting {
            case .date:
                res = store.countries
            case .name:
                res = store.countries.sorted(by: { arg1, arg2 in
                    arg1.name < arg2.name
                })
            case .location:
                res = store.countries.sorted(by: { arg1, arg2 in
                    arg1.location < arg2.location
                })
            }
            if ascendingOrder {
                return res
            } else {
                return res.reversed()
            }
        }
    }
    
    // MARK: - Private Properties
    
    private let store = CountriesStore.shared
    private let storage = UserDefaults.standard
    
    enum Order: Codable {
        case ascending, descending
    }
    
    // MARK: - Private Types
    
    private struct StorageKeys {
        private init() { }
        static let sorting = "sortingKey"
        static let order = "orderKey"
    }
    
    // MARK: - Initializers
    
    init() {
        load()
    }
    
    //MARK: - Internal Methods
    
    func remove(country: Country) {
        if let id = store.countries.firstIndex(of: country) {
            store.countries.remove(at: id)
        }
    }
    
    func add(country: Country) {
        self.store.countries.append(country)
    }
    
    func modify(country: Country) {
        if let id = store.countries.firstIndex(where: { $0.name == country.name }) {
            store.countries[id] = country
        }
    }
    
    // MARK: - Private Methods
    
    private func save() {
        let encoder = JSONEncoder()
        storage.set(ascendingOrder, forKey: StorageKeys.order)
        do {
            let sortingData = try encoder.encode(sorting)
            storage.set(sortingData, forKey: StorageKeys.sorting)
        } catch {
            print(error)
        }
    }
    
    private func load() {
        let decoder = JSONDecoder()
        self.ascendingOrder = storage.bool(forKey: StorageKeys.order)
        if let sortingData = storage.data(forKey: StorageKeys.sorting) {
            do {
                let sorting = try decoder.decode(Sorting.self, from: sortingData)
                self.sorting = sorting
            } catch {
                print(error)
            }
        }
    }
    
}
