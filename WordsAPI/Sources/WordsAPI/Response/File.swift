//
//  File.swift
//  
//
//  Created by Ece Ok, Vodafone on 17.05.2024.
//

import Foundation
public struct SynonymWordResponse: Decodable {
    
    public var results: [SynonymWord]
    
    private enum RootCodingKeys: String, CodingKey {
        case results
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKeys.self)
        self.results = try container.decode([SynonymWord].self, forKey: .results)
    }
}
