//
//  DetailPresenter.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 18.05.2024.
//

import Foundation
import WordsAPI

protocol DetailPresenterProtocol: AnyObject {
    func viewDidload()
    func numberOfTable() -> Int
    func didSelectFilter(_ index: Int)
    func getFilteredWords() -> [CustomDefinition]
    func getDefinition(at index: Int) -> (definition: CustomDefinition, partOfSpeech: String)
    func setWordDetail()
    func numberOfFilter() -> Int
    func getSynonyms() -> [SynonymWord]
    func getAudioURL() -> String?
}

final class DetailPresenter {
    
    unowned var view: DetailViewControllerProtocol?
    let router: DetailRouterProtocol
    let interactor: DetailInteractorProtocol
    
    private var filteredLists = [String]()
    private var synonymLists = [SynonymWord]()
    private var csWords = [CustomWord]()
    private var allDefinitions = [(definition: CustomDefinition, partOfSpeech: String)]()
    private var filteredDefinitions = [(definition: CustomDefinition, partOfSpeech: String)]()
    
    init(view: DetailViewControllerProtocol, router: DetailRouterProtocol, interactor: DetailInteractorProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    
    func setWordDetail() {
        guard let view = view else { return }
        let words = view.getWords()
        view.setWordName(words.word!)
        if let phonetics = words.phonetics {
            if let firstPhonetic = phonetics.first {
                view.setWordRead(firstPhonetic.text ?? "")
                if firstPhonetic.text == nil {
                    for phonetic in phonetics {
                        if phonetic.text != nil {
                            view.setWordRead(phonetic.text ?? "")
                            return
                        }
                        
                    }
                }
                
            } else {
                view.setWordRead("")
            }
        }
    }
    
    func getFilteredWords() -> [CustomDefinition] {
        return filteredDefinitions.map { $0.definition}
    }
    
    func viewDidload() {
        guard let view = view else { return }
        filteredLists = view.getFilteredLists()
        synonymLists = view.getSynonyms()
        csWords = view.getDictionary()
        
        view.setUpWordTable()
        view.setUpFiltered()
        view.setUpSynonyms()
        
        allDefinitions = view.getDictionary().flatMap { word in
            word.definitions.map { (definition: $0, partOfSpeech: word.partOfSpeech) }
        }
        filteredDefinitions = allDefinitions
        view.reloadWordTable()
        view.reloadFilterTable()
    }
    
    func numberOfTable() -> Int {
        return filteredDefinitions.count
    }
    
    func numberOfFilter() -> Int {
        return filteredLists.count
    }
    
    func didSelectFilter(_ index: Int) {
        guard let view = view else { return }
        let selectedFilter = view.getFilteredLists()[index]
        if selectedFilter.isEmpty {
            filteredDefinitions = allDefinitions
        } else {
            filteredDefinitions = allDefinitions.filter { $0.partOfSpeech == selectedFilter }
        }
        view.reloadWordTable()
    }
    
    func getDefinition(at index: Int) -> (definition: CustomDefinition, partOfSpeech: String) {
        return filteredDefinitions[index]
    }

    func getSynonyms() -> [SynonymWord] {
        let sortedSynonyms = synonymLists.sorted(by: { $0.score ?? 0 > $1.score ?? 0 })
        let topFiveSynonyms = Array(sortedSynonyms.prefix(5))
        return topFiveSynonyms
    }
    
    func getAudioURL() -> String? {
           return interactor.getAudioURL()
       }
}
