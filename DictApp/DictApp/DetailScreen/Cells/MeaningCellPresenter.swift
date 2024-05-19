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
    private let model: Word2
    
    init(
        view: MeaningTableViewCellProtocol?,
        model: Word2
    ) {
        self.view = view
        self.model = model
    }
    
 
}

extension MeaningCellPresenter: MeaningCellPresenterProtocol {
    
    func load() {
        view?.configMeaningCell(<#T##model: Word2##Word2#>, defCount: <#T##Int#>)
    }
    
}

