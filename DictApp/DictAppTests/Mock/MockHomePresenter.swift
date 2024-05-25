//
//  MockHomePresenter.swift
//  DictAppTests
//
//  Created by Ece Ok, Vodafone on 24.05.2024.
//

import XCTest
@testable import DictApp
import CoreData
import WordsAPI

final class HomePresenterTests: XCTestCase {
    
    var presenter: HomePresenter!
    var view: MockHomeViewController!
    var interactor: MockHomeInteractor!
    var router: MockRouter!
    var coreDataManager: MockCoreDataManager!
    
    
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
    
    override func setUp() {
        super.setUp()
        let container = NSPersistentContainer(name: "DictApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        
        // Persistent store'ları yükle
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        
        persistentContainer = container
        
        view = MockHomeViewController()
        interactor = MockHomeInteractor()
        router = MockRouter()
        coreDataManager = MockCoreDataManager()
        presenter = HomePresenter(view: view, interactor: interactor, router: router, coreDataManager: coreDataManager)
        //persistentContainer = NSPersistentContainer(name: "DictApp")
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        interactor = nil
        router = nil
        presenter = nil
        coreDataManager = nil
    }
    
    func testCoreDataManager(){
        // test fetchData
        XCTAssertFalse(coreDataManager.isInvokedFetchData, "fetchData() should not be invoked initially.")
        XCTAssertEqual(coreDataManager.isInvokedFetchCount, 0, "fetchData() should not be invoked initially.")
        let data = coreDataManager.fetchData()
        XCTAssertTrue(coreDataManager.isInvokedFetchData, "fetchData() should be invoked.")
        XCTAssertEqual(coreDataManager.isInvokedFetchCount, 1, "fetchData() should be invoked once.")
        XCTAssertNotNil(data, "fetchData() should return dummy data.")
        XCTAssertEqual(data?.first?.name, "hello", "The returned data's name should be 'hello'.")
        
        // Test deleteWordData
        XCTAssertFalse(coreDataManager.isInvokedDeleteData, "deleteWordData(_:) should not be invoked initially.")
        XCTAssertEqual(coreDataManager.isInvokedDeleteCount, 0, "deleteWordData(_:) should not be invoked initially.")
        let wordData = WordData(context: coreDataManager.persistentContainer.viewContext)
        wordData.name = "hello"
        coreDataManager.deleteWordData(wordData)
        XCTAssertTrue(coreDataManager.isInvokedDeleteData, "deleteWordData(_:) should be invoked.")
        XCTAssertEqual(coreDataManager.isInvokedDeleteCount, 1, "deleteWordData(_:) should be invoked once.")
        
        // Test saveContext
        XCTAssertFalse(coreDataManager.isInvokeSaved, "saveContext() should not be invoked initially.")
        XCTAssertEqual(coreDataManager.isInvokeSavedCount, 0, "saveContext() should not be invoked initially.")
        coreDataManager.saveContext()
        XCTAssertTrue(coreDataManager.isInvokeSaved, "saveContext() should be invoked.")
        XCTAssertEqual(coreDataManager.isInvokeSavedCount, 1, "saveContext() should be invoked once.")
        
        // Test saveRecentSearch
        XCTAssertFalse(coreDataManager.isInvokeSavedRecent, "saveRecentSearch(name:) should not be invoked initially.")
        XCTAssertEqual(coreDataManager.isInvokeSavedRecentCount, 0, "saveRecentSearch(name:) should not be invoked initially.")
        coreDataManager.saveRecentSearch(name: "hello")
        XCTAssertTrue(coreDataManager.isInvokeSavedRecent, "saveRecentSearch(name:) should be invoked.")
        XCTAssertEqual(coreDataManager.isInvokeSavedRecentCount, 1, "saveRecentSearch(name:) should be invoked once.")
    }
    
    
    func testAllOfInvoked(){
        let wordData = WordData(context: coreDataManager.persistentContainer.viewContext)
        wordData.name = "hello"
        coreDataManager.mockData = [wordData] // Ensure the mock data is set
        
        XCTAssertFalse(view.isInvokeReloadTable, "Table reload should not be invoked initially.")
        XCTAssertFalse(view.isInvokeRecentSearch, "Recent search should not be invoked initially.")
        XCTAssertFalse(view.isInvokeShowAlert, "Show alert should not be invoked initially.")
        XCTAssertNil(view.isInvokedSetSeacrhes?.searches, "Searches should be nil initially.")
        
        presenter.tableViewUpdate()
        view.displayRecentSearches([wordData])
        view.showAlertDismiss()
        
        XCTAssertTrue(view.isInvokeReloadTable, "Table reload should be invoked.")
        XCTAssertTrue(view.isInvokeRecentSearch, "Recent search should be invoked.")
        XCTAssertTrue(view.isInvokeShowAlert, "Show alert should be invoked.")
        XCTAssertEqual(view.isInvokedSetSeacrhes?.searches, [wordData], "Searches should contain the test wordData.")
        
    }
    
    
    func testInvokedRouter(){
        XCTAssertFalse(router.isInvokedNavigateToDetial, "navigateToDetail() should not be invoked initially.")
        XCTAssertNil(router.isInvokedNavigateWord, "navigateToDetail() should not have any words initially.")
        XCTAssertNil(router.isInvokedSynonyms, "navigateToDetail() should not have any synonyms initially.")
        
        // Perform the action
        let customWords = [WordsAPI.CustomWord]()
        let synonymWords = [WordsAPI.SynonymWord]()
        let words = [WordsAPI.Word2]()
        router.navigateToDetail(with: customWords, synonyms: synonymWords, words: words)
        
        // Assert the expected state after action (True checks)
        XCTAssertTrue(router.isInvokedNavigateToDetial, "navigateToDetail() should be invoked.")
        XCTAssertNotNil(router.isInvokedNavigateWord, "navigateToDetail() should have words set.")
        XCTAssertNotNil(router.isInvokedSynonyms, "navigateToDetail() should have synonyms set.")
    }
    
    
    func testInvokedInteractor() {
       
        XCTAssertFalse(interactor.fetchWordDetailCalled, "fetchWordDetail(word:) should not be called initially.")
        XCTAssertEqual(interactor.fetchWordDetailCount, 0, "fetchWordDetail(word:) should not be called initially.")
        XCTAssertNil(interactor.fetchWordDetailWord, "fetchWordDetail(word:) should not have any word initially.")
        
 
        let testWord = Word2.testWord.word ?? "Car"
        interactor.fetchWordDetail(word: testWord)
        
       
        XCTAssertTrue(interactor.fetchWordDetailCalled, "fetchWordDetail(word:) should be called.")
        XCTAssertEqual(interactor.fetchWordDetailCount, 1, "fetchWordDetail(word:) should be called once.")
        XCTAssertEqual(interactor.fetchWordDetailWord, testWord, "fetchWordDetail(word:) should be called with the correct word.")
        
    }

}

extension Word2 {

    static var testWord: Word2 {
        let bundle = Bundle(for: HomePresenterTests.self)
        let path = bundle.path(forResource: "Word", ofType: "json")!
        let file = try! String(contentsOfFile: path)
        let data = file.data(using: .utf8)!
        let testWord = try! JSONDecoder().decode([Word2].self, from: data)
        return testWord[0]
    }
    
}



class MockWordData: NSManagedObject {
    @NSManaged var word: String

    convenience init(word: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.word = word
    }
}




struct MockSynonyms {
    let word : String
    let score : Int
}

import CoreData

class WordData: NSManagedObject {
    @NSManaged var name: String
}
