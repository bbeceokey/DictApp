//
//  MockHomeViewController.swift
//  DictAppTests
//
//  Created by Ece Ok, Vodafone on 24.05.2024.
//

import Foundation
@testable import DictApp

final class MockHomeViewController : HomeViewControllerProtocol {
    
    var isInvokeRecentSearch = false
    var isInvokeRecentSearchCount = 0
    var isInvokedSetSeacrhes : ( searches: [DictApp.WordData], Void)?
    
    func displayRecentSearches(_ searches: [DictApp.WordData]) {
        isInvokeRecentSearch = true
        isInvokeRecentSearchCount += 1
        isInvokedSetSeacrhes = (searches,())
    }
    
    var isInvokeReloadTable = false
    var isInvokeReloadTableCount = 0
    func reloadTableView() {
        isInvokeReloadTable = true
        isInvokeReloadTableCount += 1
    }
    
    var isInvokeShowAlert = false
    var isInvokeShowAlertCount = 0
    func showAlertDismiss() {
        isInvokeShowAlert = true
        isInvokeShowAlertCount += 1
    }
    
    
}
