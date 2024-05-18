//
//  SynonymService.swift
//
//
//  Created by Ece Ok, Vodafone on 17.05.2024.
//

import Foundation
import Alamofire

public protocol SynonymServiceProtocol {
    func fetchSynonymWords(for searchWord: String, completion: @escaping (Result<[SynonymWord], Error>) -> Void)
}

public class SynonymService : SynonymServiceProtocol {
    
    public init() {}
    
    public func fetchSynonymWords(for searchWord: String, completion: @escaping (Result<[SynonymWord], Error>) -> Void) {
        
        let urlString = "https://api.datamuse.com/words?rel_syn=\(searchWord)"
        
        AF.request(urlString).responseData { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode([SynonymWord].self, from: data)
                    completion(.success(response))
                    print(response)
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

