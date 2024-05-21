//
//  Word.swift
//
//
//  Created by Ece Ok, Vodafone on 17.05.2024.
//

import Foundation

public struct Word2 : Decodable {
    public let word: String?
    public let phonetics: [Phonetic]?
    public let meanings: [Meaning]?
    public let license: License?
    public let sourceUrls: [String]?
    
    // Boş yapılandırıcı
      public init() {
          self.word = nil
          self.phonetics = []
          self.meanings = []
          self.license = nil
          self.sourceUrls = []
      }
    }


// MARK: - License
public struct License : Decodable {
    public let name: String
    public let url: String
}

// MARK: - Meaning
public struct Meaning : Decodable {
    public let partOfSpeech: String
    public let definitions: [Definition]
    public let synonyms, antonyms: [String]
}

// MARK: - Definition
public struct Definition : Decodable {
    public let definition: String?
    public let example: String?
}

// MARK: - Phonetic
public struct Phonetic : Decodable {
    public let audio: String
    public let sourceURL: String?
    public let license: License?
    public let text: String?
}

public struct CustomDefinition {
    public let definition: String
    public let example: String?

    public init(definition: String, example: String? = nil) {
        self.definition = definition
        self.example = example
    }
}

public struct CustomWord {
    public let audio: String?
    public let definitions: [CustomDefinition]
    public let partOfSpeech: String

    public init(partOfSpeech: String, definitions: [CustomDefinition], audio: String? = nil) {
        self.partOfSpeech = partOfSpeech
        self.definitions = definitions
        self.audio = audio
    }
}
