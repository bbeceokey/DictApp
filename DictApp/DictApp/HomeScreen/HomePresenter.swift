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
        let data = recentSearches![index]
        recentSearches?.remove(at: index)
        //recentSearches = fetchRecentSearches()
        view?.reloadTableView()
        coreDataManager?.deleteWordData(data)
    }
    
    func fetchRecentSearches() -> [WordData]{
        if let data = coreDataManager?.fetchData() {
            recentSearches = Array(data.reversed().prefix(5))
            return recentSearches!
        } else {
            return []
        }
       
    }

    func tableViewUpdate() {
        view?.reloadTableView()
    }
    
    
    func numberOfRows() -> Int {
        print(recentSearches?.count)
        return recentSearches?.count ?? 0
    }
    
    
    func searchWord(word: String) {
        updateCore(word: word)
        interactor?.fetchWordDetail(word: word)
        interactor?.fetchSynonyms(word: word)
        tableViewUpdate()
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
        switch result {
        case .success(let word):
            words = word
            navigateIfReady()
        case .failure(let error):
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
            //view?.displayError(error: error)
        }
    }

    private func navigateIfReady() {
        guard let word = words, let synonyms = synonym else {
            return
        }
        router?.navigateToDetail(with: word, synonyms: synonyms)
    }

}
