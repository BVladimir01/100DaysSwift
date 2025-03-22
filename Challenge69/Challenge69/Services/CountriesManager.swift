//
//  Sorter.swift
//  Challenge69
//
//  Created by Vladimir on 22.03.2025.
//

import UIKit

class CountriesManager {
    private let store = CountriesStore.shared
    
    var sorting: Sorting = .date {
        didSet { save() }
    }
    var order: Order = .ascending {
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
            if order == .ascending {
                return res
            } else {
                return res.reversed()
            }
        }
    }
    
    var sortingCases = Sorting.allCases
    
    enum Sorting: String, CaseIterable, Codable {
        case date = "adding date", name, location
    }
    
    enum Order: Codable {
        case ascending, descending
    }
    
    private func save() {
        let encoder = JSONEncoder()
        do {
            let sortingData = try encoder.encode(sorting)
            let orderData = try encoder.encode(order)
            storage.set(sortingData, forKey: StorageKeys.sorting)
            storage.set(orderData, forKey: StorageKeys.order)
        } catch {
            print(error)
        }
    }
    
    private func load() {
        let decoder = JSONDecoder()
        if let sortingData = storage.data(forKey: StorageKeys.sorting), let orderData = storage.data(forKey: StorageKeys.order) {
            do {
                let sorting = try decoder.decode(Sorting.self, from: sortingData)
                let order = try decoder.decode(Order.self, from: orderData)
                self.sorting = sorting
                self.order = order
            } catch {
                print(error)
            }
        }
    }
    
    private let storage = UserDefaults.standard
    private struct StorageKeys {
        private init() { }
        static let sorting = "sortingKey"
        static let order = "orderKey"
    }
    
    init() {
        load()
    }
    
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
}
