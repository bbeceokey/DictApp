//
//  MockCoreDataManager.swift
//  DictAppTests
//
//  Created by Ece Ok, Vodafone on 25.05.2024.
//

import Foundation
import CoreData
@testable import DictApp

final class MockCoreDataManager: CoreDataManagerProtocol {

    typealias WordData = DictApp.WordData
        
        var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "DictApp")
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Unresolved error \(error)")
                }
            }
            return container
        }()
        
    var isInvokedFetchData = false
    var isInvokedFetchCount = 0
    func fetchData() -> [DictApp.WordData]? {
        isInvokedFetchData = true
        isInvokedFetchCount += 1
        var wordData = WordData(context: persistentContainer.viewContext)
        wordData.name = "hello"
        let dummyWordData = [wordData]
        return dummyWordData
    }
    
    var isInvokedDeleteData = false
    var isInvokedDeleteCount = 0
    func deleteWordData(_ data: DictApp.WordData) {
        isInvokedDeleteData = true
        isInvokedDeleteCount += 1
    }
    
    var mockData: [WordData] = []
    var isInvokeSaved = false
    var isInvokeSavedCount = 0
    func saveContext() {
        isInvokeSaved = true
        isInvokeSavedCount += 1
    }
    
    var isInvokeSavedRecent = false
    var isInvokeSavedRecentCount = 0
    func saveRecentSearch(name: String) {
        isInvokeSavedRecent = true
        isInvokeSavedRecentCount += 1
    }
    
}
