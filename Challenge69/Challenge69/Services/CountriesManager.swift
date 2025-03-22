//
//  Sorter.swift
//  Challenge69
//
//  Created by Vladimir on 22.03.2025.
//

class CountriesManager {
    private let store = CountriesStore.shared
    var sorting: Sorting = .date
    var order: Order = .ascending
    
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
        set {
            store.countries = newValue
        }
    }
    
    var sortingCases = Sorting.allCases
    
    enum Sorting: String, CaseIterable {
        case date = "adding date", name, location
    }
    
    enum Order {
        case ascending, descending
    }
    
}
