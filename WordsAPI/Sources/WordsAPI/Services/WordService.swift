//
//  File.swift
//  
//
//  Created by Ece Ok, Vodafone on 17.05.2024.
//

import Foundation
import Alamofire

public protocol WordsServiceProtocol {
    func fetchWords(for searchWord: String, completion: @escaping (Result<[Word2], Error>) -> Void)
}

public class WordsService: WordsServiceProtocol {
    
    public init() {}
    
    public func fetchWords(for searchWord: String, completion: @escaping (Result<[Word2], Error>) -> Void) {
        
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(searchWord)"
        
        AF.request(urlString).responseData { [weak self] response in
            guard self != nil else { return }
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode([Word2].self, from: data)
                    print(response)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
