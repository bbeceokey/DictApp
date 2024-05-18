//
//  HomeInteractor.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 17.05.2024.
//

import Foundation
import WordsAPI

protocol HomeInteractorProtocol {
    func fetchWordDetail( word : String)
    func fetchSynonyms( word : String)
    
}
protocol HomeOutputInteractorProtocol : AnyObject {
    func handleWordResult(result : WordResult)
    func handleSynonymResult(result : SynonymResult)
}


typealias WordResult = Result<[Word2],Error>
typealias SynonymResult = Result < [SynonymWord] , Error>

final class HomeInteractor {
    private let wordService : WordsServiceProtocol
    private let synonymService : SynonymServiceProtocol
    
    weak var output : HomeOutputInteractorProtocol?
    
    init(wordService: WordsServiceProtocol = WordsService(), synonymService: SynonymServiceProtocol = SynonymService()) {
        self.wordService = wordService
        self.synonymService = synonymService
        
    }
}


extension HomeInteractor: HomeInteractorProtocol {
    func fetchWordDetail(word: String) {
            wordService.fetchWords(for: word) { [weak self] result in
                guard let self = self else { return }
                self.output?.handleWordResult(result: result)
            }
        }
        
        func fetchSynonyms(word: String) {
            synonymService.fetchSynonymWords(for: word) { [weak self] result in
                guard let self = self else { return }
                self.output?.handleSynonymResult(result: result)
            }
        }
}
