//
//  DetailRouter.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 18.05.2024.
//

import Foundation
import UIKit

protocol DetailRouterProtocol{
    
}

final class DetailRouter{
    weak var viewController: UIViewController?
        
        init(viewController: UIViewController) {
            self.viewController = viewController
        }
}
extension DetailRouter: DetailRouterProtocol {
    
}
