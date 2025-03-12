//
//  Country.swift
//  Challenge69
//
//  Created by Vladimir on 11.03.2025.
//

import UIKit

struct Country: Decodable, Identifiable, Encodable, Hashable {
    
    var id: String {
        get {
            name
        }
    }
    
    let name: String
    let imageURL: String
    var imageData: Data? = nil
    let thumbnailURL: String
    var thumbnailImageData: Data? = nil
    let briefDescription: String
    let location: Location
    let description: String
    
    private struct ImageInfo: Decodable {
        let source: String
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case imageURL = "originalimage"
        case imageData
        case thumbnailURL = "thumbnail"
        case thumbnailData
        case briefDescription = "description"
        case description = "extract"
        case location
        case coordinates
    }
    
    init(name: String, imageURL: String, thumbnailURL: String, descriptionBrief: String, location: Location, description: String) {
        self.name = name
        self.imageURL = imageURL
        self.thumbnailURL = thumbnailURL
        self.briefDescription = descriptionBrief
        self.location = location
        self.description = description
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.briefDescription = try container.decode(String.self, forKey: .briefDescription)
        self.description = try container.decode(String.self, forKey: .description)
        if let location = try? container.decode(Location.self, forKey: .location) {
            self.location = location
        } else if let location = try? container.decode(Location.self, forKey: .coordinates) {
            self.location = location
        } else {
            throw DecodingError.locationError
        }
        let thumbnailImageInfo = try container.decode(ImageInfo.self, forKey: .thumbnailURL)
        self.thumbnailURL = thumbnailImageInfo.source
        let originalImageInfo = try container.decode(ImageInfo.self, forKey: .imageURL)
        self.imageURL = originalImageInfo.source
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(imageData, forKey: .imageData)
        try container.encode(thumbnailURL, forKey: .thumbnailURL)
        try container.encode(thumbnailImageData, forKey: .thumbnailData)
        try container.encode(briefDescription, forKey: .briefDescription)
        try container.encode(description, forKey: .description)
        try container.encode(location, forKey: .location)
        try container.encode(location, forKey: .coordinates)
    }
}


extension Country: Equatable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.name == rhs.name
    }
}


struct Location: Codable, Hashable {
    let lat: Double
    let lon: Double
}


enum DecodingError: Error {
    case locationError
}
