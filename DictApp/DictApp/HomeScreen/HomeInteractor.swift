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
    func handleResult(result: SynonymResult, wresult: WordResult)
}


typealias WordResult = Result<[Word2],Error>
typealias SynonymResult = Result < [SynonymWord] , Error>

final class HomeInteractor {
    private let wordService : WordsServiceProtocol
    private let synonymService : SynonymServiceProtocol
    var wordResult: WordResult?
    var synonymResult: SynonymResult?

    
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
            self.wordResult = result
            self.tryHandleResults()
        }
    }

    func fetchSynonyms(word: String) {
        synonymService.fetchSynonymWords(for: word) { [weak self] result in
            guard let self = self else { return }
            self.synonymResult = result
            self.tryHandleResults()
        }
    }

    private func tryHandleResults() {
        if let wordResult = wordResult, let synonymResult = synonymResult {
            self.output?.handleResult(result: synonymResult, wresult: wordResult)
            self.wordResult = nil // Clean up after handling
            self.synonymResult = nil // Clean up after handling
        }
    }

}
