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
    func getFilteredWords() -> [CustomWord]
    func getDefinition(at index: Int) -> (definition: CustomDefinition, partOfSpeech: String)
    func setWordDetail()
    func numberOfFilter() -> Int
    
}

final class DetailPresenter {
    
    unowned var view: DetailViewControllerProtocol?
    let router: DetailRouterProtocol!
    private var filteredLists = [String]()
    private var synonymLists = [String]()
    private var csWords = [CustomWord]()
    let interactor: DetailInteractorProtocol
    
    private var allWords = [CustomWord]()
    private var filteredWords = [CustomWord]()
    private var filteredDefinitions = [(definition: CustomDefinition, partOfSpeech: String)]()
    private var allDefinitions = [(definition: CustomDefinition, partOfSpeech: String)]()
    
    init(
        view: DetailViewControllerProtocol,
        router: DetailRouterProtocol!,
        interactor: DetailInteractor
    ) {
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
        if let phonetics = words.phonetics, let firstPhonetic = phonetics.first {
            view.setWordRead(firstPhonetic.text)
        } else {
            view.setWordRead("")
        }
    }
    
    func getFilteredWords() -> [WordsAPI.CustomWord] {
        return filteredWords
    }
    
 
    
    func viewDidload() {
        guard let view = view else { return }
                filteredLists = view.getFilterdeLists()
                synonymLists = view.getSynonyms().map { $0.word! }
                csWords = view.getDictionary()
                view.setUpWordTable()
                view.setUpFiltered()
                view.setUpSynonyms()
                allDefinitions = view.getDictionary().flatMap { word in
                    word.definitions.map { (definition: $0, partOfSpeech: word.partOfSpeech) }
                }
                filteredDefinitions = allDefinitions
                filteredWords = csWords
                view.reloadWordTable()
                view.reloadFilterTable()
        }

        func numberOfTable() -> Int {
            return filteredDefinitions.count
        }
    
    func numberOfFilter() -> Int{
        return filteredLists.count
    }
    

    func didSelectFilter(_ index: Int) {
            guard let view = view else { return }
            let selectedFilter = view.getFilterdeLists()[index]
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
}
