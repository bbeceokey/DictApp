//
//  SynonymWord.swift
//
//
//  Created by Ece Ok, Vodafone on 17.05.2024.
//

import Foundation
public struct SynonymWord : Decodable {
    public let word: String?
    public let score: Int?
    
    enum CodingKeys : String , CodingKey {
        case word, score
    }
}
