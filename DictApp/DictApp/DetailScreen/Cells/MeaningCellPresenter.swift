//
//  MeaningCellPresenter.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 19.05.2024.
//

import Foundation
import UIKit
import WordsAPI

protocol MeaningCellPresenterProtocol: AnyObject {
    func load()
}

final class MeaningCellPresenter {
    
    weak var view: MeaningTableViewCellProtocol?
    private let model: CustomDefinition
    private let partOfSpeech : String
    
    init(
        view: MeaningTableViewCellProtocol?,
        model: CustomDefinition,
        partOfSpeech : String
    ) {
        self.view = view
        self.model = model
        self.partOfSpeech = partOfSpeech
    }
    
 
}

extension MeaningCellPresenter: MeaningCellPresenterProtocol {
    
    func load() {
      
                   // word dolu ise
        view?.configMeaningCell(model, partOfSpeech: partOfSpeech)
               
    }
    
}

