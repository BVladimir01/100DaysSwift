//
//  String+Extenstions.swift
//  Hangman
//
//  Created by Vladimir on 20.12.2024.
//

import Foundation

extension String {
    func indicies(of char: Character) -> [Index] {
        var copy = self
        var result = [Index]()
        while let i = copy.firstIndex(of: char) {
            result.append(i)
            copy.remove(at: i)
        }
        return result
    }
}
