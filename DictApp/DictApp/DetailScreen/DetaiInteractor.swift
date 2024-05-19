//
//  DetaiInteractor.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 18.05.2024.
//

import Foundation


protocol DetailInteractorProtocol {
    func viewDidLoad()
    func numberOfItems() -> Int
    func news(_ index: Int) -> News?
    func didSelectRowAt(_ index: Int)
}


final class DetaiInteractor {
    unowned var view: DetailViewController!
    let router: HomeRouterProtocol!
    let interactor: HomeInteractorProtocol!
    
    private var news: [News] = []
    
    init(
        view: HomeViewControllerProtocol,
        router: HomeRouterProtocol,
        interactor: HomeInteractorProtocol
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}
