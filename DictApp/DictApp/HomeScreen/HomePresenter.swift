//
//  HomePresenter.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 17.05.2024.
//

import Foundation
import WordsAPI
import CoreData

protocol HomePresenterProtocol{
    func searchWord(word: String)
    func tableViewUpdate()
    func numberOfRows() -> Int
    func fetchRecentSearches() -> [WordData]
    func deleteRecentSearch(at index: Int)
    func tappledWord(word: String)
}


final class HomePresenter {
    private var words: [Word2]?
    private var customWord: [CustomWord]?
    private var synonym : [SynonymWord]?
    private let coreDataManager: CoreDataManagerProtocol?
    weak var view : HomeViewControllerProtocol?
    private var interactor : HomeInteractorProtocol?
    var router: HomeRouterProtocol?
    private var recentSearches : [WordData]?
    init(view: HomeViewControllerProtocol? = nil, interactor: HomeInteractorProtocol? = nil , router: HomeRouterProtocol? = nil, coreDataManager: CoreDataManagerProtocol? = nil ) {
        self.view = view
        self.interactor = interactor
        self.coreDataManager = coreDataManager
        self.router = router
    }
}

extension HomePresenter: HomePresenterProtocol {
    func deleteRecentSearch(at index: Int) {
        if let data = recentSearches?[index] {
            recentSearches?.remove(at: index)
            view?.reloadTableView()
            coreDataManager?.deleteWordData(data)
        } else {
            print("silinme olmadı")
        }
        
    }
    
    func fetchRecentSearches() -> [WordData]{
        if let data = coreDataManager?.fetchData() {
            recentSearches = Array(data.reversed().prefix(5))
            return recentSearches ?? []
        } else {
            return []
        }
       
    }

    func tableViewUpdate() {
        view?.reloadTableView()
    }
    
    
    func numberOfRows() -> Int {
        return recentSearches?.count ?? 0
    }
    
    
    func searchWord(word: String) {
        let validWordPattern = "^[a-zA-ZğüşöçİĞÜŞÖÇ]+$"  // Sadece Türkçe harfler, İngilizce harfler
        let regex = try? NSRegularExpression(pattern: validWordPattern)
        let range = NSRange(location: 0, length: word.utf16.count)
        if regex?.firstMatch(in: word, options: [], range: range) == nil {
               view?.showAlertDismiss(text:"Please some word, not numerical and random types.")
               return
           }
        if word != ""{
            updateCore(word: word)
            interactor?.fetchWordDetail(word: word)
            interactor?.fetchSynonyms(word: word)
            tableViewUpdate()
        }
       
    }
    
    func tappledWord(word: String){
        interactor?.fetchWordDetail(word: word)
        interactor?.fetchSynonyms(word: word)
    }
    
    func updateCore(word: String){
        coreDataManager?.saveRecentSearch(name: word)
    }
}

extension HomePresenter: HomeOutputInteractorProtocol {
    func handleWordResult(result: WordResult) {
        var audio = ""
        switch result {
            
        case .success(let word):
            if let words = words, !words.isEmpty {
                if let meanings = words[0].meanings{
                    if let audiopho = words[0].phonetics?[0].audio{
                        audio = audiopho
                    }
                    var CustomWords = [CustomWord]()
                    for definition in meanings {
                        let partOfSpeech = definition.partOfSpeech
                        var customDefs = [CustomDefinition]()
                        for def in definition.definitions{
                            var customdef = CustomDefinition(definition: def.definition ?? " ", example: def.example ?? " ")
                            customDefs.append(customdef)
                        }
                        var csWord = CustomWord(partOfSpeech: partOfSpeech, definitions: customDefs, audio: audio )
                        CustomWords.append(csWord)
                    }
                    customWord = CustomWords
                }
            }
          
            navigateIfReady()
        case .failure(let error):
            view?.showAlertDismiss(text:"Don't find a word,Please entry new word")
            print(error)
            //view?.displayError(error: error)
        }
    }
    
    func handleSynonymResult(result: SynonymResult) {
        switch result {
        case .success(let synonyms):
            synonym = synonyms
            navigateIfReady()
        case .failure(let error):
            print(error)
            view?.showAlertDismiss(text:"Don't find a word,Please entry new word")
        }
    }
    
    func handleResult(result: SynonymResult, wresult: WordResult) {
        switch result {
        case .success(let synonyms):
            switch wresult {
            case .success(let words):
                self.words = words
                self.synonym = synonyms
                
                guard let firstWord = words.first else {
                    print("No words available")
                    return
                }
                
                let audio = firstWord.phonetics?.first?.audio ?? ""
                
                guard let meanings = firstWord.meanings else {
                    print("No meanings available")
                    return
                }
                
                let customWords = meanings.map { meaning -> CustomWord in
                    let partOfSpeech = meaning.partOfSpeech
                    let customDefs = meaning.definitions.map { def -> CustomDefinition in
                        CustomDefinition(definition: def.definition ?? " ", example: def.example ?? " ")
                    }
                    return CustomWord(partOfSpeech: partOfSpeech, definitions: customDefs, audio: audio)
                }
                
                self.customWord = customWords
                
                navigateIfReady()
            case .failure(let error):
                view?.showAlertDismiss(text:"Don't find a word,Please entry new word")
                print(error)
            }
        case .failure(let error):
            print(error)
        }
    }


    private func navigateIfReady() {
        guard let csword = customWord, let synonyms = synonym else {
            return
        }
        if let wordss  = words {
            router?.navigateToDetail(with: csword, synonyms: synonyms , words: wordss)
        }
        
    }

}
