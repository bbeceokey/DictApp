//
//  FilteredCellPresenter.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 19.05.2024.
//

import Foundation
protocol FilteredCellPresenterProtocol: AnyObject {
    func load()
}

// Presenter Sınıfı
final class FilteredCellPresenter {
    
    weak var view: FilteredCollectionViewCellProtocol?
    private let model: String
    
    init(
        view: FilteredCollectionViewCellProtocol?,
        model: String
    ) {
        self.view = view
        self.model = model
    }
}

extension FilteredCellPresenter: FilteredCellPresenterProtocol {
    
    func load() {
        view?.configFilterCell(model)
    }
}
