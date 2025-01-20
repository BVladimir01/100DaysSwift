//
//  Person.swift
//  Project10
//
//  Created by Vladimir on 21.12.2024.
//

import UIKit

class Person: NSObject, NSCoding {
    
    var name: String
    var imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
    
    // MARK: - NSCoding
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "nameKey")
        coder.encode(imageName, forKey: "imageNameKey")
    }
    
    required init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: "nameKey") as? String else { return nil }
        guard let imageName = coder.decodeObject(forKey: "imageNameKey") as? String else { return nil }
        self.name = name
        self.imageName = imageName
    }
}
