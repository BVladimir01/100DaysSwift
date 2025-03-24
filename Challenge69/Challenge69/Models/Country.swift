//
//  Country.swift
//  Challenge69
//
//  Created by Vladimir on 11.03.2025.
//

import UIKit

struct Country: Identifiable, Hashable {
    
    //MARK: Internal Properties
    
    var id: String {
        get {
            name
        }
    }
    let name: String
    let imageInfo: ImageInfo
    var imageData: Data? = nil
    let thumbnailInfo: ImageInfo
    var thumbnailData: Data? = nil
    let briefDescription: String
    let location: Location
    let description: String
    
    //MARK: - Inintializers
    
    init(name: String, imageInfo: ImageInfo, imageData: Data? = nil, thumbnailInfo: ImageInfo, thumbnailData: Data? = nil, briefDescription: String, location: Location, description: String) {
        self.name = name
        self.imageInfo = imageInfo
        self.imageData = imageData
        self.thumbnailInfo = thumbnailInfo
        self.thumbnailData = thumbnailData
        self.briefDescription = briefDescription
        self.location = location
        self.description = description
    }
    
}


//MARK: - Codable
extension Country: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case imageInfo = "originalimage"
        case imageData
        case thumnailInfo = "thumbnail"
        case thumbnailData
        case briefDescription = "description"
        case description = "extract"
        case location
        case coordinates
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
        imageInfo = try container.decode(ImageInfo.self, forKey: .imageInfo)
        thumbnailInfo = try container.decode(ImageInfo.self, forKey: .thumnailInfo)
        thumbnailData = try container.decodeIfPresent(Data.self, forKey: .thumbnailData)
        briefDescription = try container.decode(String.self, forKey: .briefDescription)
        description = try container.decode(String.self, forKey: .description)
        if let location = try? container.decode(Location.self, forKey: .location) {
            self.location = location
        } else if let location = try? container.decode(Location.self, forKey: .coordinates) {
            self.location = location
        } else {
            throw DecodingError.locationError
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(imageInfo, forKey: .imageInfo)
        try container.encode(imageData, forKey: .imageData)
        try container.encode(thumbnailInfo, forKey: .thumnailInfo)
        try container.encode(thumbnailData, forKey: .thumbnailData)
        try container.encode(briefDescription, forKey: .briefDescription)
        try container.encode(description, forKey: .description)
        try container.encode(location, forKey: .location)
        try container.encode(location, forKey: .coordinates)
    }
    
}


//MARK: - Equatable
extension Country: Equatable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.name == rhs.name
    }
}


//MARK: - Location
struct Location: Codable, Hashable, Comparable {
    let lat: Double
    let lon: Double
    
    static func < (lhs: Location, rhs: Location) -> Bool {
        if abs(lhs.lat - rhs.lat) < 0.000_01 {
            return lhs.lon  < rhs.lon
        } else {
            return lhs.lat < rhs.lat
        }
    }
}


//MARK: - ImageInfo
struct ImageInfo: Codable, Hashable {
    let source: String
    let width: Int
    let height: Int
}


//MARK: - Decoding Error
enum DecodingError: Error {
    case locationError
}
