//
//  MockHomeRouter.swift
//  DictAppTests
//
//  Created by Ece Ok, Vodafone on 25.05.2024.
//

import Foundation
@testable import DictApp
import WordsAPI

//  var isInvokedSearch: (name : String , Void)?
final class MockRouter: HomeRouterProtocol {
    
    var isInvokedNavigateWord :  ([CustomWord], Void)?
    var isInvokedSynonyms : ([SynonymWord], Void)?
    var isInvokedNavigateToDetial = false
    func navigateToDetail(with word: [WordsAPI.CustomWord], synonyms: [WordsAPI.SynonymWord], words: [WordsAPI.Word2]) {
        isInvokedNavigateToDetial = true
        isInvokedSynonyms = (synonyms,())
        isInvokedNavigateWord = (word,())
    }
    
    
    var isInvokedNavigate = false
    var isInvokedNavigateCount = 0
    
    func navigate(_ route: DictApp.HomeRouter) {
        isInvokedNavigate = true
        isInvokedNavigateCount += 1
    }
    
}
