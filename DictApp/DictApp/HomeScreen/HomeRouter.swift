//
//  HomeRouter..swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 17.05.2024.
//

import Foundation
import UIKit
import WordsAPI
import CoreData

protocol HomeRouterProtocol: AnyObject {
    func navigateToDetail(with word: [Word2], synonyms: [SynonymWord])
}

final class HomeRouter {
    weak var navigationController: UINavigationController?
    private weak var mainVC: HomeViewController?

    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }

    static func createModule() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(view: view, interactor: interactor, router: router, coreDataManager: CoreDataManager.shared)
        view.presenter = presenter
        interactor.output = presenter
        router.mainVC = view // mainVC ataması burada yapılmalı

        return view
    }
}

extension HomeRouter: HomeRouterProtocol {
    func navigateToDetail(with word: [Word2], synonyms: [SynonymWord]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.words = word
        detailVC.synonyms = synonyms
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
