//
//  MockHomeInteractor.swift
//  DictAppTests
//
//  Created by Ece Ok, Vodafone on 24.05.2024.
//

import Foundation
@testable import DictApp

final class MockHomeInteractor: HomeInteractorProtocol {
    var fetchWordDetailCalled = false
    var fetchWordDetailCount = 0
    var fetchWordDetailWord: String?

    var fetchSynonymsCalled = false
    var fetchSynonymsCount = 0
    var fetchSynonymsWord: String?

    func fetchWordDetail(word: String) {
        fetchWordDetailCalled = true
        fetchWordDetailCount += 1
        fetchWordDetailWord = word
    }

    func fetchSynonyms(word: String) {
        fetchSynonymsCalled = true
        fetchSynonymsCount += 1
        fetchSynonymsWord = word
    }
    
}
