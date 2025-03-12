//
//  Country.swift
//  Challenge69
//
//  Created by Vladimir on 11.03.2025.
//

struct Country: Decodable, Equatable {
    
    let name: String
    let imageURL: String
    let thumbnailURL: String
    let briefDescription: String
    let location: Location
    let description: String
    
    private struct ImageInfo: Decodable {
        let source: String
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case descriptionBrief = "description"
        case location = "location"
        case description = "extract"
        case thumbnail = "thumbnail"
        case originalImage = "originalimage"
        case coordinates = "coordinates"
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
        let container = try decoder.container(keyedBy: Country.CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.briefDescription = try container.decode(String.self, forKey: .descriptionBrief)
        self.description = try container.decode(String.self, forKey: .description)
        if let location = try? container.decode(Location.self, forKey: .location) {
            self.location = location
        } else if let location = try? container.decode(Location.self, forKey: .coordinates) {
            self.location = location
        } else {
            throw DecodingError.locationError
        }
        let thumbnailImageInfo = try container.decode(ImageInfo.self, forKey: .thumbnail)
        self.thumbnailURL = thumbnailImageInfo.source
        let originalImageInfo = try container.decode(ImageInfo.self, forKey: .originalImage)
        self.imageURL = originalImageInfo.source
    }
    
    enum DecodingError: Error {
        case locationError
    }

}


struct Location: Decodable, Equatable {
    let lat: Double
    let lon: Double
}
