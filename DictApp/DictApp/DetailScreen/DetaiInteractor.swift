//
//  DetaiInteractor.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 18.05.2024.
//

import Foundation
import WordsAPI


protocol DetailInteractorProtocol: AnyObject {
    func fetchFilteredWords(partOfSpeech: String) -> [CustomWord]
    func getAudioURL() -> String?
}



final class DetailInteractor {
    private var csWords: [CustomWord]
    
    init(csWords: [CustomWord]) {
        self.csWords = csWords
    }
}

extension DetailInteractor: DetailInteractorProtocol {
    func fetchFilteredWords(partOfSpeech: String) -> [CustomWord] {
        return csWords.filter { $0.partOfSpeech == partOfSpeech }
    }
    
    func getAudioURL() -> String? {
        print(csWords.first?.audio)
           return csWords.first?.audio
       }
}
