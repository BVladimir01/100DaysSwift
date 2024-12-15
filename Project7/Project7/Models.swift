//
//  Models.swift
//  Project7
//
//  Created by Vladimir on 15.12.2024.
//

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}
